//
//  AppDelegate.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var bank: Bank!
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let fetchRequest = NSFetchRequest(entityName: "Bank")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "netWorth", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
        }
        
        if fetchedResultsController.fetchedObjects?.count > 0 {
            let bank = fetchedResultsController.fetchedObjects![0] as! Bank
            self.bank = bank
        } else {
            bank = Bank(netWorth: 0.00, cash: 0.00, context: CoreDataStack.stack.context)
            CoreDataStack.stack.save()
        }
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(accountsChanged), name: "AccountsChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(accountChanged), name: "AccountChanged", object: nil)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate: WCSessionDelegate {
    
    /*
     Sends a message to the watch with all of the accounts.
     
     - Parameter notif: The NSNotification being passed through.
     */
    func accountsChanged(notif: NSNotification) {
        if WCSession.isSupported() {
            
            session = WCSession.defaultSession()
            
            if session!.reachable {
                if let accounts = bank.accounts {
                    let accountsData = createAccountData(accounts)
                
                    session!.sendMessage(["accounts": accountsData], replyHandler: nil, errorHandler: nil)
                }
            }
            
        }
    }
    
    /*
     Sends a message to the watch with account that changed.
     
     - Parameter notif: The NSNotification being passed through.
     */
    func accountChanged(notif: NSNotification) {
        if WCSession.isSupported() {
            
            session = WCSession.defaultSession()
            
            if session!.reachable {
                if let changedAccount = notif.object as? Account {
                    let updateData = createDataForAccount(changedAccount)
                    
                    session!.sendMessage(["update": updateData], replyHandler: nil, errorHandler: nil)
                }
            }
            
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let accounts = bank.accounts {
            if let message = message["bank"] as? String {
                //Watch needs account data
                if message == "retrieveData" {
                    let accountsData = createAccountData(accounts)
                    replyHandler(["accounts": accountsData])
                }
            } else {
                performUIUpdatesOnMain {
                    let messageCount = message.count
                    var accountHasChanges = false
                    
                    if let message = message["account"] as? [String: AnyObject] {
                        //Watch sent over new account data
                        let accountID = message["ID"] as! String
                        let matchingAccount = self.findAccount(accountID, accounts: accounts)
                        
                        let balance = message["balance"] as! Double
                        let startDate = message["startDate"] as? NSDate ?? nil
                        let stoppedDate = message["stoppedDate"] as? NSDate ?? nil
                        let stoppageTime = message["stoppageTime"] as? Double ?? 0
                        
                        if let accountToUpdate = matchingAccount {
                            accountToUpdate.balance = balance
                            accountToUpdate.startDate = startDate
                            accountToUpdate.stoppedDate = stoppedDate
                            accountToUpdate.stoppageTime = stoppageTime
                            
                            if messageCount > 1 {
                                if let time = message["time"] as? Double {
                                    accountToUpdate.time = time
                                }
                            }
                            
                            accountHasChanges = true
                        }
                    }
                    if let message = message["deposit"] as? [String: AnyObject] {
                        //Watch sent over deposit data
                        let depositAccount = message["ID"] as! String
                        let matchingAccount = self.findAccount(depositAccount, accounts: accounts)
                        
                        if let matchingAccount = matchingAccount {
                            let depositAmount = message["amount"] as! Double
                            let depositDate = message["date"] as! NSDate
                            let deposit = Deposit(amount: depositAmount, date: depositDate, context: CoreDataStack.stack.context)
                            deposit.account = matchingAccount
                            
                            let bankNetWorth = matchingAccount.bank!.netWorth as! Double
                            matchingAccount.bank!.netWorth = bankNetWorth + depositAmount
                            let bankCash = matchingAccount.bank!.cash as! Double
                            matchingAccount.bank!.cash = bankCash + depositAmount
                            
                            let notif = NSNotification(name: "Deposit", object: nil)
                            NSNotificationCenter.defaultCenter().postNotification(notif)
                            
                            accountHasChanges = true
                        }
                    }
                    
                    if accountHasChanges {
                        //Only update if their is a matching accoung and changes were sent
                        let notif = NSNotification(name: "Update", object: nil)
                        NSNotificationCenter.defaultCenter().postNotification(notif)
                        CoreDataStack.stack.save()
                    }
                }
            }
        }
    }
    
    /*
     Creates account data from a set of accounts.
     
     - Parameter accounts: The NSSet of accounts to create data from.
     
     - Returns: An array with a dictionary with each accounts data.
     */
    private func createAccountData(accounts: NSSet) -> [[String: AnyObject]] {
        var accountsData = [[String: AnyObject]]()
        
        for account in accounts {
            let currentAccount = account as! Account
            let newAccount = createDataForAccount(currentAccount)
            accountsData.append(newAccount)
        }
        
        return accountsData
    }
    
    /*
     Creates account data for an account.
     
     - Parameter account: The account to create data from.
     
     - Returns: A dictionary with the account data.
     */
    private func createDataForAccount(currentAccount: Account) -> [String: AnyObject] {
        var newAccount = [String: AnyObject]()
        newAccount["ID"] = "\(currentAccount.objectID)"
        newAccount["name"] = currentAccount.name
        newAccount["balance"] = currentAccount.balance
        newAccount["time"] = currentAccount.time
        newAccount["startDate"] = currentAccount.startDate
        newAccount["stoppedDate"] = currentAccount.stoppedDate
        newAccount["stoppageTime"] = currentAccount.stoppageTime
        
        return newAccount
    }
    
    /*
     Finds an account by searching the accounts to match the objectID of the account.
     
     - Parameter accountID: The string of the account's objectID being searched for.
     - Parameter accounts: The NSSet of all of the accounts to search through.
     
     - Returns: (Optional) The account if found.
     */
    private func findAccount(accountID: String, accounts: NSSet) -> Account? {
        for account in accounts {
            let currentAccount = account as! Account
            
            if "\(currentAccount.objectID)" == accountID {
                return currentAccount
            }
        }
        
        return nil
    }
    
}
