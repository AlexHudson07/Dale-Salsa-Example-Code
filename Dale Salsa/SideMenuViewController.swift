import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import MessageUI

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var songsLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableViewWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!

    let defaults = UserDefaults.standard
    var songs:[Song] = SongManager.sharedInstance.listOfSongs
    var dataBase: FIRDatabaseReference!
    var storage: FIRStorage!
    
    let manager = FileManager.default
    let defaultDirictory = FileManager.SearchPathDirectory.libraryDirectory
    let defaultDomain = FileManager.SearchPathDomainMask.userDomainMask
    let defaultURLIndex = 0

    var unlockedSongs = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: k.sideMenuViewController, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBase = FIRDatabase.database().reference()
        storage = FIRStorage.storage()

        feedbackButton?.layer.cornerRadius = 4
        tutorialButton?.layer.cornerRadius = 4
        
        loadSongsData()
        setText()
        
        let songNib = UINib(nibName: k.songCell, bundle: nil)
        tableView.register(songNib, forCellReuseIdentifier: k.songCellId)
        
        let slideNib = UINib(nibName: k.slideLeftCell, bundle: nil)
        tableView.register(slideNib, forCellReuseIdentifier: k.slideLeftCellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        unlockedSongs = defaults.bool(forKey: k.unlockedSalsaSongs)

        tableViewWidthContraint.constant = k.rearViewRevealWidth
        tableView.setEditing(false, animated: true)
        tableView.reloadData()
    }
    
    //MARK: - Firebase Calls
    func loadSongsData() {
        weak var weakSelf = self
        dataBase.child(k.datebaseSongs).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let songList = snapshot.value as? NSArray else {
                print("data unreadable")
                return
            }
            
            for song in songList {
                guard let songInfo = song as? [String: Any]
                    else { print("could not parse songInfo SMVC61"); return }
                do {
                    let newSong = try Song(fromDictionary: songInfo)
                    
                    var index: Int?
                    
                    for song in self.songs {
                        if song.songId == newSong.songId {
                            index = self.songs.index(of: song)
                        }
                    }
                    
                    if index != nil {
                        self.songs[index!] = newSong
                    } else {
                        weakSelf?.songs.append(newSong)
                    }
                } catch {
                    print("could not parse song SMVC65")
                }
            }
            
            SongManager.sharedInstance.saveToLibrary(songs:(weakSelf?.songs)!)
            weakSelf?.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func downloadSong(name: String, indexPath: IndexPath) {
        var url = manager.urls(for: defaultDirictory, in: defaultDomain)[defaultURLIndex]
        url.appendPathComponent("\(name).mp3")
        
        let songReference = storage.reference(forURL:k.storageReference + name + k.songExtention)
        
        let task = songReference.write(toFile: url) { (URL, error) -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            } else {
               self.tableView.reloadData()
            }
        }
        
        weak var weakSelf = self

        task.observe(.progress) { (snapshot) -> Void in
            if (snapshot.progress?.totalUnitCount)! < 1 { return }
            
            let percentComplete = Int64(100.0)  * (snapshot.progress?.completedUnitCount)! / (snapshot.progress?.totalUnitCount)!
            
            let cell = weakSelf?.tableView?.cellForRow(at: indexPath) as? SongCell
            cell?.songPercentage = CGFloat(percentComplete)
        }
    }

    //MARK: - File System
    func songIsDownloaded(name: String) -> Bool {
        if name == k.firstSongName {return true}
        let uri = name + k.songExtention
        var url = manager.urls(for: defaultDirictory, in: defaultDomain)[defaultURLIndex]
        url.appendPathComponent(uri)

        return manager.fileExists(atPath: url.path)
    }
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == songs.count {
            let cell: SlideLeftCell = self.tableView.dequeueReusableCell(withIdentifier: k.slideLeftCellId) as! SlideLeftCell
            return cell;
        } else {
            let song = songs[(indexPath as NSIndexPath).row]
            let cell: SongCell = self.tableView.dequeueReusableCell(withIdentifier: k.songCellId) as! SongCell
            
            cell.songName = song.name
            cell.artist = song.artist
            cell.selectionStyle = .none

            if unlockedSongs {
                cell.showUnlockedLabel()
            } else {
                cell.showLockedLabel()
            }
            cell.songIsDownloaded = songIsDownloaded(name: song.name)
            return cell
        }
    }
    
    var tapViewController: TapViewController!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if songIsDownloaded(name: songs[indexPath.row].name) {
            tapViewController = TapViewController()
            tapViewController.song = songs[(indexPath as NSIndexPath).row]
            revealViewController()?.delegate? = tapViewController
            revealViewController()?.pushFrontViewController(tapViewController, animated: true)
            return
        }
        if !unlockedSongs {
            presentUnlockSongsVC(songIndex: indexPath.row)
            return
        }
        downloadSong(name: songs[indexPath.row].name, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let fakeButton = UITableViewRowAction(style: .default,
                                              title: "",
                                              handler: fakeButtonTap)
        
        fakeButton.backgroundColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        
        let song = songs[indexPath.row]
        let artistViewController = ArtistInfoViewController(artistName: song.artist,
                                                            currentArtistId: song.artistId,
                                                            song: song.name,
                                                            storeURLString: song.storeURL)
        
        revealViewController()?.pushFrontViewController(artistViewController, animated: true)

        return [fakeButton]
    }
    
    func fakeButtonTap(action: UITableViewRowAction, indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == songs.count {
            return 45;
        }
        return 122;
    }

    override var prefersStatusBarHidden : Bool {
       return true
    }

    //MARK: Buttons
    @IBAction func onTutorialButtonPressed(_ sender: AnyObject) {
       
        defaults.set(false, forKey: k.tutorialComplete)

        tapViewController = TapViewController()
        tapViewController.song = songs[0]
        
        revealViewController()?.delegate? = tapViewController
        revealViewController()?.pushFrontViewController(tapViewController, animated: true)
    }


    @IBAction func onGiveFeedBackButtonPressed(_ sender: Any) {

        if MFMailComposeViewController.canSendMail() {
            sendEmail()
        } else {
            let alert = UIAlertController(title: "",
                                          message: NSLocalizedString("feed-back-email.error", comment: ""),
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: NSLocalizedString("feed-back-email.error-button.title", comment: ""),
                                          style: .default) { action in
                alert.dismiss(animated: true, completion: nil)
            })

            present(alert, animated: true, completion: nil)
            return
        }
    }

    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self

        composeVC.setToRecipients([k.supportEmail])
        composeVC.setSubject(NSLocalizedString("feed-back-email.subject", comment: ""))
        composeVC.setMessageBody(NSLocalizedString("feed-back-email.message-body", comment: ""), isHTML: false)

        self.present(composeVC, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func presentUnlockSongsVC(songIndex: Int) {
        let unlockViewController = UnlockSongsViewController()
        revealViewController()?.delegate? = unlockViewController
        revealViewController()?.pushFrontViewController(unlockViewController, animated: true)
    }

    //MARK: - Localization
    func setText() {
        songsLabel?.text = NSLocalizedString("sideMenu-viewController.songs-label.text", comment: "")
        feedbackButton?.setTitle(NSLocalizedString("sideMenu-viewController.feedback-button.title", comment: ""), for: .normal)
        tutorialButton?.setTitle(NSLocalizedString("sideMenu-viewController.tutorial-button.title", comment: ""), for: .normal)
    }
}
