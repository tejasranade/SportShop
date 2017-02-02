//
//  CartItem.swift
//  SportShop
//
//  Created by Tejas on 1/27/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import ObjectMapper
import Realm


class Order: Entity {
    var shipping: Address?
    var billing: Address?
    var products: [CartItem] = [CartItem]()

    init (_ products: [CartItem], billing: Address, shipping: Address){
        super.init()
        self.products = products
        self.billing = billing
        self.shipping = shipping
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "ShoppingCart"
    }
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        products <- (map["products"], CartItemsTransform())
        billing <- map["billing_address"]
        shipping <- map["shipping_address"]
        //payment <- map["payment_info"]
    }

}

class Cart: Entity {
    var products: [CartItem] = [CartItem]()
    //var payment: Payment?
    
    open static let shared = Cart()
    
    
    func addToCart (_ item: CartItem){
        for product in products {
            if product.productID == item.productID {
                (product.quantity)! += item.quantity!
                return
            }
        }
        products.append(item)
    }
    
    func changeQuantity (_ item: CartItem, newQuantity: Int){
        for product in products {
            if product.productID == item.productID {
                product.quantity = newQuantity                
            }
        }
    }
    
    func clear () {
        products.removeAll()
    }
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "ShoppingCart"
    }
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        products <- (map["products"], CartItemsTransform())
    }
}

class CartItem: Mappable {
    var quantity: Int?
    var productID: String?
    
    public func mapping(map: Map) {
        quantity <- map["quantity"]
        productID <- map["product_id"]
    }

    required init?(map: Map) {
        guard
            let qty = map["quantity"].currentValue as? Int,
            let pID = map["product_id"].currentValue as? String
        else{
            return nil
        }
        
        self.quantity = qty
        self.productID = pID
    }
    
    init(_ productID: String, quantity: Int){        
        self.productID = productID
        self.quantity = quantity
    }

}


class CartItemsTransform: TransformType {
    
    typealias Object = [CartItem]
    typealias JSON = [[String: Any]]
    
    func transformFromJSON(_ value: Any?) -> [CartItem]? {
        return nil
    }
    
    func transformToJSON(_ value: [CartItem]?) -> [[String:Any]]? {
        if let items = value {
            var result: [[String:Any]] = [[String:Any]]()
            for item in items {
                result.append(item.toJSON())
            }
            
            return result
        }
        return nil
    }
    
}


class Address: Mappable {
    var addr1: String?
    var addr2: String?
    
    public func mapping(map: Map) {
        addr1 <- map["addr1"]
        addr2 <- map["addr2"]
    }
    
    required init?(map: Map) {
        guard
            let addr1 = map["addr1"].currentValue as? String,
            let addr2 = map["addr2"].currentValue as? String
            else{
                return nil
        }
        
        self.addr1 = addr1
        self.addr2 = addr2
    }
    
    init(_ addr1: String, addr2: String){
        self.addr1 = addr1
        self.addr2 = addr2
    }
}

class Payment: Mappable {
    var number:String?
    var holder:String?
//    "card_type":"Visa",
//    "expiration_month":1,
//    "expiration_year":2021
    
    public func mapping(map: Map) {
        number <- map["number"]
        holder <- map["holder"]
    }

    required init?(map: Map) {
        guard
            let number = map["number"].currentValue as? String,
            let holder = map["holder"].currentValue as? String
            else{
                return nil
        }
        
        self.number = number
        self.holder = holder
    }
    
    init(_ number: String, holder: String){
        self.number = number
        self.holder = holder
    }


}
