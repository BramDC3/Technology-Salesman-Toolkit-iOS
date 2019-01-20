import UIKit

/// Used to select the default index of a TabBarController.
/// SOURCE: https://stackoverflow.com/a/30321467
@IBDesignable
class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }
    
}
