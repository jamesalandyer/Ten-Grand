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

    //Outlets
    @IBOutlet var accountsTable: WKInterfaceTable!
    @IBOutlet var noAccountDisplay: WKInterfaceGroup!
    
    //Properties
    private var accounts = [Account]()
    private var accountSort: [Account] {
        return accounts.sort { $0.name < $1.name }
    }
    
    //MARK: - Stack
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        retrieveData(nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dataRecieved), name: "UpdateAccounts", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(retrieveData), name: "UpdateCurrentAccount", object: nil)
    }
    
    override func didAppear() {
        super.didAppear()
        
        updateTable()
    }
    
    //MARK: - Actions
    
    @IBAction func refreshButtonPressed() {
        retrieveData(nil)
    }
    
    //MARK: - Table
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let account = accountSort[rowIndex]
        let controller = "Timer"
        pushControllerWithName(controller, context: account)
    }
    
    /*
     Updates the table view.
     */
    private func updateTable() {
        if self.accountSort.count > 0 {
            noAccountDisplay.setHidden(true)
            
            self.accountsTable.setNumberOfRows(self.accountSort.count, withRowType: "AccountRow")
            
            for index in 0..<self.accountsTable.numberOfRows {
                if let controller = self.accountsTable.rowControllerAtIndex(index) as? AccountRowController {
                    controller.account = self.accountSort[index]
                }
            }
        } else {
            noAccountDisplay.setHidden(false)
        }
    }
    
    /*
     Sends a message to the phone to get account data.
     
     - Parameter notif: (Optional) The NSNotification being passed in.
     */
    func retrieveData(notif: NSNotification?) {
        SharingService.sharedInstance.sendMessage(["bank": "retrieveData"]) { (response, error) in
            
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
    
    /*
     Recieves the data from the phone and handles it.
     
     - Parameter notif: (Optional) The NSNotification being passed in.
     */
    func dataRecieved(notif: NSNotification) {
        if let data = notif.object as? [[String: AnyObject]] {
            parseAccountData(data)
        }
    }
    
    /*
     Parses the data into Account objects.
     
     - Parameter data: The array of dictionaries to parse through.
     */
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
