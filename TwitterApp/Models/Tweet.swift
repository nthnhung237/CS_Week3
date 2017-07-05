//
//  Tweet.swift
//  Simple-Twitter-Client
//
//  Created by Nhung on 7/1/17.
//  Copyright © 2017 Nhung. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var user: User?
//    var profileImgUrl: NSURL?
    var retweetBy: String?
//    var screenName:String?
//    var profileName: String?
    
    var id_str: String?
    var createdAt: String?
    var text: String?
    
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var isRetweeted = false
    var isFavorited = false
    
    

    
    var retweet: Tweet?
    
    
    
    
    init(data: NSDictionary) {
        if let retweetedStatus = data["retweeted_status"] as? NSDictionary {
            retweetBy = (data.value(forKey: "user") as! NSDictionary).value(forKey: "name") as! String?
            
            
            
            text = retweetedStatus.value(forKey: "text") as! String?
            favoriteCount = (retweetedStatus.value(forKey: "favorite_count") as! Int?)!
            retweetCount = (retweetedStatus.value(forKey: "retweet_count") as! Int?)!
            id_str = retweetedStatus.value(forKey: "id_str") as! String?
            user = User(dictionary: retweetedStatus.value(forKey: "user") as! NSDictionary)
            isRetweeted = true
            
            
//            screenName = user?.screenName
//            profileName = user?.name
//            profileUrl = user?.profileUrl
            
            //            let dateString = retweetedStatus.value(forKey: "created_at") as! String?
            //            let formatter = DateFormatter()
            //            formatter.dateFormat = "EEE MMM d HH:mm::ss Z y"
            //            if let timestampString = dateString {
            //                let sinceDate = formatter.date(from: timestampString)
            //                formatter.dateFormat = "dd/MM/yyyy hh:mm"
            //                createdAt = formatter.string(from: sinceDate!)
            //            }
        }else {
            id_str = data["id_str"] as? String
            text = data["text"] as! String?
            retweetCount = (data["retweet_count"] as? Int) ?? 0
            favoriteCount = (data["favorite_count"] as? Int) ?? 0
            user = User(dictionary: data["user"] as! NSDictionary)
//            profileUrl = user?.profileUrl
//            screenName = user?.screenName
//            profileName = user?.name
            
        }
        
        
        
        
        
        
        isFavorited = data["favorited"] as! Bool
        isRetweeted = data["retweeted"] as! Bool
        let dateString = data["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        
        if let timestampString = dateString {
            let sinceDate = formatter.date(from: timestampString)
            formatter.dateFormat = "dd/MM/yyyy hh:mm"
            createdAt = formatter.string(from: sinceDate!)
        }
    }
    
    class func tweetWithArray(data: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for item in data {
            tweets.append(Tweet(data: item))
        }
        return tweets
    }
}
