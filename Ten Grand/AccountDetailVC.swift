//
//  AccountDetailVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class AccountDetailVC: UIViewController {

    //Outlets
    @IBOutlet weak private var accountNameLabel: UILabel!
    @IBOutlet weak private var accountBalanceLabel: UILabel!
    @IBOutlet weak var accountProgressWidth: NSLayoutConstraint!
    @IBOutlet weak private var accountTimeLabel: UILabel!
    @IBOutlet weak private var timerLabel: UILabel!
    @IBOutlet weak private var timerButton: CustomButton!
    @IBOutlet weak private var saveButton: CustomButton!
    @IBOutlet weak private var cancelButton: CustomButton!
    @IBOutlet weak var deleteAccountConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerButtonsConstraint: NSLayoutConstraint!
    @IBOutlet weak private var timerStackView: UIStackView!
    @IBOutlet weak private var timerButtonsStackView: UIStackView!
    @IBOutlet weak private var deleteAccountNavButton: UIBarButtonItem!
    
    //Properties
    var account: Account!
    
    private var timer: NSTimer!
    private var startDate: NSDate!
    private var elapsedTime: NSTimeInterval!
    private var stoppedDate: NSDate!
    private var totalStoppageTime: NSTimeInterval = 0
    
    private var animEngineTimer: AnimationEngine!
    private var animEngineDeleteAccount: AnimationEngine!
    
    //MARK: - Stack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableActionButtons(false)
        
        let saveButtonSelectedImage = UIImage(named: "approve_button_selected.png")
        saveButton.setImage(saveButtonSelectedImage, forState: .Highlighted)
        let cancelButtonSelectedImage = UIImage(named: "cancel_button_selected.png")
        cancelButton.setImage(cancelButtonSelectedImage, forState: .Highlighted)

        setTimeAdjustments()
        
        establishNavigation()
        updateScreen()
        
        animEngineTimer = AnimationEngine(constraints: [timerConstraint, timerButtonsConstraint])
        animEngineDeleteAccount = AnimationEngine(constraints: [deleteAccountConstraint, deleteButtonsConstraint])
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newData), name: "Update", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animEngineTimer.animateOnScreen()
    }
    
    //MARK: - Actions
    
    @IBAction func timerButtonPressed(sender: AnyObject) {
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
            timerLabel.text = "TAP TIMER TO START"
            enableActionButtons(true)
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let amount = floor(elapsedTime) / 10000
        
        let deposit = Deposit(amount: amount, date: nil, context: CoreDataStack.stack.context)
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
    
    @IBAction func deleteAccountButtonPressed(sender: AnyObject) {
        deleteAccountNavButton.enabled = false
        animEngineTimer.animateOffScreen()
        animEngineDeleteAccount.animateOnScreen()
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        timer.invalidate()
        timerButtonsStackView.hidden = true
        timerStackView.hidden = true
        
        resetTimer()
        
        CoreDataStack.stack.context.deleteObject(account)
        CoreDataStack.stack.save()
        
        let notif = NSNotification(name: "RemoveAccount", object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notif)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deleteCancelButtonPressed(sender: AnyObject) {
        animEngineDeleteAccount.animateBackOffScreen()
        animEngineTimer.animateBackOnScreen()
        deleteAccountNavButton.enabled = true
    }
    
    //MARK: - Adjusting UI
    
    /*
     Sets the center logo for the navigation bar.
     */
    private func establishNavigation() {
        //Sets Navigation Image
        let logo = UIImage(named: "nav_logo.png")
        self.navigationItem.titleView = UIImageView(image: logo)
    }
    
    /*
     Updates the screen to show the current data.
     */
    private func updateScreen() {
        accountNameLabel.text = account.name!.uppercaseString
        
        let accountBalance = account.balance!.doubleValue
        accountBalanceLabel.text = formatMoneyIntoString(accountBalance)
        
        let progressWidth = ((self.view.frame.width - 16) / 10000) * CGFloat(accountBalance)
        accountProgressWidth.constant = progressWidth
        
        convertTimeString()
    }
    
    /*
     Sets the action buttons to enabled or not.
     
     - Parameter enable: A bool of whether to enable the action buttons.
     */
    private func enableActionButtons(enable: Bool) {
        saveButton.enabled = enable
        cancelButton.enabled = enable
    }
    
    /*
     Converts the seconds from the account into hours, minutes, and seconds.
     */
    private func convertTimeString() {
        let time = (account.time as! Double)
        let hours = Int(time / 3600)
        let minutes = Int((time % 3600) / 60)
        let seconds = Int((time % 3600) % 60)
        accountTimeLabel.text = "\(hours) HOUR(S), \(minutes) MINUTE(S), \(seconds) SECOND(S)"
    }
    
    //MARK: - Timer
    
    /*
     Starts the timer.
     */
    func startTimer() {
        enableActionButtons(false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timerLabel.text = "TAP TIMER TO STOP"
    }
    
    /*
     Sets the date that the user stopped the timer.
     
     - Parameter currentDate: (Optional) Sets the stop date, if nil it creates a current date.
     */
    func setStopDate(currentDate: NSDate?) {
        stoppedDate = currentDate ?? NSDate()
        account.stoppedDate = stoppedDate
        CoreDataStack.stack.save()
    }
    
    /*
     Sets the amount of time from the time the user hit stop to the current time.
     
     - Parameter currentDate: (Optional) Sets the stop date, if nil it creates a current date.
     */
    func setStoppageTime(currentDate: NSDate?) {
        let currentTime = currentDate ?? NSDate()
        totalStoppageTime += currentTime.timeIntervalSinceDate(stoppedDate)
        account.stoppageTime = totalStoppageTime
        stoppedDate = nil
        account.stoppedDate = nil
        CoreDataStack.stack.save()
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
            enableActionButtons(false)
        }
        
        let formattedString = formatTimeIntoLongCurrency(convertedTime)
        timerButton.setTitle("$ \(formattedString)", forState: .Normal)
    }
    
    /*
     Resets the timer and all the items associated with the timer.
     */
    func resetTimer() {
        timerButton.setTitle("$ 00,000.0000", forState: .Normal)
        enableActionButtons(false)
        timer = nil
        startDate = nil
        stoppedDate = nil
        totalStoppageTime = 0
        elapsedTime  = nil
        account.startDate = nil
        account.stoppedDate = nil
        account.stoppageTime = nil
        CoreDataStack.stack.save()
    }
    
    func setTimeAdjustments() {
        startDate = nil
        stoppedDate = nil
        totalStoppageTime = 0
        //See if the user still has a timer in memory
        if let date = account.startDate {
            startDate = date
        }
        
        //See if the timer was stopped in memory
        if let stopDate = account.stoppedDate {
            stoppedDate = stopDate
        }
        
        //See if the user has stopped the timer in memory at all
        if let stoppageTime = account.stoppageTime as? Double {
            totalStoppageTime = stoppageTime
            
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
            enableActionButtons(true)
        } else if startDate != nil {
            //The user has a timer in memory, start it
            startTimer()
            
        }
    }
    
    func newData(notif: NSNotification) {
        setTimeAdjustments()
        updateScreen()
        updateTime()
    }
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLogVC" {
            if let logVC = segue.destinationViewController as? LogVC {
                logVC.account = account
            }
        }
    }

}
