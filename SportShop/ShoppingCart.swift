//
//  ShoppingCart.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey


class ShoppingCart {

    open static let shared = ShoppingCart()
    
    var cart: Cart = Cart()
    
    lazy var cartStore:DataStore<Cart> = {
        return DataStore<Cart>.collection(.cache)
    }()
    
    func saveCart() {
        cartStore.save(cart) { (savedCart, error) in
            print ("done saving")
        }
    }
    
    func addToCart(_ item: CartItem){
    
    }
}
