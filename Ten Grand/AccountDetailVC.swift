//
//  AccountDetailVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class AccountDetailVC: UIViewController {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    @IBOutlet weak var accountProgressWidth: NSLayoutConstraint!
    @IBOutlet weak var accountTimeLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: CustomButton!
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var cancelButton: CustomButton!
    
    var account: Account!
    
    var timer: NSTimer!
    var startDate: NSDate!
    var elapsedTime: NSTimeInterval!
    var stoppedDate: NSDate!
    var totalStoppageTime: NSTimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableActionButtons(false)
        let saveButtonSelectedImage = UIImage(named: "approve_button_selected.png")
        saveButton.setImage(saveButtonSelectedImage, forState: .Highlighted)
        let cancelButtonSelectedImage = UIImage(named: "cancel_button_selected.png")
        cancelButton.setImage(cancelButtonSelectedImage, forState: .Highlighted)

        //See if the user still has a timer in memory
        if let date = NSUserDefaults.standardUserDefaults().objectForKey("\(account.objectID)StartDate") {
            startDate = date as! NSDate
        }
        
        //See if the timer was stopped in memory
        if let stopDate = NSUserDefaults.standardUserDefaults().objectForKey("\(account.objectID)StoppedDate") {
            stoppedDate = stopDate as! NSDate
        }
        
        //See if the user has stopped the timer in memory at all
        if let stoppageTime = NSUserDefaults.standardUserDefaults().objectForKey("\(account.objectID)StoppageTime") {
            totalStoppageTime = stoppageTime as! NSTimeInterval
            
        }
        
        //The user has a timer in memory, but it is stopped
        if startDate != nil && stoppedDate != nil {
            let currentTime = NSDate()
            //Set the timer to show the time minus the time when it was paused
            setStoppageTime(currentTime)
            //Then reset the stop date since the timer is still stopped
            setStopDate(currentTime)
            updateTime()
            enableActionButtons(true)
        } else if startDate != nil {
            //The user has a timer in memory, start it
            startTimer()
        }
        
        establishNavigation()
        updateScreen()
    }
    
    @IBAction func timerButtonPressed(sender: AnyObject) {
        if timer == nil && startDate == nil { //No timer is in memory
            startDate = NSDate()
            NSUserDefaults.standardUserDefaults().setObject(startDate, forKey: "\(account.objectID)StartDate")
            startTimer()
        } else if stoppedDate != nil { // The user restarts the timer
            setStoppageTime(nil)
            startTimer()
        } else { //The user stops the timer
            setStopDate(nil)
            timer.invalidate()
            timerLabel.text = "TAP TIMER TO START"
            enableActionButtons(true)
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let amount = floor(elapsedTime) / 10000
        let deposit = Deposit(amount: amount, context: CoreDataStack.stack.context)
        deposit.account = account
        let accountTime = account.time as! Double
        account.time = accountTime + elapsedTime
        let accountBalance = account.balance as! Double
        account.balance = accountBalance + amount
        let bankNetWorth = account.bank!.netWorth as! Double
        account.bank!.netWorth = bankNetWorth + amount
        let bankCash = account.bank!.cash as! Double
        account.bank!.cash = bankCash + amount
        
        let notif = NSNotification(name: "Deposit", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notif)
        
        resetTimer()
        updateScreen()
        CoreDataStack.stack.save()
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        resetTimer()
    }
    
    func establishNavigation() {
        //Sets Navigation Image
        let logo = UIImage(named: "nav_logo.png")
        self.navigationItem.titleView = UIImageView(image: logo)
    }
    
    func updateScreen() {
        accountNameLabel.text = account.name!.uppercaseString
        
        let accountBalance = account.balance!.doubleValue
        accountBalanceLabel.text = formatMoneyIntoString(accountBalance)
        
        let progressWidth = ((self.view.frame.width - 16) / 10000) * CGFloat(accountBalance)
        accountProgressWidth.constant = progressWidth
        
        convertTimeString()
    }
    
    func convertTimeString() {
        let time = (account.time as! Double)
        let hours = Int(time / 3600)
        let minutes = Int((time % 3600) / 60)
        let seconds = Int((time % 3600) % 60)
        accountTimeLabel.text = "\(hours) HOUR(S), \(minutes) MINUTE(S), \(seconds) SECOND(S)"
    }
    
    func startTimer() {
        enableActionButtons(false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timerLabel.text = "TAP TIMER TO STOP"
    }
    
    func setStopDate(currentDate: NSDate?) {
        stoppedDate = currentDate ?? NSDate()
        NSUserDefaults.standardUserDefaults().setObject(stoppedDate, forKey: "\(account.objectID)StoppedDate")
    }
    
    func setStoppageTime(currentDate: NSDate?) {
        let currentTime = currentDate ?? NSDate()
        totalStoppageTime += currentTime.timeIntervalSinceDate(stoppedDate)
        NSUserDefaults.standardUserDefaults().setObject(totalStoppageTime, forKey: "\(account.objectID)StoppageTime")
        stoppedDate = nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey("\(account.objectID)StoppedDate")
    }
    
    func updateTime() {
        let currentTime = NSDate()
        elapsedTime = currentTime.timeIntervalSinceDate(startDate) - totalStoppageTime
        let convertedTime = floor(elapsedTime) / 10000
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 4
        formatter.positiveFormat = "00,000.0000"
        let formattedString = formatter.stringFromNumber(convertedTime)!
        timerButton.setTitle("$ \(formattedString)", forState: .Normal)
    }
    
    func enableActionButtons(enable: Bool) {
        saveButton.enabled = enable
        cancelButton.enabled = enable
    }
    
    func resetTimer() {
        timerButton.setTitle("$ 00,000.0000", forState: .Normal)
        enableActionButtons(false)
        timer = nil
        startDate = nil
        stoppedDate = nil
        totalStoppageTime = 0
        elapsedTime  = nil
        NSUserDefaults.standardUserDefaults().removeObjectForKey("\(account.objectID)StartDate")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("\(account.objectID)StoppedDate")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("\(account.objectID)StoppageTime")
    }

}
