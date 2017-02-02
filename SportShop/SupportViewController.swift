//
//  InStoreViewController.swift
//  SportShop
//
//  Created by Tejas on 1/26/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey
import ObjectMapper
import Realm

class SupportViewController: UIViewController {
    
    lazy var feedbackStore:DataStore<Feedback> = {
        return DataStore<Feedback>.collection(.network)
    }()

    
    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }
    
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var problemText: UITextView!

    @IBAction func onReport(_ sender: Any) {
        if reportBtn.currentTitle == "Report a Problem" {
            reportBtn.setTitle("Submit Report", for: .normal)
            problemText.isHidden = false
        } else if reportBtn.currentTitle == "Submit Report" {
            reportBtn.setTitle("Report a Problem", for: .normal)
            problemText.isHidden = true
            
            let user = Kinvey.sharedClient.activeUser as? AdidasUser
            feedbackStore.save(Feedback(problemText.text, name: user?.firstname, email: user?.email), completionHandler: { (savedReport, error) in
                //saved
                self.showConfirmation()
            })
        }
    }
    
    func showConfirmation () {
        let alert = UIAlertController(title: "Thanks!", message: "Your report has been recorded.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func callSupport(_ sender: Any) {
        UIApplication.shared.open(URL(string: "tel:1-408-555-5555")!)
    }
}

class Feedback: Entity {
    
    var name: String?
    var email: String?
    var desc: String?
    
    override class func collectionName() -> String {
        //return the name of the backend collection corresponding to this entity
        return "Feedback"
    }
    
    init(_ report: String?, name: String?, email: String?) {
        super.init()
        self.desc = report
        self.name = name
        self.email = email
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    //Map properties in your backend collection to the members of this entity
    override func propertyMapping(_ map: Map) {
        //This maps the "_id", "_kmd" and "_acl" properties
        super.propertyMapping(map)
        
        //Each property in your entity should be mapped using the following scheme:
        //<member variable> <- ("<backend property>", map["<backend property>"])
        name <- map["Name"]
        email <- map["Email"]
        desc <- map["Subject"]
    }

}
