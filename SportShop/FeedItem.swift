//
//  FeedItem.swift
//  SportShop
//
//  Created by Tejas on 1/26/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import ObjectMapper

class FeedItem : Entity {
    dynamic var imageSource: String = ""
    dynamic var name: String = ""
    dynamic var desc: String = ""
    
//    init (name: String, desc: String, imageSource: String) {
//        self.name = name
//        self.desc = desc
//        self.imageSource = imageSource
//    }
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "Feed"
    }
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        name <- map["name"]
        desc <- map["description"]
        imageSource <- map["imageSource"]
    }

    
}
