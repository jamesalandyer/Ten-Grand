//
//  HomeVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    //Outlets
    @IBOutlet weak private var netWorthLabel: UILabel!
    @IBOutlet weak private var accountsLabel: UILabel!
    
    //Properties
    private var fetchedResultsController: NSFetchedResultsController!
    private var sharedContext = CoreDataStack.stack.context
    
    private var launchedBefore: Bool!
    private var showPopUp: Bool!
    private var bank: Bank!

    //MARK: - Stack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("LaunchedBefore") {
            createUserData()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "LaunchedBefore")
            showPopUp = true
            launchedBefore = false
        } else if let savedDate = NSUserDefaults.standardUserDefaults().stringForKey("PreviousPopUpDate") {
            let todayDate = formatDateToMMddyy(NSDate())
            if savedDate != todayDate {
                showPopUp = true
                launchedBefore = true
            }
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Bank")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "netWorth", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
        }
        
        bank = fetchedResultsController.fetchedObjects![0] as! Bank
        
        updateNetWorthLabel(nil)
        updateAccountsLabel(nil)
        
        establishTabBar()
        establishNavigation()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addAccount), name: "AddAccount", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateAccountsLabel), name: "RemoveAccount", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateNetWorthLabel), name: "Deposit", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if showPopUp != nil {
            performSegueWithIdentifier("showPopUpVC", sender: nil)
            showPopUp = nil
            launchedBefore = nil
        }
    }
    
    //MARK: - Adjusting UI
    
    /*
     Sets up the navigation center image.
     */
    private func establishNavigation() {
        //Sets Navigation Image
        let logo = UIImage(named: "nav_logo")
        navigationItem.titleView = UIImageView(image: logo)
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    /*
     Sets up the tab bar items to show without a title.
     */
    private func establishTabBar() {
        //Sets TabBar Adjustment
        if let tabBarItems = tabBarController?.tabBar.items {
            for items in tabBarItems {
                items.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
            }
        }
    }
    
    /*
     Updates the net worth label.
     
     -Parameter notif: (Optional) A NSNotification if triggered by a notification.
     */
    func updateNetWorthLabel(notif: NSNotification?) {
        let netWorth = bank.netWorth!.doubleValue
        netWorthLabel.text = formatMoneyIntoString(netWorth)
    }
    
    /*
     Updates the number of accounts label.
     
     -Parameter notif: (Optional) A NSNotification if triggered by a notification.
     */
    func updateAccountsLabel(notif: NSNotification?) {
        if let accountNumber = bank.accounts?.count {
            accountsLabel.text = "\(accountNumber)"
        } else {
            accountsLabel.text = "0"
        }
    }
    
    //MARK: - Changing Data
    
    /*
     Sets the bank for a new account and saves the context.
     
     -Parameter notif: (Optional) A NSNotification if triggered by a notification.
     */
    func addAccount(notif: NSNotification) {
        let account = notif.object as! Account
        
        account.bank = bank
        
        CoreDataStack.stack.save()
        
        updateAccountsLabel(nil)
    }
    
    /*
     Sets up all of the store items.
     */
    private func createUserData() {
        _ = StoreItem(name: "artwork", detail: "Every home needs artwork! Furnish your home with the finest artwork the world has ever seen! You will be very pleased with the decor in your new home!", price: 600.00, owned: false, context: sharedContext)
        _ = StoreItem(name: "paint", detail: "Your house needs some painting! It looks so dull and this paint will make it look so retro! This will make your house the envy of your neighbors!", price: 400.00, owned: false, context: sharedContext)
        _ = StoreItem(name: "swimming pool", detail: "Install a new swimming pool! You have always wanted to swim at your house and this is your chance! You could have a pool party for goodness sake!", price: 2000.00, owned: false, context: sharedContext)
        _ = StoreItem(name: "bed", detail: "Everyone needs a bed to sleep on in their home! This is one of the best beds money can buy! You will sleep just like a baby!", price: 800.00, owned: false, context: sharedContext)
        _ = StoreItem(name: "television", detail: "Want to watch some television? This is the largest and best television you can buy for your new house! I mean how else are you gonna watch Netflix?", price: 1200.00, owned: false, context: sharedContext)
        _ = StoreItem(name: "computer", detail: "Buy yourself a new computer! This will allow you to surf the web and do anything else you could desire!", price: 1400.00, owned: false, context: sharedContext)
        _ = StoreItem(name: "lamp", detail: "Your new home will need lighting. So it’s pretty much a necessitiy. You’ll be happy to know that these are those cool color changing lights!", price: 300.00, owned: false, context: sharedContext)
        _ = StoreItem(name: "sofa", detail: "Where you gonna sit in your new house? This couch! It’s super comfy and holds up to 7 people! Wait that can’t be right.", price: 1300.00, owned: false, context: sharedContext)
        _ = StoreItem(name: "security camera", detail: "There are some crazy people out there! So you are gonna need some security. Take for instance this security system!", price: 1800.00, owned: false, context: sharedContext)
        _ = StoreItem(name: "safe", detail: "Well, this does exactly what it says. It keeps thing safe! This is ideal to store all your money so nobody takes it!", price: 200.00, owned: false, context: sharedContext)
        CoreDataStack.stack.save()
    }
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPopUpVC" {
            if let popUpVC = segue.destinationViewController as? PopUpVC {
                popUpVC.launchedBefore = launchedBefore
            }
        } else if segue.identifier == "showStoreVC" {
            if let storeVC = segue.destinationViewController as? StoreVC {
                storeVC.bank = bank
            }
        }
    }

}

