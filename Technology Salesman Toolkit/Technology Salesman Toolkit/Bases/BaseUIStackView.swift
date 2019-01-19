//
//  BaseUIStackView.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 19/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation
import UIKit

// https://stackoverflow.com/questions/32551890/how-to-add-leading-padding-to-view-added-inside-an-uistackview
@IBDesignable
class BaseUIStackView: UIStackView {
    @IBInspectable private var color: UIColor?
    override var backgroundColor: UIColor? {
        get { return color }
        set {
            color = newValue
            self.setNeedsLayout()
        }
    }
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = self.backgroundColor?.cgColor
    }
}
