import UIKit
import GoogleMobileAds
import HyBid

class Native: UIViewController {
        
    @IBOutlet weak var nativeAdContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var debugButton: UIButton!
        
    var nativeAdLoader: GADAdLoader!
    var nativeAdView: GADNativeAdView?
    let adUnitID = "ca-app-pub-8741261465579918/8160924764"
    
    var eventPageSheet: EventsDetailsViewController?
    var pageSheetNavigationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugButton.isHidden = true
        HyBidReportingManager.sharedInstance.delegate = self
        
        prepareDebugPageSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addFlexDebugRightButton()
    }
            
    @IBAction func loadAd() {
        nativeAdContainer.isHidden = true
        activityIndicator.startAnimating()
        debugButton.isHidden = true
        
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        nativeAdLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: self,
                                  adTypes: [.native],
                                  options: [multipleAdsOptions])
        nativeAdLoader.delegate = self
        nativeAdLoader.load(GADRequest())
    }
    
    @IBAction func showDebugView(_ sender: Any) {
        self.showDebugPageSheet()
    }
}


extension Native : GADNativeAdLoaderDelegate {
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        activityIndicator.stopAnimating()
        debugButton.isHidden = false
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        let nibView = Bundle.main.loadNibNamed("NativeView", owner: nil, options: nil)?.first
        guard let nativeAdView = nibView as? GADNativeAdView else {
            return
        }
        self.nativeAdView?.removeFromSuperview()
        self.nativeAdView = nativeAdView
        self.nativeAdView!.frame = nativeAdContainer.bounds
        nativeAd.delegate = self
        nativeAdContainer.addSubview(self.nativeAdView!)
        nativeAdContainer.isHidden = false
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        (nativeAdView.imageView as? UIImageView)?.image = nativeAd.images?.first?.image
        nativeAdView.imageView?.isHidden = nativeAd.images == nil
        nativeAdView.nativeAd = nativeAd
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        activityIndicator.stopAnimating()
        debugButton.isHidden = false
    }
    
    
}

extension Native: GADNativeAdDelegate {
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        activityIndicator.stopAnimating()
        eventPageSheet?.adMobEvents.append(Event(name: "Impression"))
        debugButton.isHidden = false
    }

    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        eventPageSheet?.adMobEvents.append(Event(name: "Click"))
    }
}

extension Native: HyBidReportingDelegate {
    func onEvent(with event: HyBidReportingEvent) {
        eventPageSheet?.hyBidEvents.append(Event(name: event.eventType))
    }
}

extension Native {
    
    func prepareDebugPageSheet(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "EventsDetails", bundle: nil)
        pageSheetNavigationController = storyBoard.instantiateViewController(withIdentifier: "EventsDetails") as! UINavigationController
        eventPageSheet = pageSheetNavigationController.viewControllers[0] as? EventsDetailsViewController
    }
    
    
    func showDebugPageSheet(){
        if #available(iOS 15.0, *) {
            if let sheet = pageSheetNavigationController.sheetPresentationController {
                sheet.detents = [.medium(), .medium()]
            }
        }
        if #available(iOS 13.0, *) {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                self.modalPresentationStyle = .fullScreen
                topController.present(pageSheetNavigationController, animated: true)
            }
        } else {
            self.present(pageSheetNavigationController, animated: true)
        }
    }
}


