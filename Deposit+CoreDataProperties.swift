//
//  Deposit+CoreDataProperties.swift
//  Ten Grand
//
//  Created by James Dyer on 6/29/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Deposit {

    @NSManaged var date: NSDate?
    @NSManaged var amount: NSNumber?
    @NSManaged var account: Account?

}
