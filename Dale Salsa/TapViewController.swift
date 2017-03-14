
import UIKit
import AVFoundation

class TapViewController: UIViewController, SWRevealViewControllerDelegate, TutorialProtocal {
    
    @IBOutlet weak var floorImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftGuideImageView: UIImageView!
    @IBOutlet weak var rightGuideImageView: UIImageView!
    @IBOutlet weak var sideMenuButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    var song: Song?
    let defaults = UserDefaults.standard
    var timer = Timer()
    var counter: Double = 0.0
    var hitNumber = 100
    var wrongTaps = 0 {
        didSet {
            if wrongTaps < 0 { wrongTaps = 0}
            if wrongTaps > 8 { wrongTaps = 8}
        }
    }
    var correctTaps = 0
    var player: AVAudioPlayer?
    var session: AVAudioSession?
    
    var leftShoeImageView: UIImageView?
    var rightShoeImageView: UIImageView?
    var leftShoeImage: UIImage?
    var rightShoeImage: UIImage?
    
    var userIsLady = true {
        didSet{
            if userIsLady {
                genderButton?.setTitle(NSLocalizedString("tap-viewController.gender-button.female.text", comment: ""), for: UIControlState())
                defaults.set(true, forKey: k.gender)
            } else {
                genderButton?.setTitle(NSLocalizedString("tap-viewController.gender-button.male.text", comment: ""), for: UIControlState())
                defaults.set(false, forKey: k.gender)
            }
            updateShoeImageViews()
        }
    }

    var userWentThroughTutorial = true

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: k.tapViewController, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.clipsToBounds = true
        floorImageView?.image = UIImage(named: "Floor")
        addParallax(to: floorImageView)
        formatViews()
        addShoeFrames()
        setText()
        userWentThroughTutorial = defaults.bool(forKey: k.tutorialComplete)
        leftGuideImageView?.isHidden = true
        rightGuideImageView?.isHidden = true
        if k.inDevelopment { userWentThroughTutorial = true }

        do {
            if song?.name == k.firstSongName {
                playFirstSong()
                return
            }
            
            guard let song = song else { return }
                
            player = try AVAudioPlayer(contentsOf: song.url as URL)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            player?.prepareToPlay()
        } catch _ {
            print("could not initialize player or set session category ")
        }
    }
    
    private func playFirstSong() {
        guard let songPath = Bundle.main.path(forResource: k.firstSongName, ofType: k.songExtention)
            else { print("could not find song path"); return}
        
        guard let
            safeSongPath = songPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: safeSongPath)
            else { print("could not make url"); return}
        
        player = try? AVAudioPlayer(contentsOf: url as URL)
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        player?.prepareToPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
     
        userIsLady = defaults.bool(forKey: k.gender)
        
        if !userWentThroughTutorial {
            let tutorialViewController = TutorialViewController()
            tutorialViewController.delegate = self
            tutorialViewController.modalPresentationStyle = .overCurrentContext
            present(tutorialViewController, animated: false, completion: nil)
            removeSWPanGestureRecognizer()
        } else {
            setSWPanGestureRecognizer()
        }
    }
    
    func formatViews() {
        timerLabel?.textColor = UIColor.clear
        timerLabel?.backgroundColor = UIColor.clear
        timerLabel?.layer.cornerRadius = 4
        timerLabel?.clipsToBounds = true
        
        sideMenuButton?.layer.cornerRadius = 4
        sideMenuButton?.clipsToBounds = true
        genderButton?.layer.cornerRadius = 4
        startButton?.layer.cornerRadius = 4
        restartButton?.layer.cornerRadius = 4
    }
    
    func updateCounter() {
        counter += 0.1
        
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let roundedCounter = round(counter * multiplier) / multiplier
        
        counter = roundedCounter
        if counter >= Double(song?.length ?? 0) {
            restartMusic()
        }
        
        showFeetGuide(counter: counter)
    }
    
    //MARK: - Guide
    
    func showFeetGuide(counter: Double) {
        
        switch wrongTaps {
        case 0:
            leftGuideImageView?.alpha = 0
            rightGuideImageView?.alpha = 0
        case 1:
            leftGuideImageView?.alpha = 0.1
            rightGuideImageView?.alpha = 0.1
        case 2:
            leftGuideImageView?.alpha = 0.2
            rightGuideImageView?.alpha = 0.2
        case 3:
            leftGuideImageView?.alpha = 0.4
            rightGuideImageView?.alpha = 0.4
        case 4:
            leftGuideImageView?.alpha = 0.5
            rightGuideImageView?.alpha = 0.5
        case 5:
            leftGuideImageView?.alpha = 0.7
            rightGuideImageView?.alpha = 0.7
        case 6:
            leftGuideImageView?.alpha = 0.8
            rightGuideImageView?.alpha = 0.8
        case 7:
            leftGuideImageView?.alpha = 0.9
            rightGuideImageView?.alpha = 0.9
        case 8:
            leftGuideImageView?.alpha = 1.0
            rightGuideImageView?.alpha = 1.0
        default:
            leftGuideImageView?.alpha = 0
            rightGuideImageView?.alpha = 0
        }
        
        if k.inDevelopment {
            leftGuideImageView?.alpha = 1
            rightGuideImageView?.alpha = 1
        }
        
        let timesForLeftFoot:[Double]!
        let timesForRightFoot:[Double]!
        
        if userIsLady {
            timesForLeftFoot = song?.twoFiveAndSevenTimes
            timesForRightFoot = song?.oneThreeAndSixTimes
        } else {
            timesForLeftFoot = song?.oneThreeAndSixTimes
            timesForRightFoot = song?.twoFiveAndSevenTimes
        }
        
        let guideTimeRange = 0.1
        
        let leftFoot = timesForLeftFoot?.filter { (tapTime) -> Bool in
            let top = tapTime + guideTimeRange
            let bottom = tapTime - guideTimeRange
            return counter <= top && counter >= bottom
        }
        
        if leftFoot?.count == 1 {
            showLeftGuide()
            return
        }
        
        let rightFoot = timesForRightFoot?.filter { (tapTime) -> Bool in
            let top = tapTime + guideTimeRange
            let bottom = tapTime - guideTimeRange
            return counter <= top && counter >= bottom
        }
        
        if rightFoot?.count == 1 {
            showRightGuide()
            return
        }
    }
    
    func showLeftGuide() {
        leftGuideImageView?.isHidden = false
        
        Timer.scheduledTimer(timeInterval: 0.2,
                             target: self,
                             selector: #selector(self.hideLeftGuide),
                             userInfo: nil,
                             repeats: false)
    }
    
    func hideLeftGuide() {
        leftGuideImageView?.isHidden = true
    }
    
    func showRightGuide() {
        rightGuideImageView?.isHidden = false
        
        Timer.scheduledTimer(timeInterval: 0.2,
                             target: self,
                             selector: #selector(self.hideRightGuide),
                             userInfo: nil,
                             repeats: false)
    }
    
    func hideRightGuide() {
        rightGuideImageView?.isHidden = true
    }
    
    //MARK: Buttons -
     @IBAction func onLeftButtonTouchDown(_ sender: UIButton, event: UIEvent) {
        if let touch = event.touches(for: sender)?.first {
            let point = touch.location(in: self.view)
            showLeftFootAnimationFrom(point)
        }
    }
    
    @IBAction func onTouchDragExitForLeftButton(_ sender: AnyObject) {
        hideLeftFoot()
    }
    
    @IBAction func onLefttButtonTouchCanceled(_ sender: AnyObject) {
        hideLeftFoot()
    }
    
    @IBAction func onLeftButtonPressed(_ sender: UIButton, event: UIEvent) {
        hideLeftFoot()
        guard let player = player else { return }
        if !player.isPlaying { return }
        
        if userIsLady { twoFiveOrSevenTapped() }
        else { oneThreeOrSixTapped() }

        NSLog("%.2f", counter)
    }
    
    @IBAction func onRightButtonTouchDown(_ sender: UIButton, event: UIEvent) {
        if let touch =  event.touches(for: sender)?.first {
            let point = touch.location(in: self.view)
            showRightFootAnimationFrom(point)
        }
    }
    
    @IBAction func onTouchDragExitForRightButton(_ sender: AnyObject) {
        hideRightFoot()
    }
    
    @IBAction func onRightButtonTouchCanceled(_ sender: AnyObject) {
        hideRightFoot()
    }

    @IBAction func onRightButtonPressed(_ sender: UIButton, event: UIEvent) {
        hideRightFoot()
        guard let player = player else { return }
        if !player.isPlaying { return }
        
        if userIsLady { oneThreeOrSixTapped() }
        else { twoFiveOrSevenTapped() }

        NSLog("%.2f", counter)
    }
    
    @IBAction func onStartButtonPressed(_ sender: AnyObject) {
        guard let player = player else { return }
        if !player.isPlaying { startMusic() }
        else { stopMusic() }
    }
    
    @IBAction func onRestartButtonPressed(_ sender: AnyObject) {
        restartMusic()
    }
    
    @IBAction func onGenderButtonPressed(_ sender: AnyObject ) {
        userIsLady = !userIsLady
    }
    
    func enableButtons(_ enable: Bool) {
        leftButton?.isEnabled = enable
        rightButton?.isEnabled = enable
        genderButton?.isEnabled = enable
        startButton?.isEnabled = enable
        restartButton?.isEnabled = enable
    }
    
    fileprivate func startMusic() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                                       target: self,
                                                       selector: #selector(updateCounter),
                                                       userInfo: nil,
                                                       repeats: true)
        player?.play()
        startButton?.setTitle(NSLocalizedString("tap-viewController.start-button.pause.text", comment: ""), for: UIControlState())
        removeSWPanGestureRecognizer()
    }
    
    fileprivate func stopMusic() {
        player?.stop()
        timer.invalidate()
        startButton?.setTitle(NSLocalizedString("tap-viewController.start-button.start.text", comment: ""), for: UIControlState())
        setSWPanGestureRecognizer()
    }
    
    fileprivate func restartMusic() {
        stopMusic()
        counter = 0.0
        player?.currentTime = 0.0
        timerLabel?.backgroundColor = UIColor.clear
        timerLabel?.text = ""
        wrongTaps = 0
    }
    
    //MARK: Timing -
    func oneThreeOrSixTapped() {
        let accurateTap = song?.oneThreeAndSixTimes.filter { (tapTime) -> Bool in
            let top = tapTime + k.accurateRange
            let bottom = tapTime - k.accurateRange
            return counter <= top && counter >= bottom
        }
        
        if accurateTap?.count == 1 {
            accurateTiming()
            return
        }
        
        let somewhatAccurateTap = song?.oneThreeAndSixTimes.filter { (tapTime) -> Bool in
            let top = tapTime + k.almostAccurateRange
            let bottom = tapTime - k.almostAccurateRange
            return counter <= top && counter >= bottom
        }
        
        if somewhatAccurateTap?.count == 1 {
            somewhatAccurateTiming()
        } else {
            inaccurateTiming()
        }
    }
    
    func twoFiveOrSevenTapped() {
        
        let accurateTap = song?.twoFiveAndSevenTimes.filter { (tapTime) -> Bool in
            let top = tapTime + k.accurateRange
            let bottom = tapTime - k.accurateRange
            return counter <= top && counter >= bottom
        }
        
        if accurateTap?.count == 1 {
            accurateTiming()
            return
        }
        
        let somewhatAccurateTap = song?.twoFiveAndSevenTimes.filter { (tapTime) -> Bool in
            let top = tapTime + k.almostAccurateRange
            let bottom = tapTime - k.almostAccurateRange
            return counter <= top && counter >= bottom
        }
        
        if somewhatAccurateTap?.count == 1 {
            somewhatAccurateTiming()
        } else {
            inaccurateTiming()
        }
    }
    
    func accurateTiming() {
        timerLabel?.alpha = 1.0
        timerLabel?.backgroundColor = SalsaColors.green
        timerLabel?.textColor = SalsaColors.white
        timerLabel?.text = NSLocalizedString("tap-viewController.status-label.Dale.text", comment: "")
        wrongTaps -= 1
        animateHideTimerLabel()
    }
    
    func somewhatAccurateTiming() {
        timerLabel?.alpha = 1.0
        timerLabel?.backgroundColor = SalsaColors.yellow
        timerLabel?.textColor = SalsaColors.red
        timerLabel?.text = NSLocalizedString("tap-viewController.status-label.Almost.text", comment: "")
        wrongTaps += 1
        animateHideTimerLabel()
    }
    
    func inaccurateTiming() {
        timerLabel?.alpha = 1.0
        timerLabel?.backgroundColor = SalsaColors.red
        timerLabel?.textColor = SalsaColors.white
        timerLabel?.text = NSLocalizedString("tap-viewController.status-label.Focus.text", comment: "")
        wrongTaps += 1
        animateHideTimerLabel()
    }
    
    func animateHideTimerLabel() {
        weak var weakSelf = self
        
        UIView.animate(withDuration: 0.2, delay: 1, options: .curveEaseInOut, animations: {
            weakSelf?.timerLabel.alpha = 0
        }, completion: nil)
    }
    
    
    //MARK: SWReavealController Set Up
    func setSWPanGestureRecognizer() {
        _ = self.revealViewController()?.panGestureRecognizer()
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.sideMenuButton?.transform = CGAffineTransform(translationX: 0, y: 0)
        }) 
    }
    
    func removeSWPanGestureRecognizer() {
        self.revealViewController()?.removePanGestureRecognizer()
        self.sideMenuButton?.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.sideMenuButton?.transform = CGAffineTransform(translationX: -50, y: 0)
        }) 
    }
    
    //MARK: - SWReavealController Delegate Functions

    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        
        if position == FrontViewPosition.left {
            addParallax(to: floorImageView)
            enableButtons(true)
        } else {
            removeParallax(from: floorImageView)
            enableButtons(false)
        }
    }
    
    @IBAction func onSideMenuButtonPressed(_ sender: AnyObject) {
        self.revealViewController().revealToggle(sender)
    }
    
    //MARK: - Tutorial Delegate Functions
    func tutorialComplete() {
        startMusic()
        defaults.set(true, forKey: k.tutorialComplete)
    }
    
    func tutorialChangedGender() {
        userIsLady = defaults.bool(forKey: k.gender)
    }
    
    func addParallax(to view: UIView?) {
        let amount = 30
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: k.parallaxHorizontalAxis, type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: k.parallaxVerticalAxis, type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        
        if let parallaxView = view {
            if parallaxView.motionEffects.count == 0 {
                parallaxView.addMotionEffect(group)
            }
        }
    }
    
    func removeParallax(from view: UIView?) {
        if let parallaxView = view {
            if parallaxView.motionEffects.count > 0 {
                parallaxView.removeMotionEffect(parallaxView.motionEffects.first!)
            }
        }
    }
    
    //MARK: Feet Animations
    func addShoeFrames() {
        let shoeFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
       
        leftShoeImageView = UIImageView(frame: shoeFrame)
        self.view.addSubview(leftShoeImageView!)
        
        rightShoeImageView = UIImageView(frame: shoeFrame)
        self.view.addSubview(rightShoeImageView!)
       
        hideLeftFoot()
        hideRightFoot()
    }
    
    func updateShoeImageViews() {
        if userIsLady {
            leftShoeImage = #imageLiteral(resourceName: "LeftHeel")
            rightShoeImage = #imageLiteral(resourceName: "RightHeel")
            
            leftGuideImageView?.image = #imageLiteral(resourceName: "LeftHeelGuide")
            rightGuideImageView?.image = #imageLiteral(resourceName: "RightHeelGuide")

        } else {
            leftShoeImage = #imageLiteral(resourceName: "LeftMensShoe")
            rightShoeImage = #imageLiteral(resourceName: "RightMensShoe")
            
            leftGuideImageView?.image = #imageLiteral(resourceName: "LeftShoeGuide")
            rightGuideImageView?.image = #imageLiteral(resourceName: "RightShoeGuide")
        }
        leftShoeImageView?.image = leftShoeImage
        rightShoeImageView?.image = rightShoeImage
    }
    
    func showLeftFootAnimationFrom(_ point: CGPoint) {
        leftShoeImageView?.isHidden = false
        let newPoint = CGPoint(x: point.x, y: point.y - 60)
        leftShoeImageView?.center = newPoint
    }
    
    func showRightFootAnimationFrom(_ point: CGPoint) {
        rightShoeImageView?.isHidden = false
        let newPoint = CGPoint(x: point.x, y: point.y - 60)
        rightShoeImageView?.center = newPoint
    }
    
    func hideLeftFoot() {
        leftShoeImageView?.isHidden = true
    }
    
    func hideRightFoot() {
        rightShoeImageView?.isHidden = true
    }

    //MARK: - Localization

    func setText() {
        startButton?.setTitle(NSLocalizedString("tap-viewController.start-button.start.text", comment: ""), for: .normal)
        restartButton?.setTitle(NSLocalizedString("tap-viewController.restart-button.title", comment: ""), for: .normal)
        
        genderButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        startButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        restartButton?.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    //MARK: -
    override var prefersStatusBarHidden : Bool {
        return false
    }
}
