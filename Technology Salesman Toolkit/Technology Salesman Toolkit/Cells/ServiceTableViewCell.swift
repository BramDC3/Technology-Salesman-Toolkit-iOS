import UIKit

/// Custom cell used in the ServiceTableView.
class ServiceTableViewCell: UITableViewCell {
    
    /// Image of the logo of a service.
    @IBOutlet weak var logoImageView: UIImageView!
    
    /// Title of a service.
    @IBOutlet weak var titleLabel: UILabel!
    
    /// Description of a service.
    @IBOutlet weak var descriptionLabel: UILabel!
    
    /// Category of a service.
    @IBOutlet weak var categoryLabel: UILabel!
    
    // Price of a service, only displayed if it isn't 0.
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
