import UIKit

class Card: UIView {
    
    @IBOutlet weak var quoteTextLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
  
    var quote: Quote = Quote(quoteText: "", quoteAuthor: "") {
        didSet{
            quoteTextLabel.text = quote.quoteText
            authorLabel.text = quote.quoteAuthor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("Card", owner: self)![0] as! UIView
        viewFromXib.frame = self.bounds
        viewFromXib.layer.cornerRadius = 10
        viewFromXib.clipsToBounds = true
        addSubview(viewFromXib)
    }

}
