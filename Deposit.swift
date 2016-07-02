//
//  Deposit.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import Foundation
import CoreData


class Deposit: NSManagedObject {

    convenience init(amount: Double, date: NSDate?, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Deposit", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.amount = amount
            self.date = date ?? NSDate()
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
