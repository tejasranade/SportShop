//
//  AccountViewController.swift
//  SportShop
//
//  Created by Tejas on 1/25/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey
import FBSDKCoreKit
import FBSDKLoginKit

class AccountViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Kinvey.sharedClient.isNamedUser() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fbLoginButton.readPermissions = ["", "", ""]
        //if FBSDKAccessToken.current() == nil,
    }
    
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()

    }
    
    @IBAction func login(_ sender: Any) {
        if let _ = userName.text, let _ = password.text {

            User.login(username: userName.text!, password: password.text!) { user, error in
                if let _ = user {
                    NotificationCenter.default.post(name: Notification.Name("kinveyUserChanged"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else {
            //TODO
            print ("input validation error")
        }
        
    }
    
    @IBAction func continueAsGuest(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        loginButton.readPermissions = ["email"]
        return true
    }

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Swift.Error!) {
        if let token = result.token {
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token.tokenString, version: nil, httpMethod: "GET")
            let _ = req?.start { (_, result, error) -> Void in
                var res = result as! [String:AnyObject]
                
                User.login(authSource: .facebook, ["access_token": token.tokenString,
                                                   "appid": token.appID,
                                                   "email": res["email"]!,
                                                   "name" : res["name"]!]) { user, error in
                    print ("Logged in to kinvey with fb user")
                    NotificationCenter.default.post(name: Notification.Name("kinveyUserChanged"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }

                if(error == nil)
                {
                    print("result \(result)")
                }
                else
                {
                    print("error \(error)")
                }
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        Kinvey.sharedClient.activeUser?.logout()
        FBSDKLoginManager().logOut()
        User.login(username: "Guest", password: "kinvey") { user, error in
            if let _ = user {
                NotificationCenter.default.post(name: Notification.Name("kinveyUserChanged"), object: nil)
            }
        }
    }
}
