//
//  Extensions.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/27/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit

extension String {
    var pictureFromURL: UIImage? {
        if self != "" {
            if let url = NSURL(string: self) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    return image != nil ? image! : nil
                }
            }
        }
        return nil
    }
}