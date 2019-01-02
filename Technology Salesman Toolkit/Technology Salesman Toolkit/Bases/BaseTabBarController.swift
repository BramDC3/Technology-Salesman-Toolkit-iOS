//
//  BaseTabBarController.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 02/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = defaultIndex
    }
    
}
