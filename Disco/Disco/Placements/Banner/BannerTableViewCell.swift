import UIKit
import GoogleMobileAds

enum BannerState {
    case initialized
    case loading
    case loaded
    case failed
}

class BannerTableViewCell: UITableViewCell {
        
    @IBOutlet weak var bannerContainerView: UIView!
    @IBOutlet weak var bannerLoader: UIActivityIndicatorView!
    @IBOutlet weak var bannerWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerHeightLayoutConstraint: NSLayoutConstraint!
        
    var state: BannerState! = .initialized {
        didSet {
            switch(state){
            case .initialized:
                bannerContainerView.isHidden = true
                bannerLoader.isHidden = true
            case .loading:
                bannerContainerView.isHidden = false
                bannerLoader.isHidden = false
                bannerLoader.startAnimating()
            case .loaded:
                bannerContainerView.isHidden = false
                bannerLoader.isHidden = true
                bannerLoader.stopAnimating()
            case .failed:
                bannerContainerView.isHidden = true
                bannerLoader.isHidden = true
                bannerLoader.stopAnimating()
            case .none:
                bannerContainerView.isHidden = true
                bannerLoader.isHidden = true
                bannerLoader.stopAnimating()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension BannerTableViewCell: SetBannerState {
    func setState(state: BannerState) {
        self.state = state
    }
    
    func setBanner(banner: GADBannerView) {
        self.bannerContainerView.subviews.forEach({ $0.removeFromSuperview() })
        self.bannerContainerView.addSubview(banner)
        BaseAdViewController.shared.adView = banner
        BaseAdViewController.shared.setSizeConstraints(widthConstraint: bannerWidthLayoutConstraint, heightConstraint: bannerHeightLayoutConstraint)
    }
}
