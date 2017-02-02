//
//  AdidasUser.swift
//  SportShop
//
//  Created by Tejas on 2/1/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey
import ObjectMapper

class AdidasUser: User {

    var sport: String?
    var imageSource:String?
    var firstname: String?
    var lastname: String?
    var salesCloudID: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        sport <- map["sport"]
        imageSource <- map["imageSource"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        salesCloudID <- map["salesCloudId"]
    }
}
