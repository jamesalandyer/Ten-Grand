//
//  Account.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import Foundation
import CoreData


class Account: NSManagedObject {

    convenience init(name: String, balance: Double, time: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Account", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.name = name
            self.balance = balance
            self.time = time
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
