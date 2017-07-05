//
//  twitterClient.swift
//  Simple-Twitter-Client
//
//  Created by Nhung on 7/1/17.
//  Copyright © 2017 Nhung. All rights res
//

import Foundation
import BDBOAuth1Manager




class TwitterClient: BDBOAuth1SessionManager {
    
    let endPoint = "https://api.twitter.com"
    let API_REQUEST_TOKEN = "/oauth/request_token"
    let API_AUTHENTICATE_TOKEN = "/oauth/authorize?oauth_token="
    let API_ACCESS_TOKEN = "/oauth/access_token"
    let API_GET_CURRENT_ACCOUNT = "1.1/account/verify_credentials.json"
    let API_GET_STATUS_HOME_TIMELINE = "1.1/statuses/home_timeline.json"
    let API_POST_NEW_STATUS = "1.1/statuses/update.json"
    let API_POST_NEW_FAVORITE = "1.1/favorites/create.json"
    let API_POST_DETROY_FAVORITE = "1.1/favorites/destroy.json"
    
    
    
    
    
    
    var currentUser: User? 
    var loginCompletion: ((_ user: User?, _ error: NSError?) -> ())?
    
    
    
    
    var accessToken: BDBOAuth1RequestSerializer? {
        get {
            
            let defaults = UserDefaults.standard
            
            
            let Token = defaults.object(forKey: "accessToken") as! String
            let TokenSecret = defaults.object(forKey: "accessTokenSecret") as! String
            let TokenVerifier = defaults.object(forKey: "accessTokenIsExpired") as? Bool
            
            if TokenVerifier! {
                return nil
            }else {
                let accessToken = BDBOAuth1Credential.init(token: Token, secret: TokenSecret, expiration: nil)
                TwitterClient.shared?.requestSerializer.saveAccessToken(accessToken)
                return TwitterClient.shared?.requestSerializer
            }
        }
    }
    
    

    
    static let shared = TwitterClient(baseURL: URL(string: "https://api.twitter.com"),
                                      consumerKey: "8oz28LSnePSJquqP5GwRbd7EQ",
                                      consumerSecret: "Z9DubmzYqQMzrjjXCuAzXW9Fo9wjtYVoJYSkq6tXvSC2F7UgvM")
    
    
    func loginSuccess(completion: @escaping (_ user: User?, _ error: NSError?) -> ()) {
        loginCompletion = completion
        TwitterClient.shared?.deauthorize()
        
        TwitterClient.shared?.fetchRequestToken(withPath: API_REQUEST_TOKEN, method: "GET", callbackURL: URL(string: "mytwitter://oauth"), scope: nil, success: { (request: BDBOAuth1Credential?) in
            
            let authURL = URL(string: "\(self.endPoint)\(self.API_AUTHENTICATE_TOKEN)\(request!.token!)")!
            UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
            print("Got the request token\n")
        },failure: { (error: Error?) in
            print(">>> Error getting the request token: \(String(describing: error?.localizedDescription))\n")
            completion(nil, error as NSError?)
            
        })
    }
    
    func getCurrentUser() {
        TwitterClient.shared?.get(API_GET_CURRENT_ACCOUNT, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            TwitterClient.shared?.currentUser = User(dictionary: response as! NSDictionary)
            
            self.loginCompletion!(TwitterClient.shared?.currentUser, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            print("error getting current user")
            self.loginCompletion!(nil, error as NSError?)
            
        })
    }
    
    
    
    // LOG OUT
    func logOut() {
        TwitterClient.shared?.currentUser = nil
        deauthorize()
    }
    
    // MARK: API
    func getHomeTimeline(completion: @escaping ([Tweet]?, Error?) -> ()) {
        TwitterClient.shared?.get(API_GET_STATUS_HOME_TIMELINE, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let tweets = Tweet.tweetWithArray(data: response as! [NSDictionary])
            completion(tweets, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error getting home timeline")
            completion(nil, error)
        })
    }
    
    func updateNewTweet(tweet: String, completion: @escaping (_ response: Any?, _ error: NSError?) -> () ) {
        var params = [String : String]()
        params["status"] = tweet
        TwitterClient.shared?.post(API_POST_NEW_STATUS, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any ) in
            print("update status success")
            completion(response, nil)
        }, failure: { (task: URLSessionDataTask?, error) in
            completion(nil, error as NSError?)
            print("update status fail")
        })
        
    }
    
    func handleFavorite(tweetId: String, isFavorite: Bool, completion: @escaping (_ response: Any?, _ error: NSError?) -> ()) {
        var params = [String : String]()
        params["id"] = tweetId
        
        if isFavorite {
            post(API_POST_NEW_FAVORITE, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Favorited!")
                
            }) { (operation: URLSessionDataTask?, error: Error) in
                print("Favorite error")
            }
        }else {
            post(API_POST_DETROY_FAVORITE, parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Detroy Favorite!")
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("Detroy Favorite error")
            })
        }
        
    }
    
    
    
    
    func handleRetweet(tweetId: String, isRetweet: Bool, completion: @escaping (_ response: Any?, _ error: NSError?) -> ()) {
        var params = [String : String]()
        params["id"] = tweetId
        
        if isRetweet {
            post("1.1/statuses/retweet/\(tweetId).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Retweeded!")
                
            }) { (operation: URLSessionDataTask?, error: Error) in
                print("Retweeded error")
            }
        }else {
            post("1.1/statuses/unretweet/\(tweetId).json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                completion(response, nil)
                print("Detroy Unretweed!")
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("Detroy Unretweed error")
            })
        }
    }
    
    
    
    
    // MARK: handle open URL
    func handleOpenURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.shared?.fetchAccessToken(withPath: API_ACCESS_TOKEN, method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("Got the access token !!!")
            TwitterClient.shared?.requestSerializer.saveAccessToken(accessToken)
            self.getCurrentUser()
            
            
        }, failure: { (error: Error?) in
            print(">>> Error: \(String(describing: error?.localizedDescription))")
            self.loginCompletion!(nil, error as NSError?)
        })
        
    }
    
    
}
