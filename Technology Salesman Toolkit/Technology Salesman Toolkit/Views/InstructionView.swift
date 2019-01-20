import UIKit

/// Page representing an instruction for the 'ViewPager' of the ServiceDetailView.
/// SOURCE: https://medium.com/@anitaa_1990/create-a-horizontal-paging-uiscrollview-with-uipagecontrol-swift-4-xcode-9-a3dddc845e92
class InstructionView: UIView {

    /// Image of the instruction.
    @IBOutlet weak var imageView: UIImageView!
    
    /// Title of the instruction.
    @IBOutlet weak var titleLabel: UILabel!
    
    /// Description of the instruction.
    @IBOutlet weak var descriptionLabel: UILabel!
    
    /// List of steps of the instruction.
    @IBOutlet weak var contentLabel: UILabel!
    
}
