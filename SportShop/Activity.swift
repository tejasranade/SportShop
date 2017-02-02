//
//  Activity.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import Realm
import ObjectMapper

class Activity: Entity {
    var timestamp: Date = Date()
    var view: String?
    var action: String?
    
    init(view: String, timestamp: Date, action: String) {
        super.init()
        self.view = view
        self.timestamp = timestamp
        self.action = action
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
        return "Activity"
    }
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        view <- map["view"]
        action <- map["action"]
        timestamp <- (map["timestamp"], KinveyDateTransform())        
    }

    
}
