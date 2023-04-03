import UIKit

class ProverbDetailViewController: UIViewController {
    var proverb: Proverb!
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var subMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        message.text = proverb.message
        subMessage.text = "\(proverb.movie), \(proverb.character), \(proverb.year)"
        subMessage.textColor = .secondaryLabel
    }
}
