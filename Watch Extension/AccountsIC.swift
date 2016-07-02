//
//  AccountsIC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/30/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class AccountsIC: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var accountsTable: WKInterfaceTable!
    
    var accounts = [Account]()
    var accountSort: [Account] {
        return accounts.sort { $0.name < $1.name }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        SharingService.sharedInstance.sendMessage(["bank": "initialData"]) { (response, error) in
            
            guard error == nil else {
                print(error)
                return
            }
            
            guard let response = response else {
                print("No Data")
                return
            }
            
            if let accountsData = response["accounts"] as? [[String: AnyObject]] {
                self.parseAccountData(accountsData)
            }
            
        }
        
    }
    
    override func didAppear() {
        super.didAppear()
        
        updateTable()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let account = accountSort[rowIndex]
        let controller = "Timer"
        pushControllerWithName(controller, context: account)
    }
    
    private func updateTable() {
        self.accountsTable.setNumberOfRows(self.accountSort.count, withRowType: "AccountRow")
            
        for index in 0..<self.accountsTable.numberOfRows {
            if let controller = self.accountsTable.rowControllerAtIndex(index) as? AccountRowController {
                controller.account = self.accountSort[index]
            }
        }
    }
    
    private func parseAccountData(data: [[String: AnyObject]]) {
        accounts = [Account]()
        
        for account in data {
            let accountID = account["ID"] as! String
            let accountName = account["name"] as! String
            let accountBalance = account["balance"] as! Double
            let accountTime = account["time"] as! Double
            let accountStartDate = account["startDate"] as? NSDate ?? nil
            let accountStoppedDate = account["stoppedDate"] as? NSDate ?? nil
            let accountStoppageTime = account["stoppageTime"] as? Double ?? nil
            let newAccount = Account(accountID: accountID, name: accountName, balance: accountBalance, time: accountTime, startDate: accountStartDate, stoppedDate: accountStoppedDate, stoppageTime: accountStoppageTime)
            self.accounts.append(newAccount)
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.updateTable()
        })
    }

}
