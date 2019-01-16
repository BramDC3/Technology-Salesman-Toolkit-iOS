//
//  StringUtils.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 12/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    static func formatInstructionsList(withContent content: List<String>) -> String {
        var string = ""
        for (index, instruction) in content.enumerated() {
            string += "\(index + 1). \(instruction)\n\n"
            
        }
        return string
    }
    
    static func formatPrice(price: Double) -> String {
        return String(format: "€ %.2f", price)
    }
    
}
