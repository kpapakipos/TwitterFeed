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
    var text: String
    var image: UIImage
    
    init(userName: String?, text: String?, imageURL: String?) {
        self.userName = userName != nil ? userName! : ""
        self.text = text != nil ? text! : ""
        self.image = imageURL?.pictureFromURL != nil ? imageURL!.pictureFromURL! : UIImage()
    }
}