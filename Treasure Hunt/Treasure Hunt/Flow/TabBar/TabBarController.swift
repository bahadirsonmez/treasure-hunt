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
        let firstView: UIViewController = UINavigationController(rootViewController: HuntViewController())
        let tabbarItem = UITabBarItem(title: "Hunt", image: UIImage(systemName: "map.fill"), tag: 0)
        firstView.tabBarItem = tabbarItem
                
        let secondView: UIViewController = UINavigationController(rootViewController: ProfileViewController())
        let tabbarItem2 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        secondView.tabBarItem = tabbarItem2
        
        self.viewControllers = [firstView, secondView]
    }
    
}
