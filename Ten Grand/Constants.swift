//
//  Constants.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

//Colors
let greenColor = UIColor(red: 142.0 / 255.0, green: 218.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)
let redColor = UIColor(red: 255.0 / 255.0, green: 45.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)

//Formatting
func formatMoneyIntoString(number: Double) -> String {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
    
    return numberFormatter.stringFromNumber(number)!
}

func isEmptyOrContainsOnlySpaces(testStr: String) -> Bool {
    let set = NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet
    let range = testStr.rangeOfCharacterFromSet(set)
    return (range == nil)
}