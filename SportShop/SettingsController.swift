//
//  SettingsController.swift
//  SportShop
//
//  Created by Tejas on 1/31/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey
import FBSDKLoginKit

class SettingsController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var sportData: [String] = ["Basketball", "Tennis", "Football", "Soccer", "Baseball", "Hockey"]
    
    @IBOutlet weak var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.reloadAllComponents()
        
        if let user = Kinvey.sharedClient.activeUser as? AdidasUser,
            let sport = user.sport,
            let index = sportData.index(of: sport) {
            
            picker.selectRow(index, inComponent: 0, animated: true)
        }
    
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func logout(_ sender: Any) {
        Kinvey.sharedClient.activeUser?.logout()
        FBSDKLoginManager().logOut()
        User.login(username: "Guest", password: "kinvey") { user, error in
            if let _ = user {
                NotificationCenter.default.post(name: Notification.Name("kinveyUserChanged"), object: nil)
                self.dismiss(animated:true, completion: nil)
            }
        }
    }
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sportData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sportData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //selectedSport = sportData[row]
        if let user = Kinvey.sharedClient.activeUser as? AdidasUser {
            user.sport = sportData[row]
            user.save()
        }
    }
}
