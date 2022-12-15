import UIKit
import GoogleMobileAds

class BannerOverlappedViewController: BaseAdViewController {
    
    @IBOutlet weak var bannerAdContainer: UIView!
    @IBOutlet weak var bannerWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var debugButton: UIButton!
    @IBOutlet weak var mrectTypeSegmented: UISegmentedControl!
    @IBOutlet weak var overlappedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAd(type: BaseAdViewController.shared.adType, delegate: self, adContainer: bannerAdContainer)
        setSizeConstraints(widthConstraint: bannerWidthLayoutConstraint, heightConstraint: bannerHeightLayoutConstraint)
        setViewTitle(adScenario: "Overlapped")
        debugButton.isHidden = true
        mrectTypeSegmented.isHidden = BaseAdViewController.shared.adType == .MRectVideo || BaseAdViewController.shared.adType == .MRectHTML ? false : true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        adView.removeFromSuperview()
    }
        
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        activityIndicator.startAnimating()
        overlappedView.isHidden = true
        bannerAdContainer.isHidden = true
        adView.load(GADRequest())
        debugButton.isHidden = true
        
    }
    
    @IBAction func choosingMRectType(_ sender: UISegmentedControl) {
        debugButton.isHidden = true
        overlappedView.isHidden = true
        if sender.selectedSegmentIndex == 0 {
            createAd(type: .MRectVideo, delegate: self, adContainer: bannerAdContainer)
        } else {
            createAd(type: .MRectHTML, delegate: self, adContainer: bannerAdContainer)
        }
    }
    
    @IBAction func showDebugView(_ sender: Any) {
        self.showDebugPageSheet()
    }
}

// MARK: - MAAdDelegate delegate
extension BannerOverlappedViewController : GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        activityIndicator.stopAnimating()
        debugButton.isHidden = false
    }
}

extension BannerOverlappedViewController : GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        debugButton.isHidden = false
        overlappedView.isHidden = false
        bannerAdContainer.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        debugButton.isHidden = false
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        eventPageSheet?.adMobEvents.append(Event(name: "Impression"))
    }
    
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        eventPageSheet?.adMobEvents.append(Event(name: "Click"))
    }
}
