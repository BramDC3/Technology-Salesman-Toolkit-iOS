//
//  WebsiteUtils.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 19/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation
import UIKit

struct WebsiteUtils {
    
    static func openWebsite(withLink link: String) {
        if let link = URL(string: link) {
            UIApplication.shared.open(link)
        }
    }
    
}
