import UIKit
import HyBid

class AnalyticsDetailViewController: UIViewController {
        
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventTextView: UITextView!
        
    var event: HyBidReportingEvent? {
        didSet{
            guard let event = event else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.eventTypeLabel?.text = event.eventType
                self?.eventTextView?.text = event.toJSON()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addFlexDebugRightButton()
    }
}
