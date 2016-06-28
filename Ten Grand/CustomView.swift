//
//  CustomView.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setUpView()
    }
    
    func setUpView() {
        layer.cornerRadius = 10.0
    }

}
