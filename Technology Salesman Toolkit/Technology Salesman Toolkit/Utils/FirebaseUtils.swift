//
//  FirebaseUtils.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 07/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import Foundation

class FirebaseUtils {
    
    static func convertIntToCategory(withNumber number: Int) -> Category {
        switch number {
            case 0: return Category.Windows
            case 1: return Category.Android
            case 2: return Category.Apple
            default: return Category.Other
        }
    }
    
}
