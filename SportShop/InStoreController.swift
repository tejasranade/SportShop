//
//  InStoreController.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class InStoreController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeDetails: UILabel!
    
    var products: [Product]?
    
    @IBOutlet weak var tableView:UITableView!
    
    lazy var productStore:DataStore<Product> = {
        return DataStore<Product>.collection(.cache)
    }()

    
    lazy var checkins:DataStore<Checkin> = {
        return DataStore<Checkin>.collection(.cache)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeName.text = "Gallery Place"
        storeDetails.text = "Our signature store in Boston at the historic Faneuil Hall."
        
        self.tableView.isHidden = true
        
        let query = Query(format: "category == %@", "shoes")
        
        productStore.find (query) { (items, error) in
            if let items = items {
                self.products = items
                self.tableView.reloadData()
            } else {
                print ("\(error)")
            }
        }
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }

    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }
    
    @IBAction func onCheckin(_ sender: Any) {
        if let switchBtn = sender as? UISwitch {
            if switchBtn.isOn {
            
                let checkin = Checkin(Store("1", name:storeName.text!, desc: storeDetails.text!), time: Date())
                checkins.save(checkin) { (savedCheckin, error) in
                    print("\(savedCheckin)")
                }
            }
            self.tableView.isHidden = !switchBtn.isOn
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.product = products?[indexPath.row]
        return cell
        
    }

}
