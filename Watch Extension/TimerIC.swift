//
//  TimerIC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/30/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import WatchKit
import Foundation


class TimerIC: WKInterfaceController {

    @IBOutlet var accountNameLabel: WKInterfaceLabel!
    @IBOutlet var accountAmountLabel: WKInterfaceLabel!
    @IBOutlet var timerButton: WKInterfaceButton!
    @IBOutlet var timerLabel: WKInterfaceLabel!
    @IBOutlet var saveButton: WKInterfaceButton!
    @IBOutlet var clearButton: WKInterfaceButton!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
