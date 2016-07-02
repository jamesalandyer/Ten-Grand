//
//  Account+CoreDataProperties.swift
//  
//
//  Created by James Dyer on 7/1/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Account {

    @NSManaged var balance: NSNumber?
    @NSManaged var name: String?
    @NSManaged var time: NSNumber?
    @NSManaged var stoppageTime: NSNumber?
    @NSManaged var stoppedDate: NSDate?
    @NSManaged var startDate: NSDate?
    @NSManaged var bank: Bank?
    @NSManaged var deposits: NSSet?

}
