//
//  ValidationUtils.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 07/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import Foundation
import UIKit

struct ValidationUtils {
    
    // Function that checks whether the provided email address is valid or not
    // https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    static func isEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func doesEveryFieldHaveValue(fields: [String]) -> Bool {
        if fields.contains("") {
            return false
        } else {
            return true
        }
    }
    
}
