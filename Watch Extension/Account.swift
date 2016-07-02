//
//  Account.swift
//  Ten Grand
//
//  Created by James Dyer on 7/1/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import WatchKit

class Account: NSObject {

    var accountID: String!
    var name: String!
    var balance: Double!
    var time: Double!
    var startDate: NSDate?
    var stoppedDate: NSDate?
    var stoppageTime: Double?
    
    init(accountID: String, name: String, balance: Double, time: Double, startDate: NSDate?, stoppedDate: NSDate?, stoppageTime: Double?) {
        self.accountID = accountID
        self.name = name
        self.balance = balance
        self.time = time
        self.startDate = startDate
        self.stoppedDate = stoppedDate
        self.stoppageTime = stoppageTime
    }
    
}
