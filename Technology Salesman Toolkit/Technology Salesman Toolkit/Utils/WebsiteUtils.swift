import Foundation
import UIKit

struct WebsiteUtils {
    
    static func openWebsite(withLink link: String) {
        if let link = URL(string: link) {
            UIApplication.shared.open(link)
        }
    }
    
}
