//
//  CartViewController.swift
//  SportShop
//
//  Created by Tejas on 1/26/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class CartViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var cartItems:[CartItem]?
    
    @IBOutlet weak var emptyCart: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutBtn: UIButton!
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }
    
    @IBAction func onCheckout(_ sender: Any) {
        if !Kinvey.sharedClient.isNamedUser() {
            let login = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
            present(login, animated: true, completion: {
                print("login presented")
            })            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cartItems = Cart.shared.products
        
        if cartItems?.count == 0 {
            //cart is empty
            emptyCart.isHidden = false
            tableView.isHidden = true
            checkoutBtn.isHidden = true
            
        } else {
            emptyCart.isHidden = true
            tableView.isHidden = false
            checkoutBtn.isHidden = false
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        
        cell.item = cartItems?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems?.count ?? 0
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "checkoutSegue" {
            return Kinvey.sharedClient.isNamedUser()
        }
        return true        
    }
}
