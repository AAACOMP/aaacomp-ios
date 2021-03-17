//
//  AppDelegate.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 28/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        let tabBar = self.window?.rootViewController as? UITabBarController
        tabBar?.selectedIndex = 2
        
        return true
    }
}

