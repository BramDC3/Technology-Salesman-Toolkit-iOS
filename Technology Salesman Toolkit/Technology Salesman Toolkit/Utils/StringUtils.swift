//
//  StringUtils.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 12/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation

struct StringUtils {
    
    static func getFirstname(fullname: String?) -> String {
        if let fullname = fullname, let index = fullname.firstIndex(of: " ") {
            let firstname = String(fullname[..<index])
            return firstname
        }
        return ""
    }
    
    static func getLastname(fullname: String?) -> String {
        if let fullname = fullname, let index = fullname.firstIndex(of: " ") {
            let lastname = String(fullname[index...]).trimmingCharacters(in: .whitespaces)
            return lastname
        }
        return ""
    }
    
}
