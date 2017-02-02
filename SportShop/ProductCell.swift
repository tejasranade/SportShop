//
//  ProductCell.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class ProductCell: UITableViewCell {
    var product: Product?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var shortDesc: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func layoutSubviews() {
        name.text = product?.name
        price.text = product?.priceString
        shortDesc.text = product?.shortDesc
        //productImage.image = UIImage
        
        if let src = product?.imageSource {
            self.loadImage(src)
        }
    }
    
    func loadImage (_ src: String) {
        let url = URL(string: src)
        
        self.productImage.hnk_setImage(from: url)
        
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!)
//            
//            if let _ = data{
//                DispatchQueue.main.async {
//                    self.productImage?.image = UIImage(data: data!)
//                }
//            }
//        }
    }

    
}
