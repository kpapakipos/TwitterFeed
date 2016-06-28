//
//  TableViewCell.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/27/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    var tweet: Tweet!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var mainTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func useTweet() {
        profileImageView.image = tweet.image
        usernameLabel.text = tweet.userName
        handleLabel.text = tweet.handle
        mainTextView.text = tweet.text
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
