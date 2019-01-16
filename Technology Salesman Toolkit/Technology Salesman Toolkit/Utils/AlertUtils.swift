//
//  AlertUtils.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 07/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import UIKit
import Foundation

struct AlertUtils {
    
    // Function for displaying alerts with the given message
    static func createSimpleAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.alertOk, style: .default, handler: nil))
        return alert
    }
    
    static func createFunctionalAlert(withTitle title: String, andMessage message: String, andFunction function: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringConstants.alertNo, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: StringConstants.alertYes, style: .default, handler: { (action) in
            function()
        }))
        return alert
    }
    
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
    
}
