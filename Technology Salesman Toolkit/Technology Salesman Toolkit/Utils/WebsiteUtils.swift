import Foundation
import UIKit

/// Utilities used by functions that open a website.
struct WebsiteUtils {
    
    /**
     Opening a website with a given link.
     
     - Parameter link: Link to the website that needs to be opened.
     */
    static func openWebsite(withLink link: String) {
        if let link = URL(string: link) {
            UIApplication.shared.open(link)
        }
    }
    
}
