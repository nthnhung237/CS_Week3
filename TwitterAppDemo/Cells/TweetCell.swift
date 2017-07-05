//
//  TweetsCell.swift
//  TwitterClientDemo
//
//  Created by Nhung on 7/1/17.
//  Copyright © 2017 Nhung. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func onRetweet ()
    func onFavorite ()
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var heightAuto: NSLayoutConstraint!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var replyImage: UIImageView!
    
    
    @IBOutlet weak var retweetActionImage: UIButton!
    
    @IBOutlet weak var favoriteActionImage: UIButton!
    
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    var tweetId: String = ""
    var delegate: TweetCellDelegate!
    
    
    var tweetItem: Tweet? {
        didSet {
            
            favoriteCountLabel.text = self.tweetItem?.favoriteCount.description
            retweetCountLabel.text = self.tweetItem?.retweetCount.description
            tweetTextLabel.text = self.tweetItem?.text as String?
            userNameLabel.text = "@\(self.tweetItem!.user!.screenName!)"
            profileLabel.text = self.tweetItem?.user?.name
            tweetId = (tweetItem?.id_str)!
            
            if let retweet = tweetItem!.retweetBy {
                retweetLabel.text = "\(retweet) Retweeted"
                retweetImage.image = #imageLiteral(resourceName: "retweet-action-on")
                heightAuto.constant = CGFloat(20)
            }else {
                heightAuto.constant = CGFloat(0)
            }
            
            let data = try! Data(contentsOf: (tweetItem?.user?.profileImageUrl! as! NSURL) as! URL)
            profileImage.image = UIImage(data: data)
            
            if (tweetItem?.isFavorited)! {
                favoriteActionImage.isSelected = true
            }else {
                favoriteActionImage.isSelected = false
            }
            
            if(tweetItem?.isRetweeted)! {
                retweetActionImage.isSelected = true
            }else {
                retweetActionImage.isSelected = false
            }
            timeLabel.text = tweetItem?.createdAt
        }
        
    }
    @IBAction func onRetweet(_ sender: UIButton) {
        if retweetActionImage.isSelected {
            retweetActionImage.isSelected = false
        }else {
            retweetActionImage.isSelected = true
        }
        TwitterClient.shared?.handleRetweet(tweetId: tweetId, isRetweet: retweetActionImage.isSelected, completion: { (response, error) in
            
                self.delegate.onRetweet()
            
        })
        
    }
    
    @IBAction func onFavorite(_ sender: UIButton) {
        if favoriteActionImage.isSelected {
            favoriteActionImage.isSelected = false
        } else {
            favoriteActionImage.isSelected = true
        }
        
        TwitterClient.shared?.handleFavorite(tweetId: tweetId, isFavorite: favoriteActionImage.isSelected, completion: { (response, error) in
            
                self.delegate.onFavorite()
            
        })
    }
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        retweetActionImage.setImage(#imageLiteral(resourceName: "retweet-action"), for: .normal)
        retweetActionImage.setImage(#imageLiteral(resourceName: "retweet-action-on"), for: .selected)
        favoriteActionImage.setImage(#imageLiteral(resourceName: "like-action-on"), for: .selected)
        favoriteActionImage.setImage(#imageLiteral(resourceName: "like-action"), for: .normal)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
