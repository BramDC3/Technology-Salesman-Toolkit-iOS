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
    
}
