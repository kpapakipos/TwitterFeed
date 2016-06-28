//
//  AppModel.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/27/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit
import SwifteriOS

class AppModel: NSObject {
    var swifter: Swifter = Swifter(consumerKey: "RErEmzj7ijDkJr60ayE2gjSHT", consumerSecret: "SbS0CHk11oJdALARa7NDik0nty4pXvAxdt7aj0R5y1gNzWaNEx")
    var track = "puppy"
    var tweets = [Tweet]() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("newTweetNotification", object: self)
        }
    }
    private var connection: SwifterHTTPRequest? = nil
    
    func startStream() {
        guard connection == nil else { return } // connected already!
        self.tweets = [Tweet]()
        connection = swifter.postStatusesFilterWithFollow(nil, track: [track], locations: nil, delimited: nil, stallWarnings: nil, filter_level: nil, language: nil, progress: {
            (status: Dictionary<String, JSONValue>?) in
            
            print("Status: \(status)")
            
            if let json: [String:JSON] = status {
                if json["text"]?.string != nil {
                    self.tweets.insert(Tweet(userName: json["text"]?.string, text: json["text"]?.string), atIndex: 0)
                }
            }
            
            }, stallWarningHandler: {
                code, message, percentFull in
                print("Stall: \(code), \(message), \(percentFull)")
            }, failure: {
                error in
                print("Error: \(error.localizedDescription)")
        })
    }
    
    func stopStream() {
        connection?.stop() // close old Stream connection (if any)
        connection = nil
    }
}