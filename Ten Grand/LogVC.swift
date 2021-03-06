//
//  LogVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit
import CoreData

class LogVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    //Outlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak var dismissButtonConstraint: NSLayoutConstraint!
    
    //Properties
    private var fetchedResultsController: NSFetchedResultsController!
    var account: Account!
    
    private var animEngineButtons: AnimationEngine!
    
    //MARK: - Stack
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest(entityName: "Deposit")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let predicate = NSPredicate(format: "account = %@", argumentArray: [account])
        
        fetchRequest.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
        }
        
        fetchedResultsController.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        animEngineButtons = AnimationEngine(constraints: [dismissButtonConstraint])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animEngineButtons.animateOnScreen()
    }
    
    //MARK: - Actions
    
    @IBAction func dismissButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //For iPads
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let deposit = fetchedResultsController.objectAtIndexPath(indexPath) as! Deposit
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("LogCell") as? LogCell {
            
            cell.configureCell(deposit)
            
            return cell
        } else {
            return LogCell()
        }
    }
    
    //MARK: - NSFetchedResultsController
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}
