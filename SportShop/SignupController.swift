//
//  SignupController.swift
//  SportShop
//
//  Created by Tejas on 1/28/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class SignupController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var rePassword: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    //var imagePicker: UIImagePickerController!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    var selectedSport: String?

    var sportData: [String] = ["Basketball", "Tennis", "Football", "Soccer", "Baseball", "Hockey"]
    
    @IBAction func signup(_ sender: Any) {
        if let un = emailField.text,
            let pwd = password.text,
            let name = nameField.text,
            let lastname = lastnameField.text,
            password.text == rePassword.text {
            
            let user = AdidasUser()
            user.sport = selectedSport
            user.firstname = name
            user.lastname = lastname
                
            User.signup(username: un, password: pwd, user:user, completionHandler: { (user, error) in
                if let _ = user {
                    NotificationCenter.default.post(name: Notification.Name("kinveyUserChanged"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            print("Invalid inputs.")
        }        
        
    }
    
    @IBAction func continueAsGuest(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        selectedSport = sportData[row]
    }
}
