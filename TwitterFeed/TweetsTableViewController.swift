//
//  TimelineViewController.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/22/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit
import SwifteriOS

class TweetsTableViewController: UITableViewController {
    let myAppModel = (UIApplication.sharedApplication().delegate as! AppDelegate).appModel
    var isDragging = false
    var beforeContentSize: CGSize!
    var afterContentSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadTable), name: "newTweetNotification", object: nil)
        beforeContentSize = tableView.contentSize
        afterContentSize = tableView.contentSize
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        myAppModel.stopStream()
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isDragging = true
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        isDragging = false
    }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAppModel.tweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetTableViewCell
        cell.tweet = myAppModel.tweets[indexPath.row]
        
        cell.useTweet()
        
        return cell
    }
    
    func reloadTable() { //FIXME: loading a large number of tweets quickly causes some serious performance issues
        guard !isDragging else {
            return
        }
        beforeContentSize = tableView.contentSize
        tableView?.reloadData()
        afterContentSize = CGSize(width: beforeContentSize.width, height: beforeContentSize.height + 100)
        if tableView.contentOffset == CGPoint(x: 0, y: -64.0) { //if user is at the top of the table, keep them there
            self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0)
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0)
        }
            //FIXME: once we get to 200 tweets we start removing old ones, which causes this to not keep the user stationary
        else { //if user is not at top, scroll down as new tweets are added at the top
            let afterContentOffset = tableView.contentOffset
            tableView.contentOffset = CGPointMake(afterContentOffset.x, afterContentOffset.y + afterContentSize.height - beforeContentSize.height)
        }
    }
}