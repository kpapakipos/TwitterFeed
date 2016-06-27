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
    var swifter = Swifter(consumerKey: "RErEmzj7ijDkJr60ayE2gjSHT", consumerSecret: "SbS0CHk11oJdALARa7NDik0nty4pXvAxdt7aj0R5y1gNzWaNEx")
    var track = "puppy"
    
    func startStream() {
        swifter.getUserStreamDelimited(nil, stallWarnings: nil, includeMessagesFromUserOnly: false, includeReplies: true, track: [track], locations: nil, stringifyFriendIDs: nil, filter_level: nil, language: nil, progress: {
            (status: Dictionary<String, JSONValue>?) in
            
            print("Status: \(status)")
            
            }, stallWarningHandler: {
                code, message, percentFull in
                print("Stall: \(code), \(message), \(percentFull)")
            }, failure: {
                error in
                print("Error: \(error.localizedDescription)")
        })
    }
}