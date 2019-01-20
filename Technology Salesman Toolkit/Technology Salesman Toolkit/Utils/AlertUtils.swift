import UIKit
import Foundation

/// Utilities used by functions related to alerts.
struct AlertUtils {
    
    /**
     Creates an alert with a single action.
     
     - Parameters:
        - title: Title of the alert.
        - message: Message of the alert.
     
     - Returns: A simple alert.
    */
    static func createSimpleAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.alertOk, style: .default, handler: nil))
        return alert
    }
    
    /**
     Creates an alert with two actions and a function for the positive action.
     
     - Parameters:
        - title: Title of the alert.
        - message: Message of the alert.
        - function: Function of the positive action.
     
     - Returns: An alert with a function.
     */
    static func createFunctionalAlert(withTitle title: String, andMessage message: String, andFunction function: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.alertNo, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.alertYes, style: .default, handler: { (action) in
            function()
        }))
        return alert
    }
    
    /**
     Creates an alert with two actions, a function for the positive action and a textfield.
     It is used to display an alert for posting a suggestion
     
     - Parameters:
        - title: Title of the alert.
        - message: Message of the alert.
        - function: Function of the positive action.
     
     - Returns: An alert with a function and a textfield.
     */
    static func createSendSuggestionAlert(withTitle title: String, andMessage message: String, andFunction function: @escaping (String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = StringConstants.placeholderSendSuggestionTextfield
        }
        alert.addAction(UIAlertAction(title: StringConstants.alertCancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.alertSend, style: .default, handler: { (action) in
            function(alert.textFields![0].text!)
        }))
        return alert
    }
    
    /**
     Creates an alert with three actions and a function for the positive action and the third action.
     It is used to display an alert when creating an account with an extra button for the privacy policy.
     
     - Parameters:
        - title: Title of the alert.
        - message: Message of the alert.
        - function: Function of the positive action.
     
     - Returns: An alert with two functions.
     */
    static func createPrivacyPolicyAlert(withTitle title: String, andMessage message: String, andFunction function: @escaping () -> Void) -> UIAlertController {
        let alert = createFunctionalAlert(withTitle: title, andMessage: message, andFunction: function)
        alert.addAction(UIAlertAction(title: StringConstants.alertPrivacyPolicy, style: .default, handler: { (action) in
            WebsiteUtils.openWebsite(withLink: StringConstants.privacyPolicy)
        }))
        return alert
    }
    
}
