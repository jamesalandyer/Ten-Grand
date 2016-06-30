//
//  ItemCell.swift
//  Ten Grand
//
//  Created by James Dyer on 6/28/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    //Outlets
    @IBOutlet weak private var itemImage: UIImageView!
    
    /*
     Configures the cell.
     
     - Parameter item: The item to configure the cell.
     */
    func configureCell(item: StoreItem) {
        
        var image = UIImage(named: "\(item.name!)_locked")
        
        if let owned = item.owned?.boolValue {
            if owned {
                image = UIImage(named: "\(item.name!)_purchased")
            }
        }
        
        itemImage.image = image
    }
    
}
