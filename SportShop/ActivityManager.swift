//
//  ActivityManager.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Kinvey

class ActivityManager {

    open static let shared = ActivityManager()

    lazy var activityStore:DataStore<Activity> = {
        return DataStore<Activity>.collection(.cache)
    }()
    
    open func logActivity(_ activity: Activity){
        activityStore.save(activity) { (savedActivity, error) in
            print("Logged activity")
            //ignore any errors
        }
    }
}
