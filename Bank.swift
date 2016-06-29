//
//  Bank.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import Foundation
import CoreData


class Bank: NSManagedObject {

    convenience init(netWorth: Double, cash: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entityForName("Bank", inManagedObjectContext: context) {
            self.init(entity: ent, insertIntoManagedObjectContext: context)
            self.netWorth = netWorth
            self.cash = cash
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
