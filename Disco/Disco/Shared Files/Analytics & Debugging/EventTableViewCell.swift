import UIKit

class EventTableViewCell: UITableViewCell {
        
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var event: Event? {
        didSet {
            guard let event = event else { return }
            nameLabel.text = event.name
            timeStampLabel.text = event.getTimeString()
        }
    }
    override func didMoveToSuperview() {
        selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
