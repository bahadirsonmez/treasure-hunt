//
//  AlertHelper.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 23.06.2022.
//

import UIKit

typealias VoidClosure = () -> Void
fileprivate let appDelegate = UIApplication.shared.delegate as! AppDelegate

class AlertHelper: NSObject {
    @discardableResult
    class func showPermanentAlert(_ title: String?, message: String?) -> UIAlertController {
        let alertController = GlobalAlertController(title: title, message:message, preferredStyle: .alert)
        alertController.view.tintColor = .labelColor
        alertController.presentGlobally(animated: true, completion: nil)
//        DispatchQueue.main.async {
//            alertController.view.tintColor = .labelColor
//        }
        return alertController
    }
    
    @discardableResult
    class func showAlert(_ title: String?, message: String?,
                         destructiveTitle: String, controller: UIViewController) -> UIAlertController {
        let alertController = GlobalAlertController(title: title, message:message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: destructiveTitle, style: .cancel) { (_) in
        }
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .labelColor
        alertController.presentGlobally(animated: true, completion: nil)
        return alertController
    }
}

class GlobalAlertController: UIAlertController {
    
    var globalPresentationWindow: UIWindow?
    
    func presentGlobally(animated: Bool, completion: (() -> Void)?) {
        appDelegate.window?.endEditing(true)
        globalPresentationWindow = UIWindow(frame: UIScreen.main.bounds)
        globalPresentationWindow?.rootViewController = UIViewController()
        globalPresentationWindow?.windowLevel = UIWindow.Level.alert + 1
        globalPresentationWindow?.backgroundColor = .clear
        globalPresentationWindow?.makeKeyAndVisible()
        globalPresentationWindow?.rootViewController?.present(self, animated: animated, completion: completion)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        globalPresentationWindow?.isHidden = true
        globalPresentationWindow = nil
    }
    
}

