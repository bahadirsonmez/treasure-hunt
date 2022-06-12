//
//  TabBarController.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 12.06.2022.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    func setupTabs() {
        let firstView: UIViewController = UINavigationController(rootViewController: ViewController())
        let tabbarItem = UITabBarItem(title: "Regions", image: UIImage(systemName: "list.bullet"), tag: 0)
        firstView.tabBarItem = tabbarItem
                
        let secondView: UIViewController = UINavigationController(rootViewController: ViewController())
        let tabbarItem2 = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        secondView.tabBarItem = tabbarItem2
        
        self.viewControllers = [firstView, secondView]
    }
    
}

