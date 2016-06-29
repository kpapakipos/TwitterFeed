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
            //would like to call this less frequently when the live stream is fast to save performance
            NSNotificationCenter.defaultCenter().postNotificationName("newTweetNotification", object: self)
        }
    }
    private var connection: SwifterHTTPRequest? = nil
    
    func startStream() {
        guard connection == nil else { return } // connected already!
        self.tweets = [Tweet]()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.connection = self.swifter.postStatusesFilterWithFollow(nil, track: [self.track], locations: nil, delimited: nil, stallWarnings: nil, filter_level: nil, language: nil, progress: {
                (status: Dictionary<String, JSON>?) in
                
                print("Status: \(status)")
                
                if let json: [String:JSON] = status {
                    if json["text"]?.string != nil { //check that it's a tweet
                        dispatch_async(dispatch_get_main_queue()) {
                            var image1URL: String? = nil
                            var image2URL: String? = nil
                            var image3URL: String? = nil
                            if let mediaArray = json["extended_entities"]?["media"].array {
                                for media in mediaArray {
                                    if media["type"].string == "photo" {
                                        if image1URL == nil {
                                            image1URL = media["media_url_https"].string
                                        }
                                        else if image2URL == nil {
                                            image2URL = media["media_url_https"].string
                                        }
                                        else if image3URL == nil {
                                            image3URL = media["media_url_https"].string
                                        }
                                    }
                                }
                            }
                            self.tweets.insert(Tweet(userName: json["user"]?["name"].string, handle: json["user"]?["screen_name"].string, text: json["text"]?.string, profileImageURL: json["user"]?["profile_image_url"].string, image1URL: image1URL, image2URL: image2URL, image3URL: image3URL), atIndex: 0)
                            if self.tweets.count > 200 {
                                self.tweets.removeLast() //prevent memory leak
                            }
                        }
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
    }
    
    func stopStream() {
        connection?.stop() // close old Stream connection (if any)
        connection = nil
    }
}