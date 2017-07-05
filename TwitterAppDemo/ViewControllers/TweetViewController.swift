//
//  TweetViewController.swift
//  Simple-Twitter-Client
//
//  Created by Nhung on 7/1/17.
//  Copyright © 2017 Nhung. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tweets = [Tweet]()
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        TwitterClient.shared?.getHomeTimeline(completion: { (tweets: [Tweet]?, error: Error?) in
            if let data =  tweets {
                self.tweets = data
            }
            
            self.tableView.reloadData()
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onSignOut(_ sender: UIBarButtonItem) {
        TwitterClient.shared?.logOut()
        NotificationCenter.default.post(name: NSNotification.Name("userDidlogoutNofi"), object: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.shared?.getHomeTimeline(completion: { (tweets: [Tweet]?, error: Error?) in
            if let data =  tweets {
                self.tweets = data
            }
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        })
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            
            let navigation = segue.destination as! UINavigationController
            let destVC = navigation.topViewController as! TweetDetailViewController
            
            
            destVC.tweetItem = tweet
            destVC.delegate = self
        
//            let navigationController = segue.destination as! UINavigationController
//            let newViewController = navigationController.topViewController as! NewTweetViewController
//            newViewController.tweetItem = tweet
            
        }else if segue.identifier == "newID" {
            let navigationController = segue.destination as! UINavigationController
            let newViewController = navigationController.topViewController as! NewTweetViewController
            //newViewController.tweetItem = tweets
        }
    }

}




// MARK: - Table Delegate, DataSource
extension TweetViewController: UITableViewDelegate, UITableViewDataSource, TweetCellDelegate, TweetDetailViewControllerDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweetItem = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func didFinishUpdate() {
        refreshControlAction(refreshControl)
    }
    
    func onRetweet() {
        loadData()
        
    }
    
    func onFavorite() {
        loadData()
    }
    
    func onRetweetTweetDetail() {
        loadData()
    }
    func onFavoriteTweetDetail() {
        loadData()
    }
    
    
}
