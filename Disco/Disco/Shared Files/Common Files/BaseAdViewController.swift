import UIKit
import HyBid
import GoogleMobileAds

enum PlacementType {
    case video
    case html
}

enum AdType {
    
    case Banner
    case MRectVideo
    case MRectHTML
    case Leaderboard
    
    func getAdFrame() -> CGRect {
        switch self {
        case .Banner:
            return CGRect(x: 0, y: 0, width: 320, height: 50)
        case .MRectVideo, .MRectHTML:
            return CGRect(x: 0, y: 0, width: 300, height: 250)
        case .Leaderboard:
            return CGRect(x: 0, y: 0, width: 728, height: 90)
        }
    }
    
    func getAdUnitID() -> String {
        switch self {
        case .Banner:
            return "ca-app-pub-8741261465579918/4075513559"
        case .MRectVideo:
            return ""
        case .MRectHTML:
            return "ca-app-pub-8741261465579918/6510105208"
        case .Leaderboard:
            return "ca-app-pub-8741261465579918/4943734481"
        }
    }
    
    func getAdSize() -> GADAdSize {
        switch self {
        case .Banner:
            return GADAdSizeBanner
        case .MRectVideo, .MRectHTML:
            return GADAdSizeMediumRectangle
        case .Leaderboard:
            return GADAdSizeLeaderboard
        }
    }
}

class BaseAdViewController: UIViewController {
        
    var adView: GADBannerView!
    var adType: AdType = .Banner
    static var shared = BaseAdViewController()
    var eventPageSheet: EventsDetailsViewController?
    var pageSheetNavigationController = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDebugPageSheet()
        HyBidReportingManager.sharedInstance.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addFlexDebugRightButton()
    }
    
    func setViewTitle(adScenario: String){
        switch BaseAdViewController.shared.adType {
        case .Banner:
            self.navigationItem.title = "\(adScenario) Banner"
        case .MRectVideo, .MRectHTML:
            self.navigationItem.title = "\(adScenario) MRect"
        case .Leaderboard:
            self.navigationItem.title = "\(adScenario) Leaderboard"
        }
    }
    
    func createAd(type: AdType, delegate: GADBannerViewDelegate, adContainer: UIView? = nil){
        
        adView = GADBannerView(adSize: type.getAdSize())
        adView.frame = type.getAdFrame()
        adView.delegate = delegate
        adView.backgroundColor = UIColor.clear
        adView.rootViewController = self
        adView.adUnitID = type.getAdUnitID()
        adView.tag = 123
        
        if adContainer != nil {
            let previousAds = adContainer!.subviews.filter { view in
                return view.tag == 123
            }
            
            previousAds.forEach({ $0.removeFromSuperview() })
            adContainer!.frame = adView.frame
            adContainer!.addSubview(adView)
        }
    }
    
    func setSizeConstraints(widthConstraint: NSLayoutConstraint, heightConstraint: NSLayoutConstraint){
        widthConstraint.constant = adView.frame.width
        heightConstraint.constant = adView.frame.height
    }
}

extension BaseAdViewController: HyBidReportingDelegate {
    func onEvent(with event: HyBidReportingEvent) {
        eventPageSheet?.hyBidEvents.append(Event(name: event.eventType))
    }
}

extension BaseAdViewController {
    func getQuotes() -> [Quote] {
        return [Quote(quoteText:"Our world is built on biology and once we begin to understand it, it then becomes a technology" ,quoteAuthor:"Ryan Bethencourt"),
                Quote(quoteText:"Happiness is not an ideal of reason but of imagination" ,quoteAuthor:"Immanuel Kant"),
                Quote(quoteText:"Science and technology revolutionize our lives, but memory, tradition and myth frame our response." ,quoteAuthor:"Arthur M. Schlesinger"),
                Quote(quoteText:"It's not a faith in technology. It's faith in people" ,quoteAuthor:"Steve Jobs"),
                Quote(quoteText:"We can't blame the technology when we make mistakes." ,quoteAuthor:"Tim Berners-Lee"),
                Quote(quoteText:"Life must be understood backward. But it must be lived forward." ,quoteAuthor:"Søren Kierkegaard"),
                Quote(quoteText:"Happiness can be found, even in the darkest of times, if one only remembers to turn on the light." ,quoteAuthor:"Albus Dumbledore"),
                Quote(quoteText:"To live a creative life, we must lose our fear of being wrong." ,quoteAuthor:"Joseph Chilton Pearce"),
                Quote(quoteText:"It is undesirable to believe a proposition when there is no ground whatever for supposing it true." ,quoteAuthor:"Bertrand Russell"),
                Quote(quoteText:"There's always a bigger fish." ,quoteAuthor:"Qui-Gon Jinn"),
                Quote(quoteText:"A wizard is never late. Nor is he early. He arrives precisely when he means to." ,quoteAuthor:"Gandalf"),
                Quote(quoteText:"Moonlight drowns out all but the brightest stars." ,quoteAuthor:"J. R. R. Tolkien, The Lord of the Rings"),
                Quote(quoteText:"A hunted man sometimes wearies of distrust and longs for friendship." ,quoteAuthor:"J. R. R. Tolkien, The Lord of the Rings")]
    }
}

extension BaseAdViewController {
    
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
