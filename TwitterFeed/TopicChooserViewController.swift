//
//  TopicChooserViewController.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/22/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit

class TopicChooserViewController: UIViewController, UITextFieldDelegate {
    var username: String?

    @IBOutlet weak var topicField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicField.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" else {
            let alert = UIAlertController(title: "Empty Topic",
                                          message: "You must enter a topic containing at least one non-whitespace character",
                                          preferredStyle: UIAlertControllerStyle.Alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return true
        }
        performSegueWithIdentifier("topicChosenSegue", sender: topicField.text)
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "topicChosenSegue" {
            (segue.destinationViewController as! TimelineViewController).username = username
            (segue.destinationViewController as! TimelineViewController).topic = sender as? String
        }
    }
}