//
//  HomeVC.swift
//  Ten Grand
//
//  Created by James Dyer on 6/27/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        establishTabBar()
        establishNavigation()
    }
    
    func establishNavigation() {
        //Sets Navigation Image
        let logo = UIImage(named: "nav_logo.png")
        self.navigationItem.titleView = UIImageView(image: logo)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    func establishTabBar() {
        //Sets TabBar Adjustment
        if let tabBarItems = tabBarController?.tabBar.items {
            for items in tabBarItems {
                items.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0)
            }
        }
    }

}

