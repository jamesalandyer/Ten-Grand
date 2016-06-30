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
    
    @IBOutlet weak var netWorthLabel: UILabel!
    @IBOutlet weak var accountsLabel: UILabel!
    
    var fetchedResultsController: NSFetchedResultsController!
    var sharedContext = CoreDataStack.stack.context
    
    var bank: Bank!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch") {
            createUserData()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
            //performSegueWithIdentifier("showPopUpVC", sender: false)
        } else {
            //performSegueWithIdentifier("showPopUpVC", sender: true)
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
        updateAccountsLabel()
        
        establishTabBar()
        establishNavigation()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addAccount), name: "AddAccount", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateNetWorthLabel), name: "Deposit", object: nil)
    }
    
    func establishNavigation() {
        //Sets Navigation Image
        let logo = UIImage(named: "nav_logo.png")
        self.navigationItem.titleView = UIImageView(image: logo)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    func establishTabBar() {
        //Sets TabBar Adjustment
        if let tabBarItems = tabBarController?.tabBar.items {
            for items in tabBarItems {
                items.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
            }
        }
    }
    
    func updateNetWorthLabel(notif: NSNotification?) {
        let netWorth = bank.netWorth!.doubleValue
        netWorthLabel.text = formatMoneyIntoString(netWorth)
    }
    
    func updateAccountsLabel() {
        if let accountNumber = bank.accounts?.count {
            accountsLabel.text = "\(accountNumber)"
        } else {
            accountsLabel.text = "0"
        }
    }
    
    func addAccount(notif: NSNotification) {
        let account = notif.object as! Account
        
        account.bank = bank
        
        CoreDataStack.stack.save()
        
        updateAccountsLabel()
    }
    
    func createUserData() {
        _ = Bank(netWorth: 0.00, cash: 0.00, context: sharedContext)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStoreVC" {
            if let storeVC = segue.destinationViewController as? StoreVC {
                storeVC.bank = bank
            }
        }
    }

}

