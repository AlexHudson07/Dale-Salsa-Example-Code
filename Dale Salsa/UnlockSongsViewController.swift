import UIKit
import StoreKit

class UnlockSongsViewController: UIViewController, SWRevealViewControllerDelegate {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var redeemButton: UIButton!

    var price = ""

    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [k.salsaUnlockedIdentifier]
    let store = IAPHelper(productIds: UnlockSongsViewController.productIdentifiers)

    var salsaProduct: SKProduct?
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setText()
        requestProducts()
        addNotificationObservers()
    }

    func requestProducts() {
        showLoadingIcon()

        infoLabel?.isHidden = true
        buyButton.isHidden = true

        store.requestProducts { (success, products) in
            if success {
                self.infoLabel?.isHidden = false
                self.buyButton.isHidden = false

                self.salsaProduct = products?.first
                if let price = self.salsaProduct?.price {
                    self.price = "\(price)"
                }

                let infoLabelString = String(format: NSLocalizedString("in-app-purchase-viewController.info-label.text", comment: ""), self.price)

                self.infoLabel?.text = infoLabelString

                self.backButton?.setTitle(NSLocalizedString("in-app-purchase-viewController.back-button.puppy.title", comment: ""), for: .normal)
                self.hideLoadingIcon()
            }
        }
    }

    deinit {
        removeNotificationObservers()
    }

    //MARK: Notifications -

    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UnlockSongsViewController.checkPurchases(_:)),
                                               name: NSNotification.Name(rawValue: k.IAPHelperPurchaseNotification),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UnlockSongsViewController.restoredPurchases(_:)),
                                               name: NSNotification.Name(rawValue: k.IAPHelperRestoreNotification),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UnlockSongsViewController.restoreFailed(_:)),
                                               name: NSNotification.Name(rawValue: k.IAPHelperRestoreFailedNotification),
                                               object: nil)
    }


    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self,
                                               name: NSNotification.Name(rawValue: k.IAPHelperPurchaseNotification),
                                               object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: k.IAPHelperRestoreNotification),
                                                  object: nil)

        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: k.IAPHelperRestoreFailedNotification),
                                                  object: nil)
    }

    func checkPurchases(_ notification: NSNotification) {
        defaults.set(true, forKey:k.unlockedSalsaSongs )
        backButton?.setTitle(NSLocalizedString("in-app-purchase-viewController.back-button.normal.title", comment: ""), for: .normal)
    }

    func restoredPurchases(_ notification: NSNotification) {
        defaults.set(true, forKey:k.unlockedSalsaSongs )
        infoLabel?.text = NSLocalizedString("in-app-purchase-viewController.info-Label.restored.title", comment: "")
        buyButton.isHidden = true
        backButton?.setTitle(NSLocalizedString("in-app-purchase-viewController.back-button.normal.title", comment: ""), for: .normal)
    }

    func restoreFailed(_ notification: NSNotification) {
        infoLabel?.text = "Purchases Restore failed"
        buyButton?.setTitle("Unlock Songs", for: .normal)
        backButton?.setTitle(NSLocalizedString("in-app-purchase-viewController.back-button.normal.title", comment: ""), for: .normal)
    }

    //MARK: Localizatoin and UI -
    func setText() {

        let infoLabelString = String(format: NSLocalizedString("in-app-purchase-viewController.info-label.text", comment: ""), price)

        infoLabel?.text = infoLabelString
        buyButton?.setTitle(NSLocalizedString("in-app-purchase-viewController.buy-button.title", comment: ""), for: .normal)
        backButton?.setTitle(NSLocalizedString("in-app-purchase-viewController.back-button.normal.title", comment: ""), for: .normal)
        redeemButton?.setTitle(NSLocalizedString("in-app-purchase-viewController.redeem-button.title", comment: ""), for: .normal)
    }

    func setUI() {
        buyButton?.layer.cornerRadius = 4
        backButton?.layer.cornerRadius = 4
        redeemButton?.layer.cornerRadius = 4
    }

    //MARK: SWReavealController Delegate Functions -
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
    }

    //MARK: Buttons -
    @IBAction func onBuyButtonPressed(_ sender: UIButton) {
        store.buyProduct(salsaProduct!)
    }

    @IBAction func onBackButtonPressed(_ sender: UIButton) {
       self.revealViewController().revealToggle(sender)
    }

    @IBAction func onRedeemButtonPressed(_ sender: UIButton) {
        store.restorePurchases()
    }

    //MARK: -
    override var prefersStatusBarHidden : Bool {
        return true
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
}
