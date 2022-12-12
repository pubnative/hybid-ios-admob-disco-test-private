import UIKit
import HyBid
import GoogleMobileAds

class Interstitial: UIViewController {
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showAdButton: UIButton!
    @IBOutlet weak var debugButton: UIButton!
        
    private var interstitialAd: GADInterstitialAd?

    let adUnitID = "ca-app-pub-8741261465579918/1815008264"

     
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
    
    @IBAction func loadAdTouchUpInside(_ sender: UIButton) {
        activityIndicator.startAnimating()
        showAdButton.isHidden = true
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID,
                               request: request,
                               completionHandler: { [self] ad, error in
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                interstitialAd = ad
                                interstitialAd?.fullScreenContentDelegate = self
                                showAdButton.isHidden = false
                                debugButton.isHidden = false
                                activityIndicator.stopAnimating()
                        }
        )
    }
                               
    
    @IBAction func showAdTouchUpInside(_ sender: UIButton) {
        if interstitialAd != nil  {
            interstitialAd?.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    @IBAction func choosingInterstitialType(_ sender: UISegmentedControl) {
        debugButton.isHidden = true
        showAdButton.isHidden = true
    }
    
    @IBAction func showDebugView(_ sender: Any) {
        self.showDebugPageSheet()
    }
}

// MARK: - GADFullScreenContentDelegate delegate

extension Interstitial : GADFullScreenContentDelegate {
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        activityIndicator.stopAnimating()
        showAdButton.isHidden = false
        debugButton.isHidden = false
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        activityIndicator.stopAnimating()
        debugButton.isHidden = false
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        showAdButton.isHidden = true
        debugButton.isHidden = false
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        showDebugPageSheet()
        eventPageSheet?.adMobEvents.append(Event(name: "Impression"))
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        showDebugPageSheet()
        eventPageSheet?.adMobEvents.append(Event(name: "Click"))
    }
}

extension Interstitial: HyBidReportingDelegate {
    func onEvent(with event: HyBidReportingEvent) {
        eventPageSheet?.hyBidEvents.append(Event(name: event.eventType))
    }
}

extension Interstitial {
    
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
