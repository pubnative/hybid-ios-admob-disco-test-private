import UIKit
import GoogleMobileAds

class BannerScrollViewController: BaseAdViewController {
        
    @IBOutlet weak var debugButton: UIButton!
    @IBOutlet weak var bannerScrollVew: UIScrollView!
    @IBOutlet weak var mrectTypeSegmented: UISegmentedControl!
    
    lazy var quotes = getQuotes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewTitle(adScenario: "Scroll view")
        prepareElements()
        mrectTypeSegmented.isHidden = BaseAdViewController.shared.adType == .MRectVideo || BaseAdViewController.shared.adType == .MRectHTML ? false : true
    }
    
    func prepareElements(){
        let cardHeight = 160.0
        var currentYPosition = 0.0
        let standarSpace = 8.0
        var cards: [Card] = []
        
        bannerScrollVew.subviews.forEach({ $0.removeFromSuperview()})
        
        for iCont in 0..<quotes.count {
            if iCont == Int(quotes.count / 2) {
                createAd(type: BaseAdViewController.shared.adType, delegate: self, adContainer: bannerScrollVew)
                
                adView.translatesAutoresizingMaskIntoConstraints = false
                adView.centerXAnchor.constraint(equalTo: bannerScrollVew.centerXAnchor).isActive = true
                let previousElement = iCont == 0 ? bannerScrollVew.topAnchor : cards[iCont-1].bottomAnchor
                adView.topAnchor.constraint(equalTo: previousElement, constant: standarSpace).isActive = true
                adView.widthAnchor.constraint(equalToConstant: adView.frame.width).isActive = true
                adView.heightAnchor.constraint(equalToConstant: adView.frame.height).isActive = true
                
                currentYPosition += (adView.frame.height + standarSpace)
            }
            
            let card = Card(frame: CGRect(x: 0, y: 0, width: bannerScrollVew.frame.width, height: cardHeight))
            card.quote = quotes[iCont]
            
            bannerScrollVew.addSubview(card)
            cards.append(card)

            card.translatesAutoresizingMaskIntoConstraints = false
            card.centerXAnchor.constraint(equalTo: bannerScrollVew.centerXAnchor).isActive = true
            let previousElement = iCont == 0 ? bannerScrollVew.topAnchor : (Int(quotes.count / 2) == iCont ? adView.bottomAnchor : cards[iCont-1].bottomAnchor)
            card.topAnchor.constraint(equalTo: previousElement, constant: standarSpace).isActive = true
            card.widthAnchor.constraint(equalTo: bannerScrollVew.widthAnchor).isActive = true
            card.heightAnchor.constraint(equalToConstant: cardHeight).isActive = true
            
            currentYPosition += (card.frame.height + standarSpace)
        }
        
        bannerScrollVew.contentSize = CGSize(width: bannerScrollVew.frame.width, height: currentYPosition)
        debugButton.isHidden = true
    }
        
    @IBAction func loadBanner(_ sender: Any) {
        prepareElements()
        adView.load(GADRequest())
        debugButton.isHidden = true
    }
    
    @IBAction func choosingMRectType(_ sender: UISegmentedControl) {
        debugButton.isHidden = true
        if sender.selectedSegmentIndex == 0 {
            BaseAdViewController.shared.adType = .MRectVideo
        } else {
            BaseAdViewController.shared.adType = .MRectHTML
        }
        prepareElements()
    }
    
    @IBAction func showDebugView(_ sender: Any) {
        self.showDebugPageSheet()
    }
}

// MARK: - GADBannerViewDelegate delegate

extension BannerScrollViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        debugButton.isHidden = false
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
