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

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var cashLabel: UILabel!
    
    var bank: Bank!
    
    var fetchedResultsController: NSFetchedResultsController!
    var sharedContext = CoreDataStack.stack.context
    
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
    
    private func establishNavigation() {
        //Sets Navigation Image
        let logo = UIImage(named: "nav_logo.png")
        self.navigationItem.titleView = UIImageView(image: logo)
    }
    
    private func establishFlowLayout() {
        let space: CGFloat = 0
        let width = self.view.frame.width
        let dimensions = width / 4.0
        
        layoutFlow.minimumInteritemSpacing = space
        layoutFlow.minimumLineSpacing = space
        layoutFlow.itemSize = CGSizeMake(dimensions, dimensions)
    }
    
    func updateCashLabel(notif: NSNotification?) {
        let cash = bank.cash!.doubleValue
        cashLabel.text = "CASH: \(formatMoneyIntoString(cash))"
    }
    
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
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Update:
            collectionView.reloadItemsAtIndexPaths([indexPath!])
        default:
            break
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStoreDetailVC" {
            if let storeDetailVC = segue.destinationViewController as? StoreDetailVC {
                storeDetailVC.item = sender as! StoreItem
                storeDetailVC.bank = bank
            }
        }
    }
    
}
