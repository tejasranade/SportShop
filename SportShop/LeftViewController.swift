/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material
import Kinvey

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let menuItems = ["Feed", "Products", "Shopping Cart", "In Store", "Support"]
    let menuControllers = ["RootViewController", "ProductsController", "CartViewController", "InStoreController", "SupportViewController"]
    
    @IBOutlet weak var welcomeMsg: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileView: UIView!
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onProfileTapped(_:)))
        profileView.addGestureRecognizer(tapGesture)
        
        
//        if let user = Kinvey.sharedClient.activeUser,
//            user.username != "Guest" {
//            User.get(userId: user.userId) { user, error in
//                self.updateUser()
//                
//                NotificationCenter.default.addObserver(self, selector: #selector(self.updateUser), name: Notification.Name("kinveyUserChanged"), object: nil)
//            }
//        }
//        else {
        updateUser()
            
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser), name: Notification.Name("kinveyUserChanged"), object: nil)
        //}
    
    }
    
    func onProfileTapped(_ sender: UITapGestureRecognizer) {
        if Kinvey.sharedClient.isNamedUser() {
            let settings = self.storyboard?.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
            present(settings, animated: true, completion: {
                print("settings presented")
            })
        } else {
            let login = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
            present(login, animated: true, completion: {
                print("login presented")
            })
        }
    }
    

    func updateUser(){
        if Kinvey.sharedClient.isNamedUser(),
            let name = Kinvey.sharedClient.realUserName() {
            welcomeMsg.text = "Welcome, \(name)!"
        } else {
            welcomeMsg.text = "Welcome, Guest!"
        }
        
        if let user = Kinvey.sharedClient.activeUser as? AdidasUser,
            let src = user.imageSource {
            loadImage(src)
        } else {
            profileImage.image = UIImage(named:"anon")
        }
        
    }
    
    func loadImage (_ src: String) {
        let url = URL(string: src)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            
            if let _ = data{
                DispatchQueue.main.async {
                    self.profileImage?.image = UIImage(data: data!)
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
        cell.menuItemLabel.text = menuItems[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctrlName = menuControllers[indexPath.row]
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: ctrlName)
        let navController = UINavigationController(rootViewController: viewController!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController!.transition(to: navController)
        appDelegate.drawerController!.toggleLeftView()
        
        ActivityManager.shared.logActivity(Activity(view: menuItems[indexPath.row], timestamp: Date(), action: "open"))
    }

}
