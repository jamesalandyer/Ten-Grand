//
//  CustomButton.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setUpView()
    }
    
    private func setUpView() {
        layer.cornerRadius = 25.0
        layer.borderWidth = 4.0
    }

}
