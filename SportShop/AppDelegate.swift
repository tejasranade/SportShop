//
//  AppDelegate.swift
//  SportShop
//
//  Created by Tejas on 1/25/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Kinvey
import Material
import FBSDKCoreKit

extension UIStoryboard {
    class func viewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var drawerController: AppNavigationDrawerController?
    
    lazy var rootViewController: RootViewController = {
        return UIStoryboard.viewController(identifier: "RootViewController") as! RootViewController
    }()
    
    lazy var leftViewController: LeftViewController = {
        return UIStoryboard.viewController(identifier: "LeftViewController") as! LeftViewController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        initializeKinvey()

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)


        window = UIWindow(frame: Screen.bounds)
        drawerController = AppNavigationDrawerController(rootViewController: UINavigationController(rootViewController: rootViewController),
                                                         leftViewController: leftViewController)
        window!.rootViewController = drawerController
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        return handled
    }
    
    func initializeKinvey(){
        Kinvey.sharedClient.initialize(appKey: "kid_rk6kcZvPl", appSecret: "")
        Kinvey.sharedClient.logNetworkEnabled = true
        Kinvey.sharedClient.userType = AdidasUser.self
    }
}

extension Client {
    func isNamedUser () -> Bool {
        return activeUser != nil && activeUser?.username != "Guest"
    }
    
    func realUserName() -> String? {
        if let user = activeUser as? AdidasUser {
            return user.firstname
        }
        return activeUser?.username
    }
}
