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

//MARK: - Formatting

/*
 Formats a number into currency.
 
 - Parameter number: The number to convert.
 
 - Returns: A String of the converted number.
 */
func formatMoneyIntoString(number: Double) -> String {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
    let formattedString = numberFormatter.stringFromNumber(number)!
    
    return formattedString
}

/*
 Formats a number into a custom currency format.
 
 - Parameter number: The number to convert.
 
 - Returns: A String of the converted number.
 */
func formatTimeIntoLongCurrency(number: Double) -> String {
    let formatter = NSNumberFormatter()
    formatter.minimumFractionDigits = 4
    formatter.positiveFormat = "00,000.0000"
    let formattedString = formatter.stringFromNumber(number)!
    
    return formattedString
}

/*
 Formats a date into a custom date format.
 
 - Parameter date: The Date to convert.
 
 - Returns: A String of the converted date.
 */
func formatDateToMMddyy(date: NSDate) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MM/dd/yy"
    let dateString = formatter.stringFromDate(date)
    
    return dateString
}

//MARK: - Strings

/*
 Checks if the string is empty.
 
 - Parameter testStr: The string to tes.
 
 - Returns: A Bool of whether it is empty.
 */
func isEmptyOrContainsOnlySpaces(testStr: String) -> Bool {
    let set = NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet
    let range = testStr.rangeOfCharacterFromSet(set)
    return (range == nil)
}

//MARK: - Grand Central Dispatch

//Switches to the main queue
func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}