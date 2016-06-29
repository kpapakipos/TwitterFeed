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
    var profileImage: UIImage
    var image1: UIImage
    var image2: UIImage
    var image3: UIImage
    
    init(userName: String?, handle: String?, text: String?, profileImageURL: String?, image1URL: String?, image2URL: String?, image3URL: String?) {
        self.userName = userName != nil ? userName! : ""
        self.handle = handle != nil ? "@\(handle!)" : ""
        self.text = text != nil ? text! : ""
        self.profileImage = profileImageURL?.pictureFromURL != nil ? profileImageURL!.pictureFromURL! : UIImage()
        self.image1 = image1URL?.pictureFromURL != nil ? image1URL!.pictureFromURL! : UIImage()
        self.image2 = image2URL?.pictureFromURL != nil ? image2URL!.pictureFromURL! : UIImage()
        self.image3 = image3URL?.pictureFromURL != nil ? image3URL!.pictureFromURL! : UIImage()
    }
}