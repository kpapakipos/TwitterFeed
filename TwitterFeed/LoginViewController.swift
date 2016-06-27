//
//  ViewController.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/22/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit
import SwifteriOS
import Accounts

class LoginViewController: UIViewController {
    
    let useACAccount = true
    let myAppModel = (UIApplication.sharedApplication().delegate as! AppDelegate).appModel
    
    @IBAction func didTouchUpInsideLoginButton(sender: AnyObject) {
        let failureHandler: ((NSError) -> Void) = {
            error in
            print("Error: \(error.localizedDescription)")
        }
        
        if useACAccount {
            let accountStore = ACAccountStore()
            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            
            // Prompt the user for permission to their twitter account stored in the phone's settings
            accountStore.requestAccessToAccountsWithType(accountType, options: nil) {
                granted, error in
                
                if granted {
                    let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                    
                    if twitterAccounts?.count == 0
                    {
                        print("Error: There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                    }
                    else {
                        let twitterAccount = twitterAccounts[0] as! ACAccount
                        self.myAppModel.swifter = Swifter(account: twitterAccount)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("loginSegue", sender: nil)
                        }
                    }
                }
                else {
                    self.myAppModel.swifter.authorizeWithCallbackURL(NSURL(string: "swifter://success")!, presentFromViewController: self, success: {
                        accessToken, response in
                        dispatch_async(dispatch_get_main_queue()) {
                            self.performSegueWithIdentifier("loginSegue", sender: nil)
                        }
                        
                        },failure: failureHandler
                    )
                    /*dispatch_async(dispatch_get_main_queue()) {
                        let alert = UIAlertController(title: "Error", message: "Authorize TwitterFeed to use your Twitter account in Settings", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }*/
                }
            }
        }
        else {
            myAppModel.swifter.authorizeWithCallbackURL(NSURL(string: "TwitterFeed://success")!, presentFromViewController: self, success: {
                accessToken, response in
                self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                },failure: failureHandler
            )
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
}