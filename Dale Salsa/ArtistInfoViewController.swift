import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ArtistInfoViewController: UIViewController, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var nameLabelView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var artistName: String
    var song: String
    var currentArtistId: Int
    var storeURLString: String
    var pageURLString: String?
    var dataBase: FIRDatabaseReference!
    var storage: FIRStorage!
    
    let manager = FileManager.default
    let defaultDirictory = FileManager.SearchPathDirectory.libraryDirectory
    let defaultDomain = FileManager.SearchPathDomainMask.userDomainMask
    let defaultURLIndex = 0

    init(artistName: String,  currentArtistId: Int, song: String, storeURLString: String) {
        self.artistName = artistName
        self.currentArtistId = currentArtistId
        self.song = song
        self.storeURLString = storeURLString
        super.init(nibName: "ArtistInfoViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataBase = FIRDatabase.database().reference()
        storage = FIRStorage.storage()

        setText()
        backButton?.layer.cornerRadius = 2
        backButton?.clipsToBounds = true
        
        nameLabel?.text = artistName

        buyButton?.layer.cornerRadius = 2
        buyButton?.clipsToBounds = true
        
        shareButton?.layer.cornerRadius = 2
        shareButton?.clipsToBounds = true
        shareButton?.isHidden = true

        loadingImageView?.image = #imageLiteral(resourceName: "LoadingIcon")
        loadingImageView?.isHidden = true
        
        getArtistInfo()
        showImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideLoadingIcon()
    }
    
    func showImage() {
        if imageIsDownloaded(name: "\(currentArtistId)") {
            getImageFromLibrary()
        } else {
            downloadImage()
        }
    }
    
    private func getImageFromLibrary() {
        let nsLibraryDirectory  = FileManager.SearchPathDirectory.libraryDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsLibraryDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(currentArtistId)" + k.imageExtention)
            let image    = UIImage(contentsOfFile: imageURL.path)
            self.imageView?.image = image
        }

    }
    
    //MARK: - Firebase Calls
    func getArtistInfo() {
        weak var weakSelf = self
        dataBase.child(k.databaseArtists).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let artistList = snapshot.value as? NSArray else {
                print("data unreadable")
                return
            }
            
            for artist in artistList {
                guard let artistInfo = artist as? [String: Any]
                    else { print("could not parse artistInfo AVC80"); return }
                
                if let id = artistInfo[k.artistId] as? Int {
                    if id !=  weakSelf?.currentArtistId { continue }
                } else { return }
                
                do {
                    let artist = try Artist(fromDictionary: artistInfo)
                    weakSelf?.bioTextView?.text = artist.bio
                    weakSelf?.pageURLString = artist.pageURL
                } catch { print("could not parse artist AVC85") }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func downloadImage() {
        showLoadingIcon()
        var url = manager.urls(for: defaultDirictory, in: defaultDomain)[defaultURLIndex]
        url.appendPathComponent("\(currentArtistId)" + k.imageExtention)
        let songReference = storage.reference(forURL:k.storageReference + "\(currentArtistId)" + k.imageExtention)
        weak var weakSelf = self
        _ = songReference.write(toFile: url) { (URL, error) -> Void in
            weakSelf?.hideLoadingIcon()
            if (error != nil) {
                print(error!)
            } else {
                weakSelf?.getImageFromLibrary()
            }
        }
    }
    
    //MARK: - Loading
    typealias OnComplete = () -> ()
    private (set) var spinningIsPaused = true

    func showLoadingIcon() {
        spin()
    }
    
    private func spin() {
        spinningIsPaused = false
        loadingImageView?.isHidden = false
        animateSpin()
    }
    
    func hideLoadingIcon(onComplete: OnComplete? = nil) {
        DispatchQueue.main.async {
            self.hideView()
            onComplete?()
        }
    }
    
    private func hideView() {
            spinningIsPaused = true
            loadingImageView?.isHidden = true
    }

    private func animateSpin() {
        UIView.animate(withDuration: 0.2, delay: 0,
                       options: [.curveLinear, .allowUserInteraction],
                       animations: { _ in
                        let rotation = self.loadingImageView?.transform.rotated(by: CGFloat(M_PI_2))
                        self.loadingImageView?.transform = rotation!
        },
                       completion: { _ in
                        if self.spinningIsPaused { return }
                        self.animateSpin()
        })
    }

    //MARK: - File System
    func imageIsDownloaded(name: String) -> Bool {
        let uri = name + k.imageExtention
        var url = manager.urls(for: defaultDirictory, in: defaultDomain)[defaultURLIndex]
        url.appendPathComponent(uri)
        
        return manager.fileExists(atPath: url.path)
    }

    @IBAction func onBackButtonPressed(_ sender: AnyObject) {
        self.revealViewController().revealToggle(sender)
    }
    
    @IBAction func onBuyButtonPressed(_ sender: Any) {
        if let url = URL(string: storeURLString),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.openURL(url)
        }
    }

    @IBAction func onShareButtonPressed(_ sender: Any) {
        func openFacebookPage() {
            let facebookURL = NSURL(string: "fb://facewebmodal/f?href=/FunnyVideos")!
            if UIApplication.shared.canOpenURL(facebookURL as URL) {
                UIApplication.shared.openURL(facebookURL as URL)
            } else {
                UIApplication.shared.openURL(NSURL(string: "https://www.facebook.com/PepeMontesMusic")! as URL)
            }
        }
        
        openFacebookPage()
    }
    
    //MARK: - SWReavealController Delegate Functions
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        
    }

    //MARK: - Localization

    func setText() {
        bioLabel?.text = NSLocalizedString("artistInfo-viewController.bio-label.text", comment: "")
        
        let buttonString = String(format: NSLocalizedString("artistInfo-viewController.buy-button.title",
                                                            comment: ""), song)
        buyButton?.setTitle(buttonString, for: .normal)
    }

    //MARK: -

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
