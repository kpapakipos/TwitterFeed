//
//  TimelineViewController.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/22/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit
import SwifteriOS

class TimelineViewController: UITableViewController, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    let myAppModel = (UIApplication.sharedApplication().delegate as! AppDelegate).appModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAppModel.startStream()
    }
}