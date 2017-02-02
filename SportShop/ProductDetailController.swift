//
//  ProductDetailController.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Material
import Haneke

class ProductDetailController: UIViewController {
    var product:Product?
    
    @IBOutlet weak var shortDesc: UILabel!
    @IBOutlet weak var longDesc: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productImage: UIImageView!

    @IBAction func onAddToCart(_ sender: Any){
        Cart.shared.addToCart(CartItem((product?.entityId)!, quantity: 1))
        showConfirmation()
    }
    
    func showConfirmation() {
        let alert = UIAlertController(title: "Done!", message: "Product has been added to your cart", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = product?.name
        
        self.shortDesc.text = product?.shortDesc
        self.longDesc.text = product?.longDesc
        self.price.text = product?.priceString
        
        if let src = product?.imageSource {
            let url = URL(string: src)
            self.productImage.hnk_setImage(from: url)
            
//            DispatchQueue.global().async {
//                let data = try? Data(contentsOf: url!)
//                
//                if let _ = data{
//                    DispatchQueue.main.async {
//                        self.productImage?.image = UIImage(data: data!)
//                    }
//                }
//                
//            }
        }
    }
}
