//
//  ViewController.swift
//  SportShop
//
//  Created by Tejas on 1/25/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Material
import Kinvey

class RootViewController: UITableViewController {

    var feedItems: [FeedItem]?
    
    lazy var feed:DataStore<FeedItem> = {
        return DataStore<FeedItem>.collection(.cache)
    }()
    

    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "adidas_logo.png")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        self.navigationItem.titleView = imageView
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension

        if Kinvey.sharedClient.activeUser == nil {
            User.login(username: "Guest", password: "kinvey") { user, error in
                if let _ = user {
                    self.feed.find { (items, error) in
                        if let items = items {
                            self.feedItems = items
                            self.tableView.reloadData()
                        } else {
                            print ("\(error)")
                        }
                    }
                }
            }
            
        } else {
            feed.find { (items, error) in
                if let items = items {
                    self.feedItems = items
                    self.tableView.reloadData()
                } else {
                    print ("\(error)")
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemCell", for: indexPath) as! FeedItemCell
        cell.item = feedItems?[indexPath.row]
        cell.vc = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let ctrlName = menuControllers[indexPath.row]
//        let viewController = self.storyboard?.instantiateViewController(withIdentifier: ctrlName)
//        let navController = UINavigationController(rootViewController: viewController!)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.drawerController!.transition(to: navController)
//        appDelegate.drawerController!.toggleLeftView()
    }

}
