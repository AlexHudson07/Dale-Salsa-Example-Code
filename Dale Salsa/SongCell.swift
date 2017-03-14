import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var fillerView: UIView!
    
    @IBOutlet weak var songContainerView: UIView!
    @IBOutlet weak var songInfoLabel: UILabel!

    @IBOutlet weak var artistContainerView: UIView!
    @IBOutlet weak var artistInfoLabel: UILabel!

    var songName: String? {
        didSet { songInfoLabel?.text = songName! }
    }
    
    var artist: String? {
        didSet { artistInfoLabel?.text = artist! }
    }
    
    var songIsDownloaded = false {
        didSet{
            downloadLabel?.isHidden = songIsDownloaded
            if songIsDownloaded {
                progressView?.isHidden = true
            }
        }
    }
    
    var songPercentage: CGFloat = 0.0 {
        didSet{
            setDownloadProgress(percentage: songPercentage)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverArtImageView?.clipsToBounds = true
        
        progressView?.layer.cornerRadius = progressView.frame.height/2
        progressView?.layer.borderWidth = 2
        progressView?.layer.borderColor = UIColor.white.cgColor
        progressView?.isHidden = true
        progressView?.clipsToBounds = true
        
        downloadLabel?.layer.cornerRadius = downloadLabel.frame.height/2
        downloadLabel?.clipsToBounds = true
        downloadLabel?.backgroundColor = SalsaColors.green
        downloadLabel?.text = NSLocalizedString("sideMenu-viewController.download-button.title", comment: "")

        songContainerView?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
        
        artistContainerView?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func showLockedLabel() {
        downloadLabel?.text = NSLocalizedString("sideMenu-viewController.download-button.unlock.title", comment: "")
    }

    func showUnlockedLabel() {
        downloadLabel?.text = NSLocalizedString("sideMenu-viewController.download-button.title", comment: "")
    }

    private func setDownloadProgress(percentage: CGFloat) {
        downloadLabel?.isHidden = true
        progressView?.isHidden = false
        
        guard let progressView = progressView else {return}
        
        let progressWidth = (progressView.frame.width * percentage) / 100.00
        
        weak var weakSelf = self

        UIView.animate(withDuration: 0.1, animations: {
            weakSelf?.fillerView.frame = CGRect(x: self.fillerView.frame.origin.x,
                                           y: self.fillerView.frame.origin.x,
                                           width: progressWidth,
                                           height: self.fillerView.frame.size.height)

        })
        if percentage >= 100 { progressView.isHidden = true }
    }
}
