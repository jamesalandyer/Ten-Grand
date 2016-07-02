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

    //Outlets
    @IBOutlet var accountNameLabel: WKInterfaceLabel!
    @IBOutlet var accountAmountLabel: WKInterfaceLabel!
    @IBOutlet var timerButton: WKInterfaceButton!
    @IBOutlet var timerLabel: WKInterfaceLabel!
    @IBOutlet var saveButton: WKInterfaceButton!
    @IBOutlet var clearButton: WKInterfaceButton!
    @IBOutlet var reachableLabel: WKInterfaceLabel!
    
    //Properties
    private var account: Account? {
        didSet {
            updateScreen()
        }
    }
    
    private var timer: NSTimer!
    private var startDate: NSDate!
    private var elapsedTime: NSTimeInterval!
    private var stoppedDate: NSDate!
    private var totalStoppageTime: NSTimeInterval = 0
    
    //MARK: - Stack
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        enableButtons(false)
        
        if let account = context as? Account {
            self.account = account
        }
    }

    override func willActivate() {
        super.willActivate()
        
        accountSetUp()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateAccount), name: "UpdateCurrentAccount", object: nil)
    }

    override func didDeactivate() {
        super.didDeactivate()
        
        if timer != nil {
            if timer.valid {
                timer.invalidate()
            }
            
            timer = nil
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - Actions
    
    @IBAction func timerButtonPressed() {
        if let account = account {
            
            if startDate == nil { //No timer is in memory
                startDate = NSDate()
                account.startDate = startDate
                startTimer()
            } else if stoppedDate != nil { // The user restarts the timer
                setStoppageTime(nil)
                startTimer()
            } else { //The user stops the timer
                timer.invalidate()
                setStopDate(nil)
                enableButtons(true)
            }
            
            //Send the updated account to the iphone
            SharingService.sharedInstance.sendMessage(createAccountData(account), completionHandler: nil)
            
        }
    }
    
    @IBAction func saveButtonPressed() {
        //Converted Time
        let amount = floor(elapsedTime) / 10000
        
        //Create deposit
        let deposit = ["amount": amount, "date": NSDate(), "ID": account!.accountID]
        let accountTime = account!.time
        account!.time = accountTime + elapsedTime
        let accountBalance = account!.balance
        account!.balance = accountBalance + amount
        
        resetTimer()
        
        let accountData = createAccountData(account!)
        let sendData = ["account": accountData["account"]!, "deposit": deposit]
        
        //Send the updated account and deposit to the iphone
        SharingService.sharedInstance.sendMessage(sendData, completionHandler: nil)
        
        updateScreen()
    }
    
    @IBAction func clearButtonPressed() {
        resetTimer()
        
        //Send the updated account to the iphone
        SharingService.sharedInstance.sendMessage(createAccountData(account!), completionHandler: nil)
    }
    
    //MARK: - Adjusting UI
    
    /*
     Enables or diables the buttons and makes sure that the phone can be reached.
     
     - Parameter enable: A Bool of whether to enable the buttons.
     */
    private func enableButtons(enable: Bool) {
        if SharingService.sharedInstance.phoneReachable {
            reachableLabel.setHidden(true)
            saveButton.setHidden(false)
            clearButton.setHidden(false)
            saveButton.setEnabled(enable)
            clearButton.setEnabled(enable)
        } else {
            saveButton.setHidden(true)
            saveButton.setHidden(true)
            reachableLabel.setHidden(false)
        }
    }
    
    /*
     Updates the screen to show the current data.
     */
    func updateScreen() {
        if let account = account {
            accountNameLabel.setText(account.name)
            accountAmountLabel.setText(formatMoneyIntoString(account.balance))
        }
    }
    
    //MARK: - Timer
    
    /*
     Starts the timer.
     */
    func startTimer() {
        enableButtons(false)
        
        if timer != nil {
            if timer.valid {
                timer.invalidate()
            }
            
            timer = nil
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    /*
     Sets the date that the user stopped the timer.
     
     - Parameter currentDate: (Optional) Sets the stop date, if nil it creates a current date.
     */
    func setStopDate(currentDate: NSDate?) {
        stoppedDate = currentDate ?? NSDate()
        account!.stoppedDate = stoppedDate
    }
    
    /*
     Sets the amount of time from the time the user hit stop to the current time.
     
     - Parameter currentDate: (Optional) Sets the stop date, if nil it creates a current date.
     */
    func setStoppageTime(currentDate: NSDate?) {
        let currentTime = currentDate ?? NSDate()
        totalStoppageTime += currentTime.timeIntervalSinceDate(stoppedDate)
        account!.stoppageTime = totalStoppageTime
        stoppedDate = nil
        account!.stoppedDate = nil
    }
    
    /*
     Calculates the current time from the start date minus the time that the timer was stopped and updates the timer label to show it.
     */
    func updateTime() {
        var convertedTime: Double = 0
        
        if startDate != nil {
            let currentTime = NSDate()
            elapsedTime = currentTime.timeIntervalSinceDate(startDate) - totalStoppageTime
            convertedTime = floor(elapsedTime) / 10000
        } else {
            enableButtons(false)
        }
        
        let formattedString = formatTimeIntoLongCurrency(convertedTime)
        timerLabel.setText("$ \(formattedString)")
    }
    
    /*
     Resets the timer and all the items associated with the timer.
     */
    func resetTimer() {
        timerLabel.setText("$ 00,000.0000")
        enableButtons(false)
        timer = nil
        startDate = nil
        stoppedDate = nil
        totalStoppageTime = 0
        elapsedTime  = nil
        account!.startDate = nil
        account!.stoppedDate = nil
        account!.stoppageTime = nil
    }
    
    //MARK: - Account
    
    /*
     Sets up the data to show the account.
     */
    func accountSetUp() {
        if account != nil {
            startDate = nil
            stoppedDate = nil
            totalStoppageTime = 0
            
            if let start = account!.startDate {
                startDate = start
            }
            
            if let stop = account!.stoppedDate {
                stoppedDate = stop
            }
            
            if let stoppage = account!.stoppageTime {
                totalStoppageTime = stoppage
            }
            
            //The user has a timer in memory, but it is stopped
            if startDate != nil && stoppedDate != nil {
                if timer != nil {
                    timer.invalidate()
                }
                let currentTime = NSDate()
                //Set the timer to show the time minus the time when it was paused
                setStoppageTime(currentTime)
                //Then reset the stop date since the timer is still stopped
                setStopDate(currentTime)
                updateTime()
                enableButtons(true)
            } else if startDate != nil {
                //The user has a timer in memory, start it
                startTimer()
            } else {
                updateTime()
            }
        }
    }
    
    /*
     Updates the current account when new data is recieved from the phone.
     
     - Parameter notif: (Optional) The NSNotification being passed in.
     */
    func updateAccount(notif: NSNotification) {
        if let accountData = notif.object as? [String: AnyObject] {
            if let accountID = accountData["ID"] as? String {
                if let account = account {
                    //Make sure that the new data is for the current account
                    if accountID == account.accountID {
                        performUIUpdatesOnMain {
                            self.resetAccountData(accountData)
                            self.accountSetUp()
                            self.updateScreen()
                        }
                    }
                }
            }
        }
    }
    
    /*
     Resets the account with new data.
     
     - Parameter accountData: The dictionary of the new account data.
     */
    private func resetAccountData(accountData: [String: AnyObject]) {
        //Updates the displaying account with new data
        if let account = account {
            let balance = accountData["balance"] as! Double
            let time = accountData["time"] as! Double
            let startDate = accountData["startDate"] as? NSDate ?? nil
            let stoppedDate = accountData["stoppedDate"] as? NSDate ?? nil
            let stoppageTime = accountData["stoppageTime"] as? Double ?? 0
            
            account.balance = balance
            account.time = time
            account.startDate = startDate
            account.stoppedDate = stoppedDate
            account.stoppageTime = stoppageTime
        }
    }
    
    /*
     Creates a dictionary of account data.
     
     - Parameter account: The account to create a dictionary from.
     
     - Returns: A dictionary of the data from the account.
     */
    private func createAccountData(account: Account) -> [String: AnyObject] {
        var accountData = [String: AnyObject]()
        accountData["ID"] = account.accountID
        accountData["name"] = account.name
        accountData["balance"] = account.balance
        accountData["time"] = account.time
        accountData["startDate"] = account.startDate
        accountData["stoppedDate"] = account.stoppedDate
        accountData["stoppageTime"] = account.stoppageTime
        let packageData = ["account": accountData]
        
        return packageData
    }

}
