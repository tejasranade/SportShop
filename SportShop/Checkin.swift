//
//  Checkin.swift
//  SportShop
//
//  Created by Tejas on 2/1/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import ObjectMapper
import Realm

class Checkin: Entity {
    var store: Store?
    var timestamp: Date?
    
    public init(_ store: Store, time: Date){
        super.init()
        self.store = store
        self.timestamp = time
    }
    
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value:value, schema: schema)
    }
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "Checkin"
    }
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        store <- map["store"]
        timestamp <- (map["timestamp"], KinveyDateTransform())
    }
    
}

class Store: Mappable {

    var id: String?
    var name: String?
    var desc: String?
    
    public init(_ id: String, name: String, desc: String){
        self.name = name
        self.desc = desc
    }

    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        guard
            let name = map["name"].currentValue as? String,
            let desc = map["desc"].currentValue as? String
            else{
                return nil
        }
        
        self.name = name
        self.desc = desc

    }
    
    public func mapping(map: Map) {
        name <- map["name"]
        desc <- map["desc"]
    }
    

}
//class Store: Entity {
//    var name: String?
//    var desc: String?
//    
//    public init(_ name: String, desc: String){
//        super.init()
//        self.name = name
//        self.desc = desc
//    }
//
//    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        super.init(realm: realm, schema: schema)
//    }
//    
//    required init?(map: Map) {
//        super.init(map: map)
//    }
//    
//    required init() {
//        super.init()
//    }
//    
//    required init(value: Any, schema: RLMSchema) {
//        super.init(value:value, schema: schema)
//    }
//
//    override class func collectionName() -> String {
//        //return the name of the backend collection corresponding to this entity
//        return "Store"
//    }
//    
//    //Map properties in your backend collection to the members of this entity
//    override func propertyMapping(_ map: Map) {
//        //This maps the "_id", "_kmd" and "_acl" properties
//        super.propertyMapping(map)
//        
//        //Each property in your entity should be mapped using the following scheme:
//        //<member variable> <- ("<backend property>", map["<backend property>"])
//        name <- map["name"]
//        desc <- map["desc"]
//    }
//}
