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
    @IBOutlet weak var image1View: UIImageView!
    @IBOutlet weak var image2View: UIImageView!
    @IBOutlet weak var image3View: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func useTweet() {
        profileImageView.image = tweet.profileImage
        usernameLabel.text = tweet.userName
        handleLabel.text = tweet.handle
        mainTextView.text = tweet.text
        image1View.image = tweet.image1
        image2View.image = tweet.image2
        image3View.image = tweet.image3
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
