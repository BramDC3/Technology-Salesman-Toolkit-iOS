//
//  FirebaseUtils.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 07/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import Foundation

struct FirebaseUtils {
    
    static func convertIntToCategory(int: Int) -> Category {
        switch int {
            case 0: return Category.Windows
            case 1: return Category.Android
            case 2: return Category.Apple
            default: return Category.Other
        }
    }
    
}
