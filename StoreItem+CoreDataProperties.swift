//
//  StoreItem+CoreDataProperties.swift
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

extension StoreItem {

    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var owned: NSNumber?
    @NSManaged var detail: String?

}
