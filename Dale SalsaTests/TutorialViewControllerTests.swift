import XCTest
@testable import Dale_Salsa

class TutorialViewControllerTests: XCTestCase {
   
    var controller: TutorialViewController!
    
    override func setUp() {
        super.setUp()
        controller = TutorialViewController()
        _ = controller.view
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func test_timerLabel_Is_Connect() {
        XCTAssertNotNil(controller.timerLabel)
    }
    
    func test_timerLabelHeightContraint_Is_Connect() {
        XCTAssertNotNil(controller.timerLabelHeightContraint)
    }
    
    func test_firstLabel_Is_Connect() {
        XCTAssertNotNil(controller.firstLabel)
    }
    
    func test_secondLabel_Is_Connect() {
        XCTAssertNotNil(controller.secondLabel)
    }
    
    func test_leftButton_Is_Connect() {
        XCTAssertNotNil(controller.leftButton)
    }
    
    func test_rightButton_Is_Connect() {
        XCTAssertNotNil(controller.rightButton)
    }
    
    func test_genderArrorImageView_Is_Connect() {
        XCTAssertNotNil(controller.genderButtonArrowImageView)
    }
    
    func test_genderButton_Is_Connect() {
        XCTAssertNotNil(controller.genderButton)
    }
    
    func test_startButton_Is_Connect() {
        XCTAssertNotNil(controller.startButton)
    }
    
    func test_viewDidLoad_Formats_Views() {
        XCTAssertEqual(controller.timerLabel.layer.cornerRadius, 4)
        XCTAssertTrue(controller.timerLabel.clipsToBounds)
        XCTAssertEqual(controller.leftButton.layer.cornerRadius, 4)
        XCTAssertEqual(controller.rightButton.layer.cornerRadius, 4)
        XCTAssertEqual(controller.startButton.layer.cornerRadius, 4)
        XCTAssertEqual(controller.genderButton.layer.cornerRadius, 4)
        XCTAssertEqual(controller.startButton.layer.cornerRadius, 4)
    }
    
    //MARK: Welcome Step -
    func test_welcomeStep() {
        XCTAssertEqual(controller.tutorialStep, 1)

        XCTAssertEqual(controller.firstLabel.text, NSLocalizedString("tutorial-viewController.welcome-step.main-Label.text", comment: ""))
        XCTAssertEqual(controller.secondLabel.text, NSLocalizedString("tutorial-viewController.welcome-step.detail-Label.text", comment: ""))
        XCTAssertEqual( controller.startButton.title(for: .normal), NSLocalizedString("tutorial-viewController.next-button.title", comment: ""))

        XCTAssertTrue(controller.splitView.isHidden)

        XCTAssertEqual(controller.leftButton.backgroundImage(for: .normal), UIImage(named: "Left Thumb"))
        XCTAssertEqual(controller.rightButton.backgroundImage(for: .normal), UIImage(named: "Right Thumb"))
        XCTAssertFalse(controller.leftTapLabel.isHidden)
        XCTAssertFalse(controller.rightTapLabel.isHidden)

        XCTAssertTrue(controller.genderButtonArrowImageView.isHidden)
        XCTAssertTrue(controller.genderButton.isHidden)
        XCTAssertTrue(controller.startButton.isHidden)
    }
    
    //MARK: Pick Gender Step -
    func test_pickGenderStep() {
        controller.pickGenderStep()

        XCTAssertEqual(controller.tutorialStep, 2)

        XCTAssertEqual(controller.firstLabel.text, NSLocalizedString("tutorial-viewController.pick-gender-step.main-Label.text", comment: ""))
        XCTAssertEqual(controller.secondLabel.text, "")

        XCTAssertEqual(controller.leftButton.backgroundColor, UIColor.clear)
        XCTAssertEqual(controller.rightButton.backgroundColor, UIColor.clear)

        XCTAssertEqual(controller.leftButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "GuyWithBackground"))
        XCTAssertEqual(controller.rightButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "GirlWithBackground"))

        XCTAssertFalse(controller.leftButton.isHidden)
        XCTAssertFalse(controller.rightButton.isHidden)
        XCTAssertFalse(controller.leftTapLabel.isHidden)
        XCTAssertFalse(controller.rightTapLabel.isHidden)

        XCTAssertTrue(controller.genderButtonArrowImageView.isHidden)
        XCTAssertTrue(controller.genderButton.isHidden)
        XCTAssertTrue(controller.startButton.isHidden)
    }

    func test_genderHadBeenPicked() {
        controller.userIsLady = false
        controller.genderHasBeenPicked = false
        controller.genderButton.sendActions(for: UIControlEvents.touchUpInside)
        XCTAssertTrue(controller.genderHasBeenPicked)
        
        let expectedMaleString = NSLocalizedString("tutorial-viewController.gender-picked.main-Label.female.text",
                                                   comment: "")

        XCTAssertEqual( controller.firstLabel.text, expectedMaleString)
        XCTAssertEqual( controller.secondLabel.text, "")

        controller.genderHasBeenPicked = false
        controller.genderButton.sendActions(for: UIControlEvents.touchUpInside)
        let expectedFemaleString = NSLocalizedString("tutorial-viewController.gender-picked.main-Label.male.text",
                                                   comment: "")
        XCTAssertEqual( controller.firstLabel.text, expectedFemaleString)
    }


    //MARK: Change Gender Step -
    func test_changeGenderStep() {
        controller.changeGenderStep()

        XCTAssertEqual(controller.tutorialStep, 3)

        XCTAssertEqual(controller.firstLabel.text, NSLocalizedString("tutorial-viewController.change-gender-step.main-Label.text", comment: ""))
        XCTAssertEqual(controller.secondLabel.text, NSLocalizedString("tutorial-viewController.change-gender-step.detail-Label.text", comment: ""))

        XCTAssertEqual(controller.leftButton.backgroundColor, UIColor.clear)
        XCTAssertEqual(controller.rightButton.backgroundColor, UIColor.clear)

        XCTAssertTrue(controller.leftButton.isHidden)
        XCTAssertTrue(controller.rightButton.isHidden)
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        XCTAssertFalse(controller.genderButtonArrowImageView.isHidden)
        XCTAssertFalse(controller.genderButton.isHidden)
        XCTAssertFalse(controller.startButton.isHidden)
    }

    func test_pressing_genderButon_Changes_Gender_And_Gender_Button_Title() {
        controller.changeGenderStep()
        controller.userIsLady = true

        XCTAssertTrue(controller.userIsLady)
        let expectedFemaleString = NSLocalizedString("tap-viewController.gender-button.female.text", comment: "")
        XCTAssertEqual(controller.genderButton.title(for: .normal), expectedFemaleString)

        controller.onGenderButtonPressed(self)

        XCTAssertFalse(controller.userIsLady)
        let expectedMaleString = NSLocalizedString("tap-viewController.gender-button.male.text", comment: "")

        XCTAssertEqual(controller.genderButton.title(for: .normal), expectedMaleString )
    }


    //MARK: Screen Split Step -
    func test_screenSplitStep() {
        controller.screenSplitStep()

        XCTAssertEqual(controller.tutorialStep, 4)

        XCTAssertEqual(controller.firstLabel.text, NSLocalizedString("tutorial-viewController.screen-split-step.main-Label.text", comment: ""))
        XCTAssertEqual(controller.secondLabel.text, NSLocalizedString("tutorial-viewController.screen-split-step.detail-Label.text", comment: ""))

        XCTAssertFalse(controller.splitView.isHidden)

        XCTAssertEqual(controller.leftButton.backgroundColor, UIColor.clear)
        XCTAssertEqual(controller.rightButton.backgroundColor, UIColor.clear)

        XCTAssertFalse(controller.leftButton.isHidden)
        XCTAssertFalse(controller.rightButton.isHidden)
        XCTAssertFalse(controller.leftTapLabel.isHidden)
        XCTAssertFalse(controller.rightTapLabel.isHidden)

        XCTAssertTrue(controller.genderButtonArrowImageView.isHidden)
        XCTAssertTrue(controller.genderButton.isHidden)
        XCTAssertTrue(controller.startButton.isHidden)
    }

    func test_screenSplitStep_BackgroundImages() {
        controller.userIsLady = true
        controller.screenSplitStep()

        XCTAssertEqual(controller.leftButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "LeftHeel"))
        XCTAssertEqual(controller.rightButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "RightHeel"))

        controller.userIsLady = false
        controller.screenSplitStep()

        XCTAssertEqual(controller.leftButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "LeftMensShoe"))
        XCTAssertEqual(controller.rightButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "RightMensShoe"))
    }


    func test_screenSplitStep_screenSplitStepLeftButtonPressed() {
        controller.screenSplitStepLeftButtonPressed = false

        controller.screenSplitStep()

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)

        XCTAssertTrue(controller.screenSplitStepLeftButtonPressed)
        XCTAssertFalse(controller.screenSplitStepRightButtonPressed)

        XCTAssertEqual(controller.leftButton.backgroundColor, SalsaColors.white)
        XCTAssertNotEqual(controller.rightButton.backgroundColor, SalsaColors.white)
    }

    func test_screenSplitStep_screenSplitStepRightButtonPressed() {
        controller.screenSplitStepRightButtonPressed = false

        controller.screenSplitStep()

        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)

        XCTAssertFalse(controller.screenSplitStepLeftButtonPressed)
        XCTAssertTrue(controller.screenSplitStepRightButtonPressed)

        XCTAssertNotEqual(controller.leftButton.backgroundColor, SalsaColors.white)
        XCTAssertEqual(controller.rightButton.backgroundColor, SalsaColors.white)
    }

    func test_screenSplitStep_validateScreenSplitStepButtonsWerePressed() {
        controller.screenSplitStepLeftButtonPressed = false
        controller.screenSplitStepRightButtonPressed = false

        controller.screenSplitStep()

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)

        XCTAssertTrue(controller.screenSplitStepLeftButtonPressed)
        XCTAssertTrue(controller.screenSplitStepRightButtonPressed)

        XCTAssertEqual(controller.leftButton.backgroundColor, SalsaColors.white)
        XCTAssertEqual(controller.rightButton.backgroundColor, SalsaColors.white)

        XCTAssertEqual(controller.firstLabel.text, NSLocalizedString("tutorial-viewController.screen-split-validate.main-Label.text", comment: ""))
        XCTAssertEqual(controller.secondLabel.text, "")

        XCTAssertTrue(controller.splitView.isHidden)
        XCTAssertFalse(controller.startButton.isHidden)
    }

    //MARK: Count Step -

    func test_CountStep() {
        XCTAssertEqual(controller.stepCount, 0)
        controller.countStep()

        XCTAssertEqual(controller.stepCount, 1)

        XCTAssertEqual(controller.tutorialStep, 5)

        XCTAssertEqual(controller.firstLabel.text, NSLocalizedString("tutorial-viewController.count-step.main-Label.text", comment: ""))
        XCTAssertEqual(controller.secondLabel.text, NSLocalizedString("tutorial-viewController.count-step.detail-Label.text", comment: ""))

        XCTAssertTrue(controller.splitView.isHidden)

        XCTAssertEqual(controller.leftButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "Tutorial Floor"))
        XCTAssertEqual(controller.rightButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "Tutorial Floor"))

        let expectedFont = UIFont(name: "Salsa-Regular", size: 100)
        XCTAssertEqual(controller.leftButton.titleLabel?.font, expectedFont)
        XCTAssertEqual(controller.rightButton.titleLabel?.font, expectedFont)

        XCTAssertFalse(controller.leftButton.isHidden)
        XCTAssertFalse(controller.rightButton.isHidden)

        XCTAssertTrue(controller.genderButtonArrowImageView.isHidden)
        XCTAssertTrue(controller.genderButton.isHidden)
        XCTAssertTrue(controller.startButton.isHidden)
    }

    func test_displayCountStepCountsForLady() {
        controller.userIsLady = true
        controller.countStep()

        XCTAssertEqual(controller.leftButton.title(for: .normal), "")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "1")
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertFalse(controller.rightTapLabel.isHidden)

        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "2")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "")
        XCTAssertFalse(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "3")
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertFalse(controller.rightTapLabel.isHidden)

        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "5")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "")
        XCTAssertFalse(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "6")
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertFalse(controller.rightTapLabel.isHidden)

        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "7")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "")
        XCTAssertFalse(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)

        XCTAssertEqual(controller.stepCount, 0)
    }

    func test_displayCountStepCountsMen() {
        controller.userIsLady = false
        controller.countStep()
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "1")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "")
        XCTAssertFalse(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "2")
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertFalse(controller.rightTapLabel.isHidden)

        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "3")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "")
        XCTAssertFalse(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "5")
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertFalse(controller.rightTapLabel.isHidden)

        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "6")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "")
        XCTAssertFalse(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.leftButton.title(for: .normal), "")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "7")
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertFalse(controller.rightTapLabel.isHidden)

        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        
        XCTAssertEqual(controller.stepCount, 0)
    }

    func test_countStep_Complete() {
        controller.userIsLady = false
        controller.countStep()

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)

        XCTAssertEqual(controller.stepCount, 0)

        XCTAssertEqual(controller.firstLabel.text, NSLocalizedString("tutorial-viewController.count-complete.main-Label.text", comment: ""))
        XCTAssertEqual(controller.secondLabel.text, NSLocalizedString("tutorial-viewController.count-complete.detail-Label.text", comment: ""))

        XCTAssertEqual(controller.leftButton.title(for: .normal), "")
        XCTAssertEqual(controller.rightButton.title(for: .normal), "")

        XCTAssertTrue(controller.leftButton.isHidden)
        XCTAssertTrue(controller.rightButton.isHidden)
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        XCTAssertFalse(controller.startButton.isHidden)
    }


    //MARK: Accuarcy Step -

    func test_accuracyStep() {

        XCTAssertEqual(controller.timingStage, 1)

        controller.countStep()

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)

        controller.accuracyStep()

        XCTAssertEqual(controller.tutorialStep, 5)

        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.green)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, NSLocalizedString("tap-viewController.status-label.Dale.text", comment: ""))

        XCTAssertEqual(controller.timerLabelHeightContraint.constant, 150)

        XCTAssertEqual(controller.firstLabel.text, "")
        XCTAssertEqual(controller.secondLabel.text, NSLocalizedString("tutorial-viewController.accuracy-step.detail-Label.accurate.text", comment: ""))

        XCTAssertTrue(controller.splitView.isHidden)

        XCTAssertTrue(controller.leftButton.isHidden)
        XCTAssertTrue(controller.rightButton.isHidden)

        XCTAssertTrue(controller.genderButtonArrowImageView.isHidden)
        XCTAssertTrue(controller.genderButton.isHidden)
        XCTAssertFalse(controller.startButton.isHidden)
    }


    func test_accuracyStep_Stage_2() {

        XCTAssertEqual(controller.timingStage, 1)

        controller.countStep()

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)

        controller.accuracyStep()

        XCTAssertEqual(controller.timingStage, 2)

        controller.startButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(controller.tutorialStep, 5)

        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.yellow)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.text, NSLocalizedString("tap-viewController.status-label.Almost.text", comment: ""))

        XCTAssertEqual(controller.timerLabelHeightContraint.constant, 150)

        XCTAssertEqual(controller.firstLabel.text, "")
        XCTAssertEqual(controller.secondLabel.text, NSLocalizedString("tutorial-viewController.accuracy-step.detail-Label.almost-Accurate.text", comment: ""))

        XCTAssertTrue(controller.splitView.isHidden)

        XCTAssertTrue(controller.leftButton.isHidden)
        XCTAssertTrue(controller.rightButton.isHidden)

        XCTAssertTrue(controller.genderButtonArrowImageView.isHidden)
        XCTAssertTrue(controller.genderButton.isHidden)
        XCTAssertFalse(controller.startButton.isHidden)
    }


    func test_accuracyStep_Stage_3() {

        XCTAssertEqual(controller.timingStage, 1)

        controller.countStep()

        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.leftButton.sendActions(for: UIControlEvents.touchUpInside)
        controller.rightButton.sendActions(for: UIControlEvents.touchUpInside)

        controller.accuracyStep()

        controller.startButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(controller.timingStage, 3)
        XCTAssertEqual(controller.tutorialStep, 5)

        controller.startButton.sendActions(for: .touchUpInside)

        XCTAssertEqual(controller.tutorialStep, 6)

        XCTAssertEqual(controller.timerLabel.backgroundColor, SalsaColors.red)
        XCTAssertEqual(controller.timerLabel.textColor, SalsaColors.white)
        XCTAssertEqual(controller.timerLabel.text, NSLocalizedString("tap-viewController.status-label.Focus.text", comment: ""))

        XCTAssertEqual(controller.timerLabelHeightContraint.constant, 150)

        XCTAssertEqual(controller.firstLabel.text, "")
        XCTAssertEqual(controller.secondLabel.text,  NSLocalizedString("tutorial-viewController.accuracy-step.detail-Label.inaccurate.text", comment: ""))

        XCTAssertTrue(controller.splitView.isHidden)

        XCTAssertTrue(controller.leftButton.isHidden)
        XCTAssertTrue(controller.rightButton.isHidden)

        XCTAssertTrue(controller.genderButtonArrowImageView.isHidden)
        XCTAssertTrue(controller.genderButton.isHidden)
        XCTAssertFalse(controller.startButton.isHidden)
    }

    //MARK: Guide Step -

    func test_guideStep() {
        controller.guideStep()

        XCTAssertEqual(controller.tutorialStep, 7)

        XCTAssertEqual(controller.firstLabel.text, NSLocalizedString("tutorial-viewController.guide-step.main-Label.text", comment: ""))
        XCTAssertEqual(controller.secondLabel.text, NSLocalizedString("tutorial-viewController.guide-step.detail-Label.text", comment: ""))

        XCTAssertTrue(controller.splitView.isHidden)

        XCTAssertEqual(controller.leftButton.backgroundColor, UIColor.clear)
        XCTAssertEqual(controller.rightButton.backgroundColor, UIColor.clear)


        XCTAssertFalse(controller.leftButton.isHidden)
        XCTAssertFalse(controller.rightButton.isHidden)
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        XCTAssertTrue(controller.genderButtonArrowImageView.isHidden)
        XCTAssertTrue(controller.genderButton.isHidden)
        XCTAssertFalse(controller.startButton.isHidden)
    }

    func test_guideStep_BackgroundImages() {
        controller.userIsLady = true
        controller.guideStep()

        XCTAssertEqual(controller.leftButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "LeftHeelGuide"))
        XCTAssertEqual(controller.rightButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "RightHeelGuide"))

        controller.userIsLady = false
        controller.guideStep()

        XCTAssertEqual(controller.leftButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "LeftShoeGuide"))
        XCTAssertEqual(controller.rightButton.backgroundImage(for: .normal), #imageLiteral(resourceName: "RightShoeGuide"))
    }


    //MARK: Final Step -

    func test_finalStep() {
        controller.finalStep()
        XCTAssertEqual(controller.tutorialStep, 8)

        XCTAssertEqual(controller.firstLabel.text, NSLocalizedString("tutorial-viewController.final-step.main-Label.text", comment: ""))
        XCTAssertEqual(controller.secondLabel.text, NSLocalizedString("tutorial-viewController.final-step.detail-Label.text", comment: ""))

        XCTAssertTrue(controller.splitView.isHidden)

        XCTAssertEqual(controller.leftButton.backgroundColor, UIColor.clear)
        XCTAssertEqual(controller.rightButton.backgroundColor, UIColor.clear)

        XCTAssertTrue(controller.leftButton.isHidden)
        XCTAssertTrue(controller.rightButton.isHidden)
        XCTAssertTrue(controller.leftTapLabel.isHidden)
        XCTAssertTrue(controller.rightTapLabel.isHidden)

        XCTAssertTrue(controller.genderButtonArrowImageView.isHidden)
        XCTAssertTrue(controller.genderButton.isHidden)
        XCTAssertFalse(controller.startButton.isHidden)
    }

    func test_tutorialStep5_Start_Button_Dismeisses_ViewController() {

        let controller = TutorialViewControllerStub()
        let _ = controller.view

        controller.viewDidLoad()
        controller.finalStep()
        controller.onStartButtonPressed(self)

        XCTAssertTrue(controller.dismissed)
    }

    class TutorialViewControllerStub: TutorialViewController {
        
        var dismissed = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
            dismissed = true
            completion?()
        }
    }
}
