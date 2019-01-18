//
//  BaseUIView.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 17/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation
import UIKit

// https://stackoverflow.com/questions/28854469/change-uibutton-bordercolor-in-storyboard
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
