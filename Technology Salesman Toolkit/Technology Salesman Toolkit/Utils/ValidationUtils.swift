import Foundation
import UIKit

/// Utilities used by functions related to the validation of forms.
struct ValidationUtils {
    
    /**
     Checking whether the provided email address is a valid email address or not.
     SOURCE: https://stackoverflow.com/a/25471164
     
     - Parameter email: Email address that needs to be validated.
     
     - Returns: Indication whether the provided email address is valid or not.
     */
    static func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    /**
     Checking whether all provided form fields have a value or not.
     
     - Parameter fields: Form fields that need to be validated.
     
     - Returns: Indication whether all provided form fields have a value or not.
     */
    static func everyFieldHasValue(_ fields: [String]) -> Bool {
        if fields.isEmpty || fields.contains("") {
            return false
        } else {
            return true
        }
    }
    
}
