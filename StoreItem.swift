//
//  StoreItem.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import Foundation
import CoreData


class StoreItem: NSManagedObject {

    convenience init(name: String, detail: String, price: Double, owned: Bool, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("StoreItem", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.name = name
            self.detail = detail
            self.price = price
            self.owned = owned
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
