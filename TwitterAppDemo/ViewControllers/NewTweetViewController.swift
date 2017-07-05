//
//  NewTweetViewController.swift
//  Simple-Twitter-Client
//
//  Created by Nhung on 7/1/17.
//  Copyright © 2017 Nhung. All rights reserved.
//

import UIKit


class NewTweetViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var newTweetTextField: UITextView!
    
    @IBOutlet weak var tweetButton: UIButton!
    
    
    @IBOutlet weak var countCharacterLabel: UILabel!
    
    var tweetItem: Tweet!
    
    var countCharactor = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTweetTextField.delegate = self as UITextViewDelegate
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func onNewTweet(_ sender: UIButton) {
        TwitterClient.shared?.updateNewTweet(tweet: newTweetTextField.text, completion: { (result, error) in
            if (result != nil) {
               self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
   
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension NewTweetViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if newTweetTextField.text.contains("What's happening?") {
            newTweetTextField.text = ""
            countCharactor = 0
            tweetButton.isEnabled = false
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        countCharactor = newTweetTextField.text.characters.count
        if newTweetTextField.text == "" {
            tweetButton.isEnabled = false
        } else {
            tweetButton.isEnabled = true
        }
        
        if newTweetTextField.text.characters.count >= 140 {
            countCharactor = 140
            tweetButton.isEnabled = false
        }else {
            tweetButton.isEnabled = true
        }
        countCharacterLabel.text = "\(140 - countCharactor)"
        
        
    }
    
}
