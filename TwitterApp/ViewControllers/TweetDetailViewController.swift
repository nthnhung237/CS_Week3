//
//  TweetDetailViewController.swift
//  Simple-Twitter-Client
//
//  Created by Nhung on 7/1/17.
//  Copyright © 2017 Nhung. All rights reserved.
//

import UIKit


protocol TweetDetailViewControllerDelegate {
    func onRetweetTweetDetail ()
    func onFavoriteTweetDetail ()
}

class TweetDetailViewController: UIViewController {
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
    var tweetId = ""
    var delegate: TweetCellDelegate!
    
    var tweetItem: Tweet!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retweetActionImage.setImage(#imageLiteral(resourceName: "retweet-action"), for: .normal)
        retweetActionImage.setImage(#imageLiteral(resourceName: "retweet-action-on"), for: .selected)
        favoriteActionImage.setImage(#imageLiteral(resourceName: "like-action-on"), for: .selected)
        favoriteActionImage.setImage(#imageLiteral(resourceName: "like-action"), for: .normal)
        favoriteCountLabel.text = tweetItem?.favoriteCount.description
        retweetCountLabel.text = tweetItem?.retweetCount.description
        tweetTextLabel.text = tweetItem?.text as String?
        userNameLabel.text = "@\(tweetItem!.user!.screenName!)"
        profileLabel.text = tweetItem?.user?.name
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onRetweet(_ sender: UIButton) {
        if retweetActionImage.isSelected {
            retweetActionImage.isSelected = false
            retweetCountLabel.text = "\(tweetItem.retweetCount - 1)"
            tweetItem.retweetCount -= 1
        }else {
            retweetActionImage.isSelected = true
            retweetCountLabel.text = "\(tweetItem.retweetCount + 1)"
            tweetItem.retweetCount += 1
        }
        TwitterClient.shared?.handleRetweet(tweetId: tweetId, isRetweet: retweetActionImage.isSelected, completion: { (response, error) in

                self.delegate.onRetweet()

        })
        
    }
    
    @IBAction func onFavorite(_ sender: UIButton) {
        if favoriteActionImage.isSelected {
            favoriteActionImage.isSelected = false
            favoriteCountLabel.text = "\(tweetItem.favoriteCount - 1)"
            tweetItem.favoriteCount -= 1
        } else {
            favoriteActionImage.isSelected = true
            favoriteCountLabel.text = "\(tweetItem.favoriteCount + 1)"
            tweetItem.favoriteCount += 1
        }
        
        TwitterClient.shared?.handleFavorite(tweetId: tweetId, isFavorite: favoriteActionImage.isSelected, completion: { (response, error) in

                self.delegate.onFavorite()

        })
    }
    
    @IBAction func onBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
