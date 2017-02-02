//
//  CheckoutViewController.swift
//  SportShop
//
//  Created by Tejas on 1/28/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class CheckoutController: UIViewController {

    lazy var orderStore:DataStore<Order> = {
        return DataStore<Order>.collection(.network)
    }()

    @IBOutlet weak var shipping1: UITextField!
    @IBOutlet weak var shipping2: UITextField!
    @IBOutlet weak var billing1: UITextField!
    @IBOutlet weak var billing2: UITextField!
    @IBOutlet weak var paymentSwitch: UISwitch!

    @IBAction func onOrderSubmitted(_ sender: Any) {
        let cart = Cart.shared
        
        let billing = Address(billing1.text ?? "", addr2: billing2.text ?? "")
        let shipping = Address(shipping1.text ?? "", addr2: shipping2.text ?? "")
        let order = Order(cart.products, billing: billing, shipping: shipping)
        //cart.payment = Payment("0000964641112853", holder: "James Bond")
        
        orderStore.save(order) { (savedOrder, error) in
            if let _ = error {
                print("Something went wrong - \(error)")
            } else {
                self.showConfirmation()
                cart.clear()
                self.orderStore.clearCache()
            }
        }
    }
    
    func showConfirmation () {
        let alert = UIAlertController(title: "Checkout", message: "Order Placed!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
