//
//  ViewController.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/22/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    var username: String?

    @IBOutlet weak var logInButton: TWTRLogInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.logInCompletion = { (session, error) in
            if let unwrappedSession = session {
                self.username = unwrappedSession.userName
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription)
                let alert = UIAlertController(title: "Login Failed",
                    message: "OAuth failed to authenticate user",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "loginSegue" {
            (segue.destinationViewController as! TopicChooserViewController).username = username
        }
    }
}