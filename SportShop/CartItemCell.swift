//
//  CartItemCell.swift
//  SportShop
//
//  Created by Tejas on 1/27/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey
//import Material

class CartItemCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var quantity: UITextField!
    
    lazy var productStore:DataStore<Product> = {
        return DataStore<Product>.collection(.cache)
    }()

    var item:CartItem?
    
    override func layoutSubviews() {
        productStore.find((item?.productID)!) { (product, error) in
            if let product = product {
                self.title.text = product.name
            }
        }
        quantity.text = String(describing: (item?.quantity)!)
    }
    
    @IBAction func onChangeQuantity(_ sender: Any) {
        if let item = item {
            Cart.shared.changeQuantity(item, newQuantity: Int(quantity.text ?? "0") ?? 0)
        }
        
    }
}
