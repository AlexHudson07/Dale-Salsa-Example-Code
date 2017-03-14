import UIKit

protocol TutorialProtocal {
    func tutorialComplete()
    func tutorialChangedGender()
}

class TutorialViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerLabelHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var leftTapLabel: UILabel!
    @IBOutlet weak var rightTapLabel: UILabel!
    
    @IBOutlet weak var splitView: UIView!

    @IBOutlet weak var genderButtonArrowImageView: UIImageView!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var delegate : TutorialProtocal?

    let defaults = UserDefaults.standard

    var userIsLady = true {
        didSet{
            if userIsLady {
                genderButton?.setTitle(NSLocalizedString("tap-viewController.gender-button.female.text", comment: ""), for: UIControlState())
                defaults.set(true, forKey: k.gender)
            } else {
                genderButton?.setTitle(NSLocalizedString("tap-viewController.gender-button.male.text", comment: ""), for: UIControlState())
                defaults.set(false, forKey: k.gender)
            }
        }
    }

    var genderHasBeenPicked = false {
        didSet{
            if genderHasBeenPicked {

                if userIsLady {
                    firstLabel?.text = NSLocalizedString("tutorial-viewController.gender-picked.main-Label.female.text", comment: "")
                } else {
                    firstLabel?.text = NSLocalizedString("tutorial-viewController.gender-picked.main-Label.male.text", comment: "")
                }
                secondLabel?.text = ""
                startButton?.isHidden = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userIsLady = defaults.bool(forKey: k.gender)

        splitView?.layer.borderColor = SalsaColors.green.cgColor
        splitView?.layer.cornerRadius = 2

        timerLabel?.layer.cornerRadius = 4
        timerLabel?.clipsToBounds = true
        timerLabelHeightContraint?.constant = 0
        leftButton?.layer.cornerRadius = 4
        leftButton?.clipsToBounds = true
        leftButton?.setTitleColor(SalsaColors.red, for: UIControlState())
        rightButton?.layer.cornerRadius = 4
        rightButton?.clipsToBounds = true
        rightButton?.setTitleColor(SalsaColors.red, for: UIControlState())

        leftTapLabel?.text = NSLocalizedString("tutorial-viewController.tap-label.text", comment: "")
        rightTapLabel?.text = NSLocalizedString("tutorial-viewController.tap-label.text", comment: "")

        genderButton?.layer.cornerRadius = 4
        startButton?.layer.cornerRadius = 4
        startButton?.titleLabel?.adjustsFontSizeToFitWidth = true
        
        welcomeStep()
    }

    func handleTap() {

        switch tutorialStep {
        case 1:
            pickGenderStep()
        case 2:
            if genderHasBeenPicked { changeGenderStep() }
        case 3:
            screenSplitStep()
        case 4:
            countStep()
        case 5:
            accuracyStep()
        case 6:
            guideStep()
        case 7:
            finalStep()
        default:
            dismiss(animated: false, completion: {
                self.delegate?.tutorialComplete()
            })
        }
    }
    
    var tutorialStep = 1
    
    func welcomeStep() {
        tutorialStep = 1

        firstLabel?.text = NSLocalizedString("tutorial-viewController.welcome-step.main-Label.text", comment: "")
        secondLabel?.text = NSLocalizedString("tutorial-viewController.welcome-step.detail-Label.text", comment: "")
        startButton?.setTitle(NSLocalizedString("tutorial-viewController.next-button.title", comment: ""), for: .normal)

        splitView?.isHidden = true

        leftButton?.setBackgroundImage(#imageLiteral(resourceName: "Left Thumb"), for: UIControlState())
        rightButton?.setBackgroundImage(#imageLiteral(resourceName: "Right Thumb"), for: UIControlState())
        leftTapLabel?.isHidden = false
        rightTapLabel?.isHidden = false

        genderButtonArrowImageView?.isHidden = true
        genderButton?.isHidden = true
        startButton?.isHidden = true
    }
    
    func pickGenderStep() {
        tutorialStep = 2

        firstLabel?.text = NSLocalizedString("tutorial-viewController.pick-gender-step.main-Label.text", comment: "")
        secondLabel?.text = ""

        leftButton?.backgroundColor = UIColor.clear
        rightButton?.backgroundColor = UIColor.clear

        leftButton?.setBackgroundImage(#imageLiteral(resourceName: "GuyWithBackground"), for: UIControlState())
        rightButton?.setBackgroundImage(#imageLiteral(resourceName: "GirlWithBackground"), for: UIControlState())

        leftButton?.isHidden = false
        rightButton?.isHidden = false
        leftTapLabel?.isHidden = false
        rightTapLabel?.isHidden = false

        genderButtonArrowImageView?.isHidden = true
        genderButton?.isHidden = true
        startButton?.isHidden = true
    }

    func changeGenderStep() {
        tutorialStep = 3

        firstLabel?.text = NSLocalizedString("tutorial-viewController.change-gender-step.main-Label.text", comment: "")
        secondLabel?.text = NSLocalizedString("tutorial-viewController.change-gender-step.detail-Label.text", comment: "")

        leftButton?.backgroundColor = UIColor.clear
        rightButton?.backgroundColor = UIColor.clear

        leftButton?.isHidden = true
        rightButton?.isHidden = true
        leftTapLabel?.isHidden = true
        rightTapLabel?.isHidden = true

        genderButtonArrowImageView?.isHidden = false
        genderButton?.isHidden = false
        startButton?.isHidden = false
    }

    func screenSplitStep() {
        tutorialStep = 4

        firstLabel?.text = NSLocalizedString("tutorial-viewController.screen-split-step.main-Label.text", comment: "")
        secondLabel?.text = NSLocalizedString("tutorial-viewController.screen-split-step.detail-Label.text", comment: "")

        splitView?.isHidden = false

        leftButton?.backgroundColor = UIColor.clear
        rightButton?.backgroundColor = UIColor.clear

        if userIsLady {
            leftButton?.setBackgroundImage(#imageLiteral(resourceName: "LeftHeel"), for: UIControlState())
            rightButton?.setBackgroundImage(#imageLiteral(resourceName: "RightHeel"), for: UIControlState())
        } else {
            leftButton?.setBackgroundImage(#imageLiteral(resourceName: "LeftMensShoe"), for: UIControlState())
            rightButton?.setBackgroundImage(#imageLiteral(resourceName: "RightMensShoe"), for: UIControlState())
        }

        leftButton?.isHidden = false
        rightButton?.isHidden = false
        leftTapLabel?.isHidden = false
        rightTapLabel?.isHidden = false

        genderButtonArrowImageView?.isHidden = true
        genderButton?.isHidden = true
        startButton?.isHidden = true
    }

    var stepCount = 0
    func countStep() {
        tutorialStep = 5

        firstLabel?.text = NSLocalizedString("tutorial-viewController.count-step.main-Label.text", comment: "")
        secondLabel?.text = NSLocalizedString("tutorial-viewController.count-step.detail-Label.text", comment: "")

        splitView?.isHidden = true

        leftButton?.setBackgroundImage(#imageLiteral(resourceName: "Tutorial Floor"), for: UIControlState())
        rightButton?.setBackgroundImage(#imageLiteral(resourceName: "Tutorial Floor"), for: UIControlState())

        leftButton?.titleLabel?.font = UIFont(name: "Salsa-Regular", size: 100)
        rightButton?.titleLabel?.font = UIFont(name: "Salsa-Regular", size: 100)

        leftButton?.isHidden = false
        rightButton?.isHidden = false
        leftTapLabel?.isHidden = false
        rightTapLabel?.isHidden = false

        genderButtonArrowImageView?.isHidden = true
        genderButton?.isHidden = true
        startButton?.isHidden = true

        displayCountStepCounts()
    }

    var timingStage = 1
    func accuracyStep() {
        switch timingStage {
        case 1 :
            timerLabelHeightContraint?.constant = 150
            accurateTiming()
            firstLabel?.text = ""
            secondLabel?.text = NSLocalizedString("tutorial-viewController.accuracy-step.detail-Label.accurate.text", comment: "")
        case 2:
            somewhateAccurateTiming()
            secondLabel?.text = NSLocalizedString("tutorial-viewController.accuracy-step.detail-Label.almost-Accurate.text", comment: "")

        case 3:
            inaccurateTiming()
            secondLabel?.text = NSLocalizedString("tutorial-viewController.accuracy-step.detail-Label.inaccurate.text", comment: "")

            tutorialStep = 6
        default:
            print ("tutorial timing step error")
        }
        timingStage += 1

        leftButton?.isHidden = true
        rightButton?.isHidden = true
        leftTapLabel?.isHidden = true
        rightTapLabel?.isHidden = true

        startButton?.isHidden = false
    }

    func guideStep() {
        tutorialStep = 7

        timerLabelHeightContraint?.constant = 0

        firstLabel?.text = NSLocalizedString("tutorial-viewController.guide-step.main-Label.text", comment: "")
        secondLabel?.text = NSLocalizedString("tutorial-viewController.guide-step.detail-Label.text", comment: "")

        splitView?.isHidden = true

        leftButton?.backgroundColor = UIColor.clear
        rightButton?.backgroundColor = UIColor.clear

        if userIsLady {
            leftButton?.setBackgroundImage(#imageLiteral(resourceName: "LeftHeelGuide"), for: UIControlState())
            rightButton?.setBackgroundImage(#imageLiteral(resourceName: "RightHeelGuide"), for: UIControlState())
        } else {
            leftButton?.setBackgroundImage(#imageLiteral(resourceName: "LeftShoeGuide"), for: UIControlState())
            rightButton?.setBackgroundImage(#imageLiteral(resourceName: "RightShoeGuide"), for: UIControlState())
        }

        leftButton?.isHidden = false
        rightButton?.isHidden = false
        leftTapLabel?.isHidden = true
        rightTapLabel?.isHidden = true

        genderButtonArrowImageView?.isHidden = true
        genderButton?.isHidden = true
        startButton?.isHidden = false
    }

    func finalStep() {
        tutorialStep = 8
        timerLabelHeightContraint?.constant = 0
        firstLabel?.text = NSLocalizedString("tutorial-viewController.final-step.main-Label.text", comment: "")
        secondLabel?.text = NSLocalizedString("tutorial-viewController.final-step.detail-Label.text", comment: "")

        leftButton?.backgroundColor = UIColor.clear
        rightButton?.backgroundColor = UIColor.clear

        leftButton?.isHidden = true
        rightButton?.isHidden = true
        leftTapLabel?.isHidden = true
        rightTapLabel?.isHidden = true

        startButton?.setTitle(NSLocalizedString("tap-viewController.start-button.start.text", comment: ""), for: .normal)
        startButton?.isHidden = false
    }

    @IBAction func onLeftButtonPressed(_ sender: UIButton ) {
        
        switch tutorialStep {
        case 1:
            validateWelcomeStepButtonsWerePressed(1)
        case 2:
            userIsLady = false
            genderHasBeenPicked = true
            leftButton?.setBackgroundImage(#imageLiteral(resourceName: "GuyWithBackground"), for: UIControlState())
            rightButton?.setBackgroundImage(#imageLiteral(resourceName: "GirlWithOutBackground"), for: UIControlState())
            delegate?.tutorialChangedGender()
        case 4:
            validateScreenSplitStepButtonsWerePressed(1)
        case 5:
            if userIsLady {
                if [0,2,5,7].contains(stepCount) { displayCountStepCounts() }
            } else {
                if [1,4,6].contains(stepCount) { displayCountStepCounts() }
            }
        default:
            print ("")
        }
    }
    
    @IBAction func onRightButtonPressed(_ sender: UIButton ) {
        switch tutorialStep {
        case 1:
            validateWelcomeStepButtonsWerePressed(2)
        case 2:
            userIsLady = true
            genderHasBeenPicked = true
            leftButton?.setBackgroundImage(#imageLiteral(resourceName: "GuyWithOutBackground"), for: UIControlState())
            rightButton?.setBackgroundImage(#imageLiteral(resourceName: "GirlWithBackground"), for: UIControlState())
            delegate?.tutorialChangedGender()
        case 4:
            validateScreenSplitStepButtonsWerePressed(2)
        case 5:
            if userIsLady {
                if [1,4,6].contains(stepCount) { displayCountStepCounts() }
            } else {
                if [0,2,5,7].contains(stepCount) { displayCountStepCounts() }
            }
        default:
            print ("")
        }
    }
    
    var tutorialStep1LeftButtonPressed = false
    var tutorialStep1RightButtonPressed = false

    func validateWelcomeStepButtonsWerePressed(_ buttonIndex: Int) {
        
        if buttonIndex == 1 {
            if tutorialStep1LeftButtonPressed {
                return
            } else {
                tutorialStep1LeftButtonPressed = true
                leftButton?.backgroundColor = SalsaColors.green
            }
        }
        
        if buttonIndex == 2 {
            if tutorialStep1RightButtonPressed {
                return
            } else {
                tutorialStep1RightButtonPressed = true
                rightButton?.backgroundColor = SalsaColors.green
            }
        }
        
        if tutorialStep1LeftButtonPressed && tutorialStep1RightButtonPressed {
            firstLabel?.text = NSLocalizedString("tutorial-viewController.welcome-validate.main-Label.text", comment: "")
            startButton?.isHidden = false
        }
    }

    var screenSplitStepLeftButtonPressed = false
    var screenSplitStepRightButtonPressed = false

    func validateScreenSplitStepButtonsWerePressed(_ buttonIndex: Int) {
        if buttonIndex == 1 {
            if screenSplitStepLeftButtonPressed {
                return
            } else {
                screenSplitStepLeftButtonPressed = true
                leftButton?.backgroundColor = SalsaColors.white
            }
        }

        if buttonIndex == 2 {
            if screenSplitStepRightButtonPressed {
                return
            } else {
                screenSplitStepRightButtonPressed = true
                rightButton?.backgroundColor = SalsaColors.white
            }
        }

        if screenSplitStepLeftButtonPressed && screenSplitStepRightButtonPressed {
            firstLabel?.text = NSLocalizedString("tutorial-viewController.screen-split-validate.main-Label.text", comment: "")
            secondLabel?.text = ""
            splitView?.isHidden = true
            startButton?.isHidden = false
        }
    }

    func displayCountStepCounts() {
        switch stepCount {
            
        case 0:
            if userIsLady {
                leftButton?.setTitle("", for: UIControlState())
                rightButton?.setTitle(NSLocalizedString("tutorial-viewController.one.text", comment: ""), for: UIControlState())
                leftTapLabel?.isHidden = true
                rightTapLabel?.isHidden = false
            } else {
                leftButton?.setTitle(NSLocalizedString("tutorial-viewController.one.text", comment: ""), for: UIControlState())
                rightButton?.setTitle("", for: UIControlState())
                leftTapLabel?.isHidden = false
                rightTapLabel?.isHidden = true
            }
            
        case 1:
            if userIsLady {
                leftButton?.setTitle(NSLocalizedString("tutorial-viewController.two.text", comment: ""), for: UIControlState())
                rightButton?.setTitle("", for: UIControlState())
                leftTapLabel?.isHidden = false
                rightTapLabel?.isHidden = true
            } else {
                leftButton?.setTitle("", for: UIControlState())
                rightButton?.setTitle(NSLocalizedString("tutorial-viewController.two.text", comment: ""), for: UIControlState())
                leftTapLabel?.isHidden = true
                rightTapLabel?.isHidden = false
            }
            
        case 2:
            if userIsLady {
                leftButton?.setTitle("", for: UIControlState())
                rightButton?.setTitle(NSLocalizedString("tutorial-viewController.three.text", comment: ""), for: UIControlState())
                leftTapLabel?.isHidden = true
                rightTapLabel?.isHidden = false
            } else {
                leftButton?.setTitle(NSLocalizedString("tutorial-viewController.three.text", comment: ""), for: UIControlState())
                rightButton?.setTitle("", for: UIControlState())
                leftTapLabel?.isHidden = false
                rightTapLabel?.isHidden = true
            }
            
        case 4:
            if userIsLady {
                leftButton?.setTitle(NSLocalizedString("tutorial-viewController.five.text", comment: ""), for: UIControlState())
                rightButton?.setTitle("", for: UIControlState())
                leftTapLabel?.isHidden = false
                rightTapLabel?.isHidden = true
            } else {
                leftButton?.setTitle("", for: UIControlState())
                rightButton?.setTitle(NSLocalizedString("tutorial-viewController.five.text", comment: ""), for: UIControlState())
                leftTapLabel?.isHidden = true
                rightTapLabel?.isHidden = false
            }

        case 5:
            if userIsLady {
                leftButton?.setTitle("", for: UIControlState())
                rightButton?.setTitle(NSLocalizedString("tutorial-viewController.six.text", comment: ""), for: UIControlState())
                leftTapLabel?.isHidden = true
                rightTapLabel?.isHidden = false
            } else {
                leftButton?.setTitle(NSLocalizedString("tutorial-viewController.six.text", comment: ""), for: UIControlState())
                rightButton?.setTitle("", for: UIControlState())
                leftTapLabel?.isHidden = false
                rightTapLabel?.isHidden = true
            }
            
        case 6:
            if userIsLady {
                leftButton?.setTitle(NSLocalizedString("tutorial-viewController.seven.text", comment: ""), for: UIControlState())
                rightButton?.setTitle("", for: UIControlState())
                leftTapLabel?.isHidden = false
                rightTapLabel?.isHidden = true
            } else {
                leftButton?.setTitle("", for: UIControlState())
                rightButton?.setTitle(NSLocalizedString("tutorial-viewController.seven.text", comment: ""), for: UIControlState())
                leftTapLabel?.isHidden = true
                rightTapLabel?.isHidden = false
            }

        default:
            print("done with step counts")
        }
        
        if stepCount == 7 {
            stepCount = 0

            firstLabel?.text = NSLocalizedString("tutorial-viewController.count-complete.main-Label.text", comment: "")
            secondLabel?.text = NSLocalizedString("tutorial-viewController.count-complete.detail-Label.text", comment: "")

            leftButton?.setTitle("", for: UIControlState())
            rightButton?.setTitle("", for: UIControlState())

            leftButton?.isHidden = true
            rightButton?.isHidden = true
            leftTapLabel?.isHidden = true
            rightTapLabel?.isHidden = true

            startButton?.isHidden = false
            return
        }
        
        stepCount += 1
        if stepCount == 3 {stepCount = 4}
    }
    
    @IBAction func onGenderButtonPressed(_ sender: AnyObject ) {
        userIsLady = !userIsLady

        if tutorialStep == 2 {
            if userIsLady {
                leftButton?.setBackgroundImage(#imageLiteral(resourceName: "GuyWithOutBackground"), for: UIControlState())
                rightButton?.setBackgroundImage(#imageLiteral(resourceName: "GirlWithBackground"), for: UIControlState())
            } else {
                leftButton?.setBackgroundImage(#imageLiteral(resourceName: "GuyWithBackground"), for: UIControlState())
                rightButton?.setBackgroundImage(#imageLiteral(resourceName: "GirlWithOutBackground"), for: UIControlState())
            }
        }
        
        genderHasBeenPicked = true
        delegate?.tutorialChangedGender()
    }
    
    
    @IBAction func onStartButtonPressed(_ sender: AnyObject) {
        handleTap()
    }
    
    func accurateTiming() {
        timerLabel?.backgroundColor = SalsaColors.green
        timerLabel?.textColor = SalsaColors.white
        timerLabel?.text = NSLocalizedString("tap-viewController.status-label.Dale.text", comment: "")
    }
    
    func somewhateAccurateTiming() {
        timerLabel?.backgroundColor = SalsaColors.yellow
        timerLabel?.textColor = SalsaColors.red
        timerLabel?.text = NSLocalizedString("tap-viewController.status-label.Almost.text", comment: "")
    }
    
    func inaccurateTiming() {
        timerLabel?.backgroundColor = SalsaColors.red
        timerLabel?.textColor = SalsaColors.white
        timerLabel?.text = NSLocalizedString("tap-viewController.status-label.Focus.text", comment: "")
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
