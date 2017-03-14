import XCTest
@testable import Dale_Salsa
import AVFoundation

class TapViewControllerTests: XCTestCase {
    
    var controller: TapViewController!
    var revealViewController: SWRevealViewController!
    
    override func setUp() {
        super.setUp()
        
        controller = TapViewController()
        controller.song = SongManager.sharedInstance.listOfSongs[0]
        controller.song?.oneThreeAndSixTimes = [1.1, 3.3, 5.5]
        controller.song?.twoFiveAndSevenTimes = [2.2, 4.4, 6.6]
        _ = controller.view
    
        let frontNavViewController = UINavigationController(rootViewController: controller)
        let rearNavViewController = UINavigationController(rootViewController: SideMenuViewController())
        
        revealViewController = SWRevealViewController(rearViewController: rearNavViewController, frontViewController: frontNavViewController)
        
        revealViewController.delegate =  controller as SWRevealViewControllerDelegate;
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_floorImageView_Is_Connected() {
        XCTAssertNotNil(controller.floorImageView)
    }
    
    func test_floorImageView_Image_Is_Set() {
        let expectedImage = UIImage(named: "Floor")
        XCTAssertEqual(controller.floorImageView.image, expectedImage)
    }
    
    func test_timerLabel_Is_Connected() {
        XCTAssertNotNil(controller.timerLabel)
    }
    
    func test_leftButton_Is_Connected() {
        XCTAssertNotNil(controller.leftButton)
    }
    
    func test_rightButton_Is_Connected() {
        XCTAssertNotNil(controller.rightButton)
    }
    
    func test_rightGuideImageView_Is_Connected() {
        XCTAssertNotNil(controller.rightGuideImageView)
    }
    
    func test_leftGuideImageView_Is_Connected() {
        XCTAssertNotNil(controller.leftGuideImageView)
    }
    
    func test_sideMenuButton_Is_Connected() {
        XCTAssertNotNil(controller.sideMenuButton)
    }
    
    func test_startButton_Is_Connected() {
        XCTAssertNotNil(controller.startButton)
    }
    
    func test_genderButton_Is_Connected() {
        XCTAssertNotNil(controller.genderButton)
    }
    
    func test_restartButton_Is_Connected() {
        XCTAssertNotNil(controller.restartButton)
    }
    
    //Computed Variables
    
    func test_Setting_wrongTaps() {
        for int in controller.wrongTaps..<9 {
            controller.wrongTaps = int
            XCTAssertEqual(controller.wrongTaps, int)
        }
    }
    
    func test_wrongTaps_Cant_Be_Less_Then_0() {
        controller.wrongTaps = -1
        
        XCTAssertEqual(controller.wrongTaps, 0)
    }
    
    func test_wrongTaps_Cant_Be_More_Then_8() {
        controller.wrongTaps = 10
        
        XCTAssertEqual(controller.wrongTaps, 8)
    }
    
    func test_Setting_userIsLady_Sets_genderButton_Title() {
        XCTAssertEqual(controller.genderButton.title(for: .normal), "Ladies")
        
        controller.userIsLady = false
        let expectedMaleString = NSLocalizedString("tap-viewController.gender-button.male.text", comment: "")
        XCTAssertEqual(controller.genderButton.title(for: .normal), expectedMaleString)
        
        controller.userIsLady = true
        let expectedFemaleString = NSLocalizedString("tap-viewController.gender-button.female.text", comment: "")
        XCTAssertEqual(controller.genderButton.title(for: .normal), expectedFemaleString)
    }
    
    func test_Setting_userIsLady_Sets_Default() {
            controller.userIsLady = false
            
            controller.userIsLady = true
            XCTAssertTrue(controller.defaults.bool(forKey: k.gender))
            
            controller.userIsLady = false
            XCTAssertFalse(controller.defaults.bool(forKey: k.gender))
    }

    func test_Setting_userIsLady_Sets_Guide_Images() {
        controller.userIsLady = true
        
        XCTAssertEqual( controller.leftShoeImageView?.image, UIImage(named: "LeftHeel"))
        XCTAssertEqual(controller.rightShoeImageView?.image, UIImage(named: "RightHeel"))
        XCTAssertEqual(controller.leftGuideImageView?.image, UIImage(named: "LeftHeelGuide"))
        XCTAssertEqual(controller.rightGuideImageView?.image, UIImage(named: "RightHeelGuide"))

        controller.userIsLady = false

        XCTAssertEqual(controller.leftShoeImageView?.image, UIImage(named: "LeftMensShoe"))
        XCTAssertEqual(controller.rightShoeImageView?.image, UIImage(named: "RightMensShoe"))
        XCTAssertEqual(controller.leftGuideImageView?.image, UIImage(named: "LeftShoeGuide"))
        XCTAssertEqual(controller.rightGuideImageView?.image, UIImage(named: "RightShoeGuide"))
    }
    
    //MARK: ViewDidLoad
    func test_view_ClipsToBounds() {
        XCTAssertTrue(controller.view.clipsToBounds)
    }
    
    func test_viewDidLoad_Set_Parallax_Effect_On_Floor() {
        XCTAssertTrue(controller.floorImageView.motionEffects.count >= 1)
    }
    
    func test_viewDidLoad_Formats_Views() {
        XCTAssertEqual(controller.timerLabel.textColor, UIColor.clear)
        XCTAssertEqual(controller.timerLabel.backgroundColor, UIColor.clear)
        XCTAssertEqual(controller.timerLabel.layer.cornerRadius, 4)
        XCTAssertTrue(controller.timerLabel.clipsToBounds)
        
        XCTAssertEqual(controller.sideMenuButton.layer.cornerRadius, 4)
        XCTAssertTrue(controller.sideMenuButton.clipsToBounds)
        XCTAssertEqual(controller.genderButton.layer.cornerRadius, 4)
        XCTAssertEqual(controller.startButton.layer.cornerRadius, 4)
        XCTAssertEqual(controller.restartButton.layer.cornerRadius, 4)
    }
    
    func test_viewDidLoad_Adds_shoeFrames() {
        XCTAssertNotNil(controller.rightShoeImageView)
        XCTAssertNotNil(controller.leftShoeImageView)
    }
    
    func test_viewDidLoad_Set_Up_Player() {
        guard let _ = controller.player else {
            XCTFail()
            return
        }
    }
    
    func test_viewDidLoad_Set_Up_Session_To_Play_On_Vibrate() {
        let session = AVAudioSession.sharedInstance()
        do { try session.setCategory(AVAudioSessionCategorySoloAmbient) }
        catch _ {}
        
        controller.viewDidLoad()
        
        XCTAssertEqual(session.category, AVAudioSessionCategoryPlayback)
    }
    
    func test_viewDidLoad_Sets_userWentThroughTutorial_To_true() {
        UserDefaults.standard.set(true, forKey: k.tutorialComplete)
        controller.viewDidLoad()
        
        XCTAssertTrue(controller.userWentThroughTutorial)
    }
    
    func test_viewDidLoad_Sets_userWentThroughTutorial_To_false() {
        UserDefaults.standard.set(false, forKey: k.tutorialComplete)
        controller.viewDidLoad()
        
        XCTAssertFalse(controller.userWentThroughTutorial)
    }
    
    //MARK: ViewWillAppear
    
    func test_viewWillAppear_Hides_navigationBar() {
        guard let _ = controller.navigationController else { XCTFail(); return }
        
        controller.viewWillAppear(false)

        XCTAssertTrue(controller.navigationController!.isNavigationBarHidden)
    }
    
    func test_viewWillAppear_Sets_UserIsLady_To_true() {
        UserDefaults.standard.set(true, forKey: k.gender)
        controller.viewWillAppear(false)
        
        XCTAssertTrue(controller.userIsLady)
    }
    
    func test_viewWillAppear_Sets_UserIsLady_To_false() {
        UserDefaults.standard.set(false, forKey: k.gender)
        controller.viewWillAppear(false)
        
        XCTAssertFalse(controller.userIsLady)
    }
    
    func test_viewWillAppear_Presents_TutorialViewController() {
        let controller = TapViewControllerStub()
        
        controller.userWentThroughTutorial = false
        controller.viewWillAppear(false)

        let presentedController = controller.viewControllerPresented as? TutorialViewController
        
        XCTAssertNotNil(presentedController)
    }
    
    func test_viewWillAppear_Calls_setSWPanGestureRecognizer() {
        let controller = TapViewControllerStub()
        
        controller.userWentThroughTutorial = true
        controller.viewWillAppear(false)
        
        XCTAssertTrue(controller.setSWPanGestureRecognizerCalled)
    }
    
    
    func test_viewWillAppear_Removes_SWPanGestureRecognizer() {
        let controller = TapViewControllerStub()
        
        controller.userWentThroughTutorial = false
        controller.viewWillAppear(false)
        
        XCTAssertTrue(controller.removeSWPanGestureRecognizerCalled)
    }
    
    func test_updateCounter_Increments_Counter_And_Updates_timerLabel() {
        XCTAssertEqual(controller.counter, 0.0)
        controller.song?.length = 10000
        for _ in 1...10000 { controller.updateCounter() }
        
        XCTAssertEqual(controller.counter, 1000.0)
    }
    
    func test_updateCounter_Calls_stopMusic() {
        guard let _ = controller.player else { XCTFail(); return }

        let expectedPauseString = NSLocalizedString("tap-viewController.start-button.pause.text", comment: "")
        controller.startButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(controller.player!.isPlaying)
        XCTAssertTrue(controller.timer.isValid)
        XCTAssertEqual(controller.startButton.title(for: .normal), expectedPauseString)
        
        controller.counter = 246.9
        controller.updateCounter()
        let expectedSartString = NSLocalizedString("tap-viewController.start-button.start.text", comment: "")


        XCTAssertFalse(controller.player!.isPlaying)
        XCTAssertFalse(controller.timer.isValid)
        XCTAssertEqual(controller.startButton.title(for: .normal), expectedSartString)
    }
    
    func test_updateCounter_Calls_showFeetGuide() {
        XCTAssertEqual(controller.leftGuideImageView.alpha, 1)

        controller.wrongTaps = 2
        controller.updateCounter()
        XCTAssertEqualWithAccuracy(controller.leftGuideImageView.alpha, 0.2, accuracy: 0.0001)
    }
    
    //MARK: - Guide
    func test_showFeetGuide_Changes_leftFootImageView_Alpha() {
        controller.wrongTaps = 1
        controller.showFeetGuide(counter: 10)
        XCTAssertEqualWithAccuracy(controller.leftGuideImageView.alpha, 0.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(controller.leftGuideImageView.alpha, 0.1, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(controller.rightGuideImageView.alpha, 0.1, accuracy: 0.0001)
        
        controller.wrongTaps = 2
        controller.showFeetGuide(counter: 10)
        XCTAssertEqualWithAccuracy(controller.leftGuideImageView.alpha, 0.2, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(controller.rightGuideImageView.alpha, 0.2, accuracy: 0.0001)

        controller.wrongTaps = 3
        controller.showFeetGuide(counter: 10)
        XCTAssertEqualWithAccuracy(controller.leftGuideImageView.alpha, 0.4, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(controller.rightGuideImageView.alpha, 0.4, accuracy: 0.0001)

        controller.wrongTaps = 4
        controller.showFeetGuide(counter: 10)
        XCTAssertEqual(controller.leftGuideImageView.alpha, 0.5)
        XCTAssertEqual(controller.rightGuideImageView.alpha, 0.5)

        controller.wrongTaps = 5
        controller.showFeetGuide(counter: 10)
        XCTAssertEqualWithAccuracy(controller.leftGuideImageView.alpha, 0.7, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(controller.rightGuideImageView.alpha, 0.7, accuracy: 0.0001)

        controller.wrongTaps = 6
        controller.showFeetGuide(counter: 10)
        XCTAssertEqualWithAccuracy(controller.leftGuideImageView.alpha, 0.8, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(controller.rightGuideImageView.alpha, 0.8, accuracy: 0.0001)

        controller.wrongTaps = 7
        controller.showFeetGuide(counter: 10)
        XCTAssertEqualWithAccuracy(controller.leftGuideImageView.alpha, 0.9, accuracy: 0.0001)
        XCTAssertEqualWithAccuracy(controller.rightGuideImageView.alpha, 0.9, accuracy: 0.0001)

        controller.wrongTaps = 8
        controller.showFeetGuide(counter: 10)
        XCTAssertEqual(controller.leftGuideImageView.alpha, 1)
        XCTAssertEqual(controller.rightGuideImageView.alpha, 1)

        controller.wrongTaps = 0
        controller.showFeetGuide(counter: 10)
        XCTAssertEqual(controller.leftGuideImageView.alpha, 0)
    }
    
    func test_showFeetGuide_Calls_showLeftGuide() {
        let controller = TapViewControllerStub()
        controller.song = Song(name: "Tu Sin Mi",
                               artist: "Alex",
                               artistId: 1,
                               bpm: 110,
                               songId: 9,
                               songLevel: 2,
                               songTime: 100,
                               songType: 2,
                               storeURL: "a.com")
        
        controller.song?.oneThreeAndSixTimes.append(2.0)
        controller.userIsLady = false
        controller.showFeetGuide(counter: 1.95)
        
        XCTAssertTrue(controller.showLeftGuideCalled)
    }
    
    func test_showFeetGuide_Calls_showRightGuide() {
        let controller = TapViewControllerStub()
        controller.song = Song(name: "Tu Sin Mi",
                               artist: "Alex",
                               artistId: 1,
                               bpm: 100,
                               songId: 9,
                               songLevel: 2,
                               songTime: 100,
                               songType: 2,
                               storeURL: "a.com")
        
        controller.song?.twoFiveAndSevenTimes.append(2.0)
        controller.userIsLady = false
        controller.showFeetGuide(counter: 1.95)
        
        XCTAssertTrue(controller.showRightGuideCalled)
    }
    
    func test_showLeftGuide_Shows_leftGuideImageView() {
        controller.leftGuideImageView.isHidden = true
        controller.showLeftGuide()
        XCTAssertFalse(controller.leftGuideImageView.isHidden)
    }
    
    func test_hideLeftGuide_Hides_leftGuideImageView() {
        controller.leftGuideImageView.isHidden = false
        controller.hideLeftGuide()
        XCTAssertTrue(controller.leftGuideImageView.isHidden)
    }
    
    func test_showRightGuide_Shows_rightGuideImageView() {
        controller.rightGuideImageView.isHidden = true
        controller.showRightGuide()
        XCTAssertFalse(controller.rightGuideImageView.isHidden)
    }
    
    func test_hideRightGuide_Hides_rightGuideImageView() {
        controller.rightGuideImageView.isHidden = false
        controller.hideRightGuide()
        XCTAssertTrue(controller.rightGuideImageView.isHidden)
    }
    
    //MARK: Timing -
    func test_accurateTiming_Sets_timerLabel_Alpha_To_1() {
        let controller = TapViewControllerStub()
        _ = controller.view

        controller.timerLabel.alpha = 0
        controller.accurateTiming()
        
        XCTAssertEqual(controller.timerLabel.alpha, 1.0)
    }
    
    func test_somewhatAccurateTiming_Sets_timerLabel_Alpha_To_1() {
        let controller = TapViewControllerStub()
        _ = controller.view
        
        controller.timerLabel.alpha = 0
        controller.somewhatAccurateTiming()
        
        XCTAssertEqual(controller.timerLabel.alpha, 1.0)
    }
    
    func test_inaccurateTiming_Sets_timerLabel_Alpha_To_1() {
        let controller = TapViewControllerStub()
        _ = controller.view
        
        controller.timerLabel.alpha = 0
        controller.inaccurateTiming()
        
        XCTAssertEqual(controller.timerLabel.alpha, 1.0)
    }
    
    
    func test_accurateTiming_Sets_timerLabel_Alpha_To_0() {
        controller.timerLabel.alpha = 1
        controller.accurateTiming()
        
        XCTAssertEqual(controller.timerLabel.alpha, 0)
    }
    
    func test_somewhatAccurateTiming_Sets_timerLabel_Alpha_To_0() {
        controller.timerLabel.alpha = 1
        controller.somewhatAccurateTiming()
        
        XCTAssertEqual(controller.timerLabel.alpha, 0)
    }
    
    func test_inaccurateTiming_Sets_timerLabel_Alpha_To_0() {
        controller.timerLabel.alpha = 1
        controller.inaccurateTiming()
        
        XCTAssertEqual(controller.timerLabel.alpha, 0)
    }

    
    func test_accurateTiming_Decrements_wrongTap() {
        controller.wrongTaps = 1
        controller.accurateTiming()
        XCTAssertEqual(controller.wrongTaps, 0)
    }
    
    func test_somewhatAccurateTiming_Increments_wrongTap() {
        XCTAssertEqual(controller.wrongTaps, 0)
        controller.somewhatAccurateTiming()
        XCTAssertEqual(controller.wrongTaps, 1)
    }

    func test_inaccurateTiming_Increments_wrongTap() {
        XCTAssertEqual(controller.wrongTaps, 0)
        controller.inaccurateTiming()
        XCTAssertEqual(controller.wrongTaps, 1)
    }
    
    //MARK: Male Timing -

    let expectedAccurateString = NSLocalizedString("tap-viewController.status-label.Dale.text", comment: "")
    let expectedAlmostAccurateString = NSLocalizedString("tap-viewController.status-label.Almost.text", comment: "")
    let expectedInaccurateString = NSLocalizedString("tap-viewController.status-label.Focus.text", comment: "")


    func test_Accurate_Male_leftButtonTap() {
        controller.counter = 1.0
        controller.genderButton.sendActions(for: .touchUpInside)
        controller.startButton.sendActions(for: .touchUpInside)
        controller.leftButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.green)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, expectedAccurateString)
    }
    
    func test_Somewhat_accurate_Male_leftButtonTap() {
        controller.counter = 3.09
        controller.genderButton.sendActions(for: .touchUpInside)
        controller.startButton.sendActions(for: .touchUpInside)
        controller.leftButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.yellow)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.text, expectedAlmostAccurateString)
    }
    
    func test_Inaccurate_Male_leftButtonTap() {
        controller.counter = 5.0
        controller.startButton.sendActions(for: .touchUpInside)
        controller.leftButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, expectedInaccurateString)
    }
    
    func test_Accurate_Male_rightButtonTap() {
        controller.counter = 2.1
        controller.genderButton.sendActions(for: .touchUpInside)
        controller.startButton.sendActions(for: .touchUpInside)
        controller.rightButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.green)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, expectedAccurateString)
    }
    
    func test_Somewhat_Accurate_Male_rightButtonTap() {
        controller.counter = 4.16
        controller.genderButton.sendActions(for: .touchUpInside)
        
        controller.startButton.sendActions(for: .touchUpInside)
        controller.rightButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.yellow)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.text, expectedAlmostAccurateString)
    }
    
    func test_Inaccurate_Male_rightButtonTap() {
        controller.counter = 6.3
        controller.startButton.sendActions(for: .touchUpInside)
        controller.rightButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, expectedInaccurateString)
    }
    
    //MARK: Female Timing
    func test_Accurate_Female_leftButtonTap() {
        controller.viewDidLoad()
        controller.counter = 1.0
        controller.startButton.sendActions(for: .touchUpInside)
        controller.rightButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.green)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, expectedAccurateString)
    }
    
    func test_Somewhat_Accurate_Female_leftButtonTap() {
        controller.counter = 3.09
        controller.startButton.sendActions(for: .touchUpInside)
        controller.rightButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.yellow)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.text, expectedAlmostAccurateString)
    }
    
    func test_Inaccurate_Female_leftButtonTap() {
        controller.genderButton.sendActions(for: .touchUpInside)
        controller.counter = 5.0
        controller.startButton.sendActions(for: .touchUpInside)
        controller.rightButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, expectedInaccurateString)
    }
    
    func test_Accurate_Female_rightButtonTap() {
        controller.counter = 2.1
        controller.startButton.sendActions(for: .touchUpInside)
        controller.leftButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.green)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, expectedAccurateString)
    }
    
    func test_Somewhat_Accurate_Female_rightButtonTap() {
        controller.counter = 4.16
        controller.startButton.sendActions(for: .touchUpInside)
        controller.leftButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.yellow)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.text, expectedAlmostAccurateString)
    }
    
    func test_Inaccurate_Female_rightButtonTap() {
        controller.genderButton.sendActions(for: .touchUpInside)
        controller.counter = 6.3
        controller.startButton.sendActions(for: .touchUpInside)
        controller.leftButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, expectedInaccurateString)
    }
    
    //MARK: Buttons
    func test_leftButton_Does_Nothing_While_player_Is_Not_Playing() {
        controller.counter = 6.3
        controller.leftButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, UIColor.clear)
        XCTAssertEqual(controller.timerLabel.textColor, UIColor.clear)
        XCTAssertEqual(controller.timerLabel.text, "")
    }
    
    func test_rightButton_Does_Nothing_While_player_Is_Not_Playing() {
        controller.counter = 6.3
        controller.rightButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(controller.timerLabel.backgroundColor, UIColor.clear)
        XCTAssertEqual(controller.timerLabel.textColor, UIColor.clear)
        XCTAssertEqual(controller.timerLabel.text, "")
    }
    
    //MARK: Playback
    func test_startButton_Starts_Song() {
        
        guard let _ = controller.player else { XCTFail(); return }

        let expectedSartString = NSLocalizedString("tap-viewController.start-button.start.text", comment: "")
        XCTAssertFalse(controller.player!.isPlaying)
        XCTAssertFalse(controller.timer.isValid)
        XCTAssertEqual(controller.startButton.title(for: .normal), expectedSartString)
        
        controller.startButton.sendActions(for: .touchUpInside)
        let expectedPauseString = NSLocalizedString("tap-viewController.start-button.pause.text", comment: "")

        XCTAssertTrue(controller.player!.isPlaying)
        XCTAssertTrue(controller.timer.isValid)
        XCTAssertEqual(controller.startButton.title(for: .normal), expectedPauseString)
    }
    
    func test_stopButton_Stops_Song() {
        
        guard let _ = controller.player else { XCTFail(); return }

        let expectedPauseString = NSLocalizedString("tap-viewController.start-button.pause.text", comment: "")
        controller.startButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(controller.player!.isPlaying)
        XCTAssertTrue(controller.timer.isValid)
        XCTAssertEqual(controller.startButton.title(for: .normal), expectedPauseString)
        
        controller.startButton.sendActions(for: .touchUpInside)
        let expectedSartString = NSLocalizedString("tap-viewController.start-button.start.text", comment: "")

        XCTAssertFalse(controller.player!.isPlaying)
        XCTAssertFalse(controller.timer.isValid)
        XCTAssertEqual(controller.startButton.title(for: .normal), expectedSartString)
    }
    
    func test_restartButtonPressed_Resets_Song() {
        
        guard let player = controller.player
        else {
            XCTFail()
            return
        }
        
        player.currentTime = 10.0

        controller.counter = 10.0
        controller.wrongTaps = 3
        controller.player = player
        controller.restartButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(controller.counter, 0.0)
        XCTAssertEqual(controller.player!.currentTime, 0.0)
        XCTAssertEqual(controller.wrongTaps, 0)
    }
    
    //MARK: Gender Button
    func test_pressing_genderButton_Sets_userIsLady() {
        XCTAssertTrue(controller.userIsLady)
        
        controller.onGenderButtonPressed(self)
        XCTAssertFalse(controller.userIsLady)
        
        controller.onGenderButtonPressed(self)
        XCTAssertTrue(controller.userIsLady)
    }
    
    //MARK: Shoes
    func test_Shoe_Image_Views_Set() {
        XCTAssertNotNil(controller.leftShoeImageView)
        XCTAssertNotNil(controller.rightShoeImageView)
    }
    
    func test_Men_Shoe_Image_Views_Images_Set () {
        controller.userIsLady = false
        
        let expectedLeftImage = UIImage(named: "LeftMensShoe")
        let expectedRightImage = UIImage(named: "RightMensShoe")
        
        XCTAssertEqual(controller.leftShoeImageView?.image, expectedLeftImage)
        XCTAssertEqual(controller.rightShoeImageView?.image, expectedRightImage)
    }
    
    func test_Ladies_Shoe_Image_Views_Images_Set () {
        controller.userIsLady = true
        
        let expectedLeftImage = UIImage(named: "LeftHeel")
        let expectedRightImage = UIImage(named: "RightHeel")
        
        XCTAssertEqual(controller.leftShoeImageView?.image, expectedLeftImage)
        XCTAssertEqual(controller.rightShoeImageView?.image, expectedRightImage)
    }
    
    func test_Shoe_Image_Views_Hidden() {
        guard let _ = controller.leftShoeImageView else { XCTFail(); return }
        guard let _ = controller.rightShoeImageView else { XCTFail(); return }

        XCTAssertTrue(controller.leftShoeImageView!.isHidden)
        XCTAssertTrue(controller.rightShoeImageView!.isHidden)
    }
    
    func test_onLeftButtonTouchDown_Shows_leftShoeImage() {
        // TODO:
    }
    
    func test_leftButton_Shoes_And_Hides_Left_Shoe() {
        guard let _ = controller.leftShoeImageView else { XCTFail(); return }
        
        let point = CGPoint(x: 100, y: 100)
        
        controller.showLeftFootAnimationFrom(point)
        XCTAssertFalse(controller.leftShoeImageView!.isHidden)
        
        controller.leftButton.sendActions(for: .touchDragExit)
        XCTAssertTrue(controller.leftShoeImageView!.isHidden)
        
        controller.showLeftFootAnimationFrom(point)
        XCTAssertFalse(controller.leftShoeImageView!.isHidden)
        
        controller.leftButton.sendActions(for: .touchCancel)
        XCTAssertTrue(controller.leftShoeImageView!.isHidden)
    }
    
    func test_onRightButtonTouchDown_Shows_rightShoeImage() {
        // TODO:
    }
    
    func test_rightButton_Shows_And_Hides_Right_Shoe() {
        guard let _ = controller.rightShoeImageView else { XCTFail(); return }
        let point = CGPoint(x: 100, y: 100)

        controller.showRightFootAnimationFrom(point)
        XCTAssertFalse(controller.rightShoeImageView!.isHidden)
        
        controller.rightButton.sendActions(for: .touchDragExit)
        XCTAssertTrue(controller.rightShoeImageView!.isHidden)
        
        controller.showRightFootAnimationFrom(point)
        XCTAssertFalse(controller.rightShoeImageView!.isHidden)
        
        controller.rightButton.sendActions(for: .touchCancel)
        XCTAssertTrue(controller.rightShoeImageView!.isHidden)
    }
    
    func test_onLeftButtonPressed_Hides_Shoe() {
        guard let _ = controller.leftShoeImageView else { XCTFail(); return }
        let point = CGPoint(x: 100, y: 100)
        controller.showLeftFootAnimationFrom(point)
        
        controller.onLeftButtonPressed(controller.leftButton, event: UIEvent())
        
        XCTAssertTrue(controller.leftShoeImageView!.isHidden)
    }
    
    func test_onRightButtonPressed_Hides_Shoe() {
        guard let _ = controller.rightShoeImageView else { XCTFail(); return }
        let point = CGPoint(x: 100, y: 100)
        controller.showRightFootAnimationFrom(point)
        
        controller.onRightButtonPressed(controller.rightButton, event: UIEvent())
        
        XCTAssertTrue(controller.rightShoeImageView!.isHidden)
    }
    
    func test_addShoeFrames_Sets_Views() {
        controller.leftShoeImageView?.removeFromSuperview()
        controller.rightShoeImageView?.removeFromSuperview()

        var leftShoeImageView = controller.view.subviews.filter { $0 == controller.leftShoeImageView}.first
        XCTAssertNil(leftShoeImageView)
        
        var rightShoeImageView = controller.view.subviews.filter { $0 == controller.rightShoeImageView}.first
        XCTAssertNil(rightShoeImageView)
        
        controller.addShoeFrames()

        leftShoeImageView = controller.view.subviews.filter { $0 == controller.leftShoeImageView}.first
        rightShoeImageView = controller.view.subviews.filter { $0 == controller.rightShoeImageView}.first

        XCTAssertNotNil(leftShoeImageView)
        XCTAssertNotNil(rightShoeImageView)
    }
    
    func test_addShoeFrames_Hides_Views() {
        guard let _ = controller.leftShoeImageView else { XCTFail(); return }
        guard let _ = controller.rightShoeImageView else { XCTFail(); return }
        
        controller.leftShoeImageView?.isHidden = false
        controller.rightShoeImageView?.isHidden = false

        XCTAssertFalse(controller.leftShoeImageView!.isHidden)
        XCTAssertFalse(controller.rightShoeImageView!.isHidden)
        
        controller.addShoeFrames()
        
        XCTAssertTrue(controller.leftShoeImageView!.isHidden)
        XCTAssertTrue(controller.rightShoeImageView!.isHidden)
    }
    
    func test_showLeftFootAnimationFrom_Moves_leftShoeImageView_Center(){
        let point = CGPoint(x: 100, y: 100)
        
        controller.showLeftFootAnimationFrom(point)
        
        XCTAssertEqual(controller.leftShoeImageView?.center.y, 40)
    }
    
    //MARK: SWRevealViewController
    func test_revealController_willMoveToPosition_Left_Enables_Buttons() {
        
        controller.leftButton.isEnabled = false
        controller.rightButton.isEnabled = false
        controller.genderButton.isEnabled = false
        controller.startButton.isEnabled = false
        controller.restartButton.isEnabled = false
        
        XCTAssertFalse(controller.leftButton.isEnabled)
        XCTAssertFalse(controller.rightButton.isEnabled)
        XCTAssertFalse(controller.genderButton.isEnabled)
        XCTAssertFalse(controller.startButton.isEnabled)
        XCTAssertFalse(controller.restartButton.isEnabled)
        
        controller.revealController(revealViewController, willMoveTo: FrontViewPosition.left)
        
        XCTAssertTrue(controller.leftButton.isEnabled)
        XCTAssertTrue(controller.rightButton.isEnabled)
        XCTAssertTrue(controller.genderButton.isEnabled)
        XCTAssertTrue(controller.startButton.isEnabled)
        XCTAssertTrue(controller.restartButton.isEnabled)
    }
    
    func test_revealController_willMoveToPosition_Left_Adds_Parallax_View() {
        controller.removeParallax(from: controller.floorImageView)
        
        XCTAssertFalse(controller.floorImageView.motionEffects.count >= 1)
        
        controller.revealController(revealViewController, willMoveTo: .left)
        
        XCTAssertTrue(controller.floorImageView.motionEffects.count >= 1)
    }
    
    func test_revealController_willMoveToPosition_LeftSideMost_Left_Disables_Buttons() {
        
        controller.leftButton.isEnabled = true
        controller.rightButton.isEnabled = true
        controller.genderButton.isEnabled = true
        controller.startButton.isEnabled = true
        controller.restartButton.isEnabled = true
        
        XCTAssertTrue(controller.leftButton.isEnabled)
        XCTAssertTrue(controller.rightButton.isEnabled)
        XCTAssertTrue(controller.genderButton.isEnabled)
        XCTAssertTrue(controller.startButton.isEnabled)
        XCTAssertTrue(controller.restartButton.isEnabled)
        
        controller.revealController(revealViewController, willMoveTo: FrontViewPosition.leftSideMost)
        
        XCTAssertFalse(controller.leftButton.isEnabled)
        XCTAssertFalse(controller.rightButton.isEnabled)
        XCTAssertFalse(controller.genderButton.isEnabled)
        XCTAssertFalse(controller.startButton.isEnabled)
        XCTAssertFalse(controller.restartButton.isEnabled)
    }
    
    func test_revealController_willMoveToPosition_LeftSideMost_Removes_Parallax_View() {
        XCTAssertTrue(controller.floorImageView.motionEffects.count >= 1)
        
        controller.revealController(revealViewController, willMoveTo: .leftSideMost)
        
        XCTAssertFalse(controller.floorImageView.motionEffects.count >= 1)
    }
    
    //MARK: Side Menu Button
    func test_sideMenuButton_Shows_Side_Menu() {
        XCTAssertEqual(controller.revealViewController().frontViewPosition, .left)
        controller.onSideMenuButtonPressed(controller)
        XCTAssertEqual(controller.revealViewController().frontViewPosition, .right)
    }
    
    //MARK: Tutorial
    
    func test_tutorialComplete_Starts_Music() {
        XCTAssertFalse(controller.player!.isPlaying)
        controller.tutorialComplete()
        XCTAssertTrue(controller.player!.isPlaying)
    }
    
    func test_tutorialComplete_Sets_Default() {
        UserDefaults.standard.set(false, forKey: k.tutorialComplete)
        XCTAssertFalse(UserDefaults.standard.bool(forKey: k.tutorialComplete))

        controller.tutorialComplete()
        
        XCTAssertTrue(UserDefaults.standard.bool(forKey: k.tutorialComplete))
    }
    
    func test_tutorialChangedGender_Sets_Default() {
        controller.userIsLady = true
        UserDefaults.standard.set(false, forKey: k.gender)
        controller.tutorialChangedGender()
        
        XCTAssertFalse(controller.userIsLady)
    }

    class TapViewControllerStub: TapViewController {
        
        var setSWPanGestureRecognizerCalled = false
        override func setSWPanGestureRecognizer() {
            setSWPanGestureRecognizerCalled = true
        }
        
        var removeSWPanGestureRecognizerCalled = false
        override func removeSWPanGestureRecognizer() {
            removeSWPanGestureRecognizerCalled = true
        }
        
        var viewControllerPresented: UIViewController?
        override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
            viewControllerPresented = viewControllerToPresent
        }
        
        var showLeftGuideCalled = false
        override func showLeftGuide() {
            showLeftGuideCalled = true
        }
        
        var showRightGuideCalled = false
        override func showRightGuide() {
            showRightGuideCalled = true
        }
        
        override func animateHideTimerLabel() {}

    }
}
