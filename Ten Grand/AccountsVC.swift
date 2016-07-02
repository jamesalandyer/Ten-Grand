//
//  AccountsVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit
import CoreData

class AccountsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    //Outlets
    @IBOutlet weak private var tableView: UITableView!
    
    //Properties
    private var fetchedResultsController: NSFetchedResultsController!
    
    //MARK: - Stack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Account")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
        }
            
        fetchedResultsController.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        establishNavigation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func addAccountButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("showAddAccountVC", sender: nil)
    }
    
    
    //MARK: - Adjusting UI

    /*
     Sets the center logo for the navigation bar.
     */
    private func establishNavigation() {
        //Sets Navigation Image
        let logo = UIImage(named: "nav_logo.png")
        self.navigationItem.titleView = UIImageView(image: logo)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let account = fetchedResultsController.objectAtIndexPath(indexPath) as! Account
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell") as? AccountCell {
            
            let width = self.view.frame.size.width - 16
            
            cell.configureCell(account, width: width)
            
            return cell
            
        } else {
            return AccountCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let account = fetchedResultsController.objectAtIndexPath(indexPath) as! Account
    
        performSegueWithIdentifier("showAccountDetailVC", sender: account)
        
    }
    
    //MARK: - FetchedResultsController
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    //MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAccountDetailVC" {
            if let accountDetailVC = segue.destinationViewController as? AccountDetailVC {
                accountDetailVC.account = sender as! Account
            }
        }
    }
    
}
