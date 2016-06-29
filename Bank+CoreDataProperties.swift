//
//  Bank+CoreDataProperties.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Bank {

    @NSManaged var netWorth: NSNumber?
    @NSManaged var cash: NSNumber?
    @NSManaged var accounts: NSSet?

}
