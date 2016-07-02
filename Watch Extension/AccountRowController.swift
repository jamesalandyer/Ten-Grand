//
//  AccountRowController.swift
//  Ten Grand
//
//  Created by James Dyer on 6/30/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import WatchKit

class AccountRowController: NSObject {

    @IBOutlet var accountNameLabel: WKInterfaceLabel!
    @IBOutlet var accountAmountLabel: WKInterfaceLabel!
    @IBOutlet var stateLabel: WKInterfaceLabel!
    
    var account: Account? {
        didSet {
            if let account = account {
                accountNameLabel.setText(account.name)
                accountAmountLabel.setText(formatMoneyIntoString(account.balance))
                if account.startDate != nil && account.stoppedDate == nil {
                    stateLabel.setText("Active")
                    stateLabel.setTextColor(UIColor.greenColor())
                } else if account.startDate != nil && account.stoppedDate != nil {
                    stateLabel.setText("Stopped")
                    stateLabel.setTextColor(UIColor.redColor())
                } else {
                    stateLabel.setText("Inactive")
                    stateLabel.setTextColor(UIColor.grayColor())
                }
            }
        }
    }
    
}
