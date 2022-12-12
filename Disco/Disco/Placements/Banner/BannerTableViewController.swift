import UIKit
import GoogleMobileAds

protocol SetBannerState {
    func setState(state: BannerState)
    func setBanner(banner: GADBannerView)
}

class BannerTableViewController: BaseAdViewController {
        
    @IBOutlet weak var debugButton: UIButton!
    @IBOutlet weak var bannerTableView: UITableView!
    @IBOutlet weak var mrectTypeSegmented: UISegmentedControl!
        
    lazy var quotes = getQuotes()
    var bannerDelegate: SetBannerState?
    var bannerState: BannerState = .initialized {
        didSet{
            switch(bannerState){
            case .initialized:
                bannerDelegate?.setState(state: bannerState)
                debugButton.isHidden = true
            case .loading:
                bannerDelegate?.setState(state: bannerState)
                debugButton.isHidden = true
            case .loaded:
                bannerDelegate?.setState(state: bannerState)
                debugButton.isHidden = false
            case .failed:
                bannerDelegate?.setState(state: bannerState)
                debugButton.isHidden = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewTitle(adScenario: "Table view")
        bannerTableView.register(UINib(nibName: "QuoteTableViewCell", bundle: nil), forCellReuseIdentifier: "quoteCell")
        prepareBanner()
        mrectTypeSegmented.isHidden = BaseAdViewController.shared.adType == .MRectVideo || BaseAdViewController.shared.adType == .MRectHTML ? false : true
    }
    
    func prepareBanner(){
        createAd(type: BaseAdViewController.shared.adType, delegate: self)
        bannerDelegate?.setBanner(banner: adView)
        bannerState = .initialized
    }
    
    @IBAction func loadBanner(_ sender: Any) {
        prepareBanner()
        adView.load(GADRequest())
        bannerState = .loading
    }
    
    @IBAction func choosingMRectType(_ sender: UISegmentedControl) {
        debugButton.isHidden = true
        if sender.selectedSegmentIndex == 0 {
            BaseAdViewController.shared.adType = .MRectVideo
        } else {
            BaseAdViewController.shared.adType = .MRectHTML
        }
        prepareBanner()
    }
    
    @IBAction func showDebugView(_ sender: Any) {
        self.showDebugPageSheet()
    }
}

// MARK: - GADBannerViewDelegate delegate

extension BannerTableViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerState = .loaded
    }
        
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        bannerState = .failed
    }
        
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        eventPageSheet?.adMobEvents.append(Event(name: "Impression"))
    }
        
    func bannerViewDidRecordClick(_ bannerView: GADBannerView) {
        eventPageSheet?.adMobEvents.append(Event(name: "Click"))
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension BannerTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let quoteCell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") as? QuoteTableViewCell else {
            return UITableViewCell()
        }
        guard let bannerCell = tableView.dequeueReusableCell(withIdentifier: "bannerCell") as? BannerTableViewCell else {
            return UITableViewCell()
        }
        
        let quote = quotes[indexPath.row]
        if indexPath.row == quotes.count-1 {
            bannerDelegate = bannerCell
            bannerDelegate?.setBanner(banner: adView)
            bannerDelegate?.setState(state: bannerState)
            return bannerCell
        } else {
            quoteCell.quoteText.text = quote.quoteText
            quoteCell.quoteAuthor.text = quote.quoteAuthor
            return quoteCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == quotes.count-1 {
            return (adView?.frame.height ?? -40) + 40
        } else {
            return 100
        }
    }
}

