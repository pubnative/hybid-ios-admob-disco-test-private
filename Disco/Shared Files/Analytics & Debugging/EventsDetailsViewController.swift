import UIKit
import HyBid

struct Event {
    let name: String
    let timeStamp = Date()
    
    func getTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        return formatter.string(from: timeStamp)
    }
}

class EventsDetailsViewController: UIViewController {
        
    @IBOutlet weak var hybidEventsTableView: UITableView!
    @IBOutlet weak var admobTableView: UITableView!
    
    var selectedEvent: HyBidReportingEvent?
        
    var hyBidEvents = [Event]() {
        didSet{
            if hyBidEvents.count != 0 {
                DispatchQueue.main.async { [weak self] in
                    self?.hybidEventsTableView?.reloadData()
                }
            }
        }
    }
    
    var adMobEvents = [Event]() {
        didSet{
            if adMobEvents.count != 0 {
                DispatchQueue.main.async { [weak self] in
                    self?.admobTableView?.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hybidEventsTableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "eventCell")
        admobTableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "eventCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addFlexDebugRightButton()
    }

    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEventDetails" {
            if let analyticsDetailVC = segue.destination as? AnalyticsDetailViewController {
                analyticsDetailVC.event = selectedEvent
            }
        }
    }
}

extension EventsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableView == hybidEventsTableView ? "HyBid" : "AdMob"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == hybidEventsTableView ? hyBidEvents.count : adMobEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        if tableView == hybidEventsTableView {
            let event = hyBidEvents[indexPath.row]
            cell.nameLabel.text = event.name
            cell.timeStampLabel.text = event.getTimeString()
            
        } else {
            let event = adMobEvents[indexPath.row]
            cell.nameLabel.text = event.name
            cell.timeStampLabel.text = event.getTimeString()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == hybidEventsTableView {
            selectedEvent = HyBidReportingManager.sharedInstance.events[indexPath.row]
            self.performSegue(withIdentifier: "goToEventDetails", sender: nil)
        }
    }
}
