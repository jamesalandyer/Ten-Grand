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
    
    var account: Account? {
        didSet {
            updateScreen()
        }
    }
    
    private var timer: NSTimer!
    private var startDate: NSDate!
    private var elapsedTime: NSTimeInterval!
    private var stoppedDate: NSDate!
    private var totalStoppageTime: NSTimeInterval = 0
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        enableButtons(false)
        
        if let account = context as? Account {
            self.account = account
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if account != nil {
            //The user has a timer in memory, but it is stopped
            if startDate != nil && stoppedDate != nil {
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
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        timer = nil
    }
    
    @IBAction func timerButtonPressed() {
        if let account = account {
            if timer == nil && startDate == nil { //No timer is in memory
                startDate = NSDate()
                account.startDate = startDate
                startTimer()
            } else if stoppedDate != nil { // The user restarts the timer
                setStoppageTime(nil)
                startTimer()
            } else { //The user stops the timer
                setStopDate(nil)
                timer.invalidate()
                enableButtons(true)
            }
            SharingService.sharedInstance.sendMessage(createAccountData(account), completionHandler: nil)
        }
    }
    
    @IBAction func saveButtonPressed() {
        let amount = floor(elapsedTime) / 10000
        
        let deposit = ["amount": amount, "date": NSDate(), "ID": account!.accountID]
        let accountTime = account!.time
        account!.time = accountTime + elapsedTime
        let accountBalance = account!.balance
        account!.balance = accountBalance + amount
        
        resetTimer()
        
        let accountData = createAccountData(account!)
        let sendData = ["account": accountData["account"]!, "deposit": deposit]
        
        SharingService.sharedInstance.sendMessage(sendData, completionHandler: nil)
        updateScreen()
    }
    
    @IBAction func clearButtonPressed() {
        resetTimer()
        SharingService.sharedInstance.sendMessage(createAccountData(account!), completionHandler: nil)
    }
    
    func enableButtons(enable: Bool) {
        saveButton.setEnabled(enable)
        clearButton.setEnabled(enable)
    }
    
    func startTimer() {
        enableButtons(false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func setStopDate(currentDate: NSDate?) {
        stoppedDate = currentDate ?? NSDate()
        account!.stoppedDate = stoppedDate
    }
    
    func setStoppageTime(currentDate: NSDate?) {
        let currentTime = currentDate ?? NSDate()
        totalStoppageTime += currentTime.timeIntervalSinceDate(stoppedDate)
        account!.stoppageTime = totalStoppageTime
        stoppedDate = nil
        account!.stoppedDate = nil
    }
    
    func updateTime() {
        let currentTime = NSDate()
        elapsedTime = currentTime.timeIntervalSinceDate(startDate) - totalStoppageTime
        let convertedTime = floor(elapsedTime) / 10000
        let formattedString = formatTimeIntoLongCurrency(convertedTime)
        timerLabel.setText("$ \(formattedString)")
    }
    
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
    
    func updateScreen() {
        if let account = account {
            accountNameLabel.setText(account.name)
            accountAmountLabel.setText(formatMoneyIntoString(account.balance))
            if let start = account.startDate {
                startDate = start
            }
            if let stop = account.stoppedDate {
                stoppedDate = stop
            }
            if let stoppage = account.stoppageTime {
                totalStoppageTime = stoppage
            }
        }
    }
    
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
