//
//  Product.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import ObjectMapper
import Realm

class Product: Entity {
    dynamic var name: String?
    dynamic var shortDesc: String?
    dynamic var longDesc: String?
    dynamic var currency: String?
    dynamic var category: String?
    
    var priceString: String {
        if let _ = price {
            return String("$ \(price!)")
        }
        return ""
        
    }
    var price: Int?
    dynamic var imageSource: String?
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "Product"
    }
    
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        name <- map["name"]
        shortDesc <- map["description"]
        longDesc <- map["long_description"]
        price <- map["price"]
        currency <- map["currency"]
        imageSource <- map["imageSource"]
        category <- map["category"]
    }

}
