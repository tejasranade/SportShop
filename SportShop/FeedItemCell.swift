//
//  FeedItemCell.swift
//  SportShop
//
//  Created by Tejas on 1/26/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import Material
import FBSDKShareKit
import YouTubePlayer
import Kinvey
import ObjectMapper
import Haneke

class FeedItemCell: UITableViewCell {

    var item: FeedItem?
    weak var vc: UIViewController?
    
    lazy var likes:DataStore<Like> = {
        return DataStore<Like>.collection(.network)
    }()

    lazy var reviews:DataStore<Review> = {
        return DataStore<Review>.collection(.network)
    }()

    @IBOutlet weak var favoriteBtn: IconButton!
    @IBOutlet weak var bottombar: UIView!
    @IBOutlet weak var reviewBtn: IconButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    //@IBOutlet var videoPlayer: YouTubePlayerView!

    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var feedImage: UIImageView!
    
    @IBOutlet weak var feedVideo: YouTubePlayerView!
    var review: UITextField?
    
    override func layoutSubviews() {
        if let src = item?.imageSource {
            let suffix = src.components(separatedBy: ".").last
            if  suffix == "jpg" || suffix == "png" {
                loadImage(src)
            }
            else {
                loadVideo(src)
            }
        }
        
        loadBottomBar()
    }
    
    func loadVideo (_ src: String) {
        feedImage.isHidden = true
        feedVideo.isHidden = false
    
        //videoPlayer.loadVideoID(src)

        let myVideoURL = URL(string: src)
        feedVideo.loadVideoURL(myVideoURL!)
    }
    
    func loadImage (_ src: String) {
        feedImage.isHidden = false
        feedVideo.isHidden = true
        
        let url = URL(string: src)
        self.feedImage.hnk_setImage(from: url)
        
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!)
//    
//            if let _ = data{
//                DispatchQueue.main.async {
//                    self.feedImage.image = UIImage(data: data!)
//                }
//            }
//        }
    }

    func loadBottomBar(){
        favoriteBtn.image = Icon.favorite
        favoriteBtn.tintColor = Color.grey.base
        favoriteBtn.addTarget(self, action: #selector(FeedItemCell.onFavTapped(_:)), for: .touchUpInside)
        
        reviewBtn.image = Icon.cm.share
        reviewBtn.tintColor = Color.blueGrey.base
        reviewBtn.addTarget(self, action: #selector(FeedItemCell.onReviewTapped(_:)), for: .touchUpInside)
        
        descLabel.text = item?.desc
        nameLabel.text = item?.name
    }
    
    func onFavTapped (_ sender: Any) {
        if favoriteBtn.tintColor == Color.grey.base {
            favoriteBtn.tintColor = Color.red.base
        } else {
            favoriteBtn.tintColor = Color.grey.base
        }
        let like = Like()
        like.feeditem = item
        likes.save(like, completionHandler: nil)
    }
    
    func onReviewTapped (_ sender: Any){
        let alert = UIAlertController(title: "Review", message: "Add a quick review", preferredStyle: .alert)
        alert.addTextField { (textField) in
            self.review = textField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler:{ (UIAlertAction)in
            let review = Review()
            review.feeditem = self.item
            review.review = self.review?.text
            
            self.reviews.save(review, completionHandler: nil)

        }))
        
        self.vc?.present(alert, animated: true, completion: nil)
    }
}


class Like: Entity {
    var feeditem: FeedItem?
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        feeditem <- map["feeditem"]
    }
    
    override class func collectionName()  -> String {
        return "Likes"
    }
}

class Review: Entity {
    var feeditem: FeedItem?
    var review: String?
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        feeditem <- map["feeditem"]
        review <- map["review"]
    }
    
    override class func collectionName()  -> String {
        return "Reviews"
    }
}
