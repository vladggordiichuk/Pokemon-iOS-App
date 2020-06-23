//
//  RootTabBarController.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 14.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import UIKit
import SDWebImage

class RootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            navigationController(withRoot: ListViewController(of: .all)),
            navigationController(withRoot: ListViewController(of: .ground)),
            navigationController(withRoot: ListViewController(of: .fire)),
            navigationController(withRoot: ListViewController(of: .water)),
            navigationController(withRoot: ListViewController(of: .flying))
        ]
        
    }
    
    private func navigationController(withRoot viewController: UIViewController) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = viewController.tabBarItem
        
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(askToClearCache))
        
        return navigationController
    }
    
    @objc private func askToClearCache() {
        
        let alertController = UIAlertController(
            title: "Delete all cache",
            message: "Are you sure you want to drop pokemon database and image cache?",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Clear Cache", style: .destructive, handler: { _ in
            RealmManager.deleteAll()
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk()
        }))
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}
