//
//  Tweet.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/27/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var userName: String
    var handle: String
    var text: String
    var image: UIImage
    
    init(userName: String?, handle: String?, text: String?, imageURL: String?) {
        self.userName = userName != nil ? userName! : ""
        self.handle = handle != nil ? "@\(handle!)" : ""
        self.text = text != nil ? text! : ""
        self.image = imageURL?.pictureFromURL != nil ? imageURL!.pictureFromURL! : UIImage()
    }
}