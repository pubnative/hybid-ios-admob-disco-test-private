import UIKit
import GoogleMobileAds

class BannerInViewViewController: BaseAdViewController {
        
    @IBOutlet weak var bannerAdContainer: UIView!
    @IBOutlet weak var bannerWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var debugButton: UIButton!
    @IBOutlet weak var mrectTypeSegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAd(type: BaseAdViewController.shared.adType, delegate: self, adContainer: bannerAdContainer)
        setSizeConstraints(widthConstraint: bannerWidthLayoutConstraint, heightConstraint: bannerHeightLayoutConstraint)
        setViewTitle(adScenario: "In-view")
        debugButton.isHidden = true
        mrectTypeSegmented.isHidden = BaseAdViewController.shared.adType == .MRectVideo || BaseAdViewController.shared.adType == .MRectHTML ? false : true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        adView.removeFromSuperview()
    }
        
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        activityIndicator.startAnimating()
        bannerAdContainer.isHidden = true
        adView.load(GADRequest())
        debugButton.isHidden = true
    }
    
    @IBAction func choosingMRectType(_ sender: UISegmentedControl) {
        debugButton.isHidden = true
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

// MARK: - GADBannerViewDelegate delegate

extension BannerInViewViewController : GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerAdContainer.isHidden = false
        activityIndicator.stopAnimating()
        debugButton.isHidden = false
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        activityIndicator.stopAnimating()
        debugButton.isHidden = false
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        eventPageSheet?.adMobEvents.append(Event(name: "Impression"))
    }
    
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        eventPageSheet?.adMobEvents.append(Event(name: "Click"))
    }
}
