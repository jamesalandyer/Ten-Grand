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
    let formattedString = numberFormatter.stringFromNumber(number)!
    
    return formattedString
}

func formatTimeIntoLongCurrency(number: Double) -> String {
    let formatter = NSNumberFormatter()
    formatter.minimumFractionDigits = 4
    formatter.positiveFormat = "00,000.0000"
    let formattedString = formatter.stringFromNumber(number)!
    
    return formattedString
}

func formatDateToMMddyy(date: NSDate) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MM/dd/yy"
    let dateString = formatter.stringFromDate(date)
    
    return dateString
}

func isEmptyOrContainsOnlySpaces(testStr: String) -> Bool {
    let set = NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet
    let range = testStr.rangeOfCharacterFromSet(set)
    return (range == nil)
}

//Switches to the main queue
func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}