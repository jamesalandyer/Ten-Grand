//
//  StoreVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class StoreVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        establishNavigation()
    }
    
    func establishNavigation() {
        //Sets Navigation Image
        let logo = UIImage(named: "nav_logo.png")
        self.navigationItem.titleView = UIImageView(image: logo)
    }

}
