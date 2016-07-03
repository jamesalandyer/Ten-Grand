//
//  StoreVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit
import CoreData

class StoreVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    //Outlets
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var layoutFlow: UICollectionViewFlowLayout!
    @IBOutlet weak private var cashLabel: UILabel!
    
    //Properties
    var bank: Bank!
    
    private var fetchedResultsController: NSFetchedResultsController!
    private var sharedContext = CoreDataStack.stack.context
    
    //MARK: - Stack
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "StoreItem")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)

        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
        }
        
        fetchedResultsController.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        establishNavigation()
        establishFlowLayout()
        
        updateCashLabel(nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateCashLabel), name: "Purchased", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateCashLabel), name: "Deposit", object: nil)
    }
    
    //MARK: - Adjusting UI
    
    /*
     Sets the center logo for the navigation bar.
     */
    private func establishNavigation() {
        //Sets Navigation Image
        let logo = UIImage(named: "nav_logo")
        navigationItem.titleView = UIImageView(image: logo)
    }
    
    /*
     Sets the flow layout for the collection view.
     */
    private func establishFlowLayout() {
        let space: CGFloat = 0
        let denom: CGFloat = 4.0
        let width = self.view.frame.width
        let dimensions = width / denom
        
        layoutFlow.minimumInteritemSpacing = space
        layoutFlow.minimumLineSpacing = space
        layoutFlow.itemSize = CGSizeMake(dimensions, dimensions)
    }
    
    /*
     Updates the current cash label.
     
     - Parameter notif: (Optional) A NSNotification of the notification being passed in.
     */
    func updateCashLabel(notif: NSNotification?) {
        let cash = bank.cash!.doubleValue
        cashLabel.text = "CASH: \(formatMoneyIntoString(cash))"
    }
    
    //MARK: - CollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! StoreItem
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCell", forIndexPath: indexPath) as? ItemCell {
            
            cell.configureCell(item)
            
            return cell
        } else {
            return ItemCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showStoreDetailVC", sender: fetchedResultsController.objectAtIndexPath(indexPath))
    }
    
    //MARK: - NSFetchedResultsController
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Update:
            collectionView.reloadItemsAtIndexPaths([indexPath!])
        default:
            break
        }
        
    }
    
    //MARK: - Segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStoreDetailVC" {
            if let storeDetailVC = segue.destinationViewController as? StoreDetailVC {
                storeDetailVC.item = sender as! StoreItem
                storeDetailVC.bank = bank
            }
        }
    }
    
}
