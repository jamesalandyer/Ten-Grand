//
//  Constants.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import Foundation

func formatMoneyIntoString(number: Double) -> String {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
    
    return numberFormatter.stringFromNumber(number)!
}