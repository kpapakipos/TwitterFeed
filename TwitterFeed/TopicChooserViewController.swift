//
//  TopicChooserViewController.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/22/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit
import SwifteriOS

class TopicChooserViewController: UIViewController, UITextFieldDelegate {
    let myAppModel = (UIApplication.sharedApplication().delegate as! AppDelegate).appModel
    
    @IBOutlet weak var topicField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicField.delegate = self
        let backButton = UIBarButtonItem()
        backButton.title = "Topic"
        self.navigationItem.backBarButtonItem = backButton
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
        myAppModel.track = textField.text!
        performSegueWithIdentifier("topicChosenSegue", sender: topicField.text)
        myAppModel.startStream()
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
}