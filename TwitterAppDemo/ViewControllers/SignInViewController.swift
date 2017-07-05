//
//  SignInViewController.swift
//  Simple-Twitter-Client
//
//  Created by Nhung on 7/1/17.
//  Copyright © 2017 Nhung. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
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
    @IBAction func onSignIn(_ sender: UIButton) {
        TwitterClient.shared?.loginSuccess(completion: { (user: User?, error: NSError?) in
            if user != nil {
                TwitterClient.shared?.currentUser = user
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                print("login fail")
            }
            
        })
        
        
    }

}
