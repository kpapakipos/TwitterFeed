//
//  TimelineViewController.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/22/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit
import TwitterKit

class TimelineViewController: TWTRTimelineViewController {
    var username: String?
    var topic: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        showTimeline()
    }
    
    func showTimeline() {
        if let url = NSURL(string: "https://stream.twitter.com/1.1/statuses/filter.json&track=\(topic!)") {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            
            let signatureMethod = request.HTTPMethod
            let signatureURL = "https://stream.twitter.com/1.1/statuses/filter.json"
            var parameterDict = ["track":topic!]
            parameterDict["oauth_consumer_key"] = "2yKU22Au5pK2fYHKEchCeoy49"
            let nonce = randomStringWithLength(42)
            parameterDict["oauth_nonce"] = nonce
            parameterDict["oauth_signature_method"] = "HMAC-SHA1"
            let time = String(Int(NSDate().timeIntervalSince1970))
            parameterDict["oauth_timestamp"] = time
            parameterDict["oauth_token"] = "2212884445-ps9IRD4zBKwKAQEBQDPgTh92RoE9pFdLHkpDaSR"
            parameterDict["oauth_version"] = "1.0"
            let signatureBaseString = generateSignatureBaseString(signatureMethod, url: signatureURL, parameterString: generateParameterString(parameterDict))
            print(signatureBaseString)
            let consumerSecret = "6wLr8VaMFDBLHqgoc0whkIuqZWvHM6YxVNmjCCxsTKXOFIF5lh"
            let myAccessCodeSecret = "Uuf3afgqHDchoBcydOkEyAf3FFFPdItLwyBRynvNSccAF"
            let signingKey = consumerSecret.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())! + "&" + myAccessCodeSecret.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            let oAuthSignature = signatureBaseString.hmac(HMACAlgorithm.SHA1, key: signingKey)
            
            var authDict = [String:String]()
            authDict["oauth_consumer_key"] = "2yKU22Au5pK2fYHKEchCeoy49"
            authDict["oauth_nonce"] = nonce
            authDict["oauth_signature"] = oAuthSignature
            authDict["oauth_signature_method"] = "HMAC-SHA1"
            authDict["oauth_timestamp"] = time
            authDict["oauth_token"] = "2212884445-ps9IRD4zBKwKAQEBQDPgTh92RoE9pFdLHkpDaSR"
            authDict["oauth_version"] = "1.0"
            
            print(authStringFromDict(authDict))
            request.addValue(authStringFromDict(authDict), forHTTPHeaderField: "Authorization")
            
            let session = NSURLSession.sharedSession()
            session.dataTaskWithRequest(request) {
                (data, response, connectionError) -> Void in
                print("data: \(data)")
                print("response: \(response)")
                print("connectionError: \(connectionError)")
            }.resume()
        }
    }
    
    func generateParameterString(dict: [String:String]) -> String {
        var parameterString = ""
        for (key, value) in dict.sort({($0.0).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet()) < ($1.0).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())}) {
            parameterString += key
            parameterString += "="
            parameterString += value
            parameterString += "&"
        }
        parameterString.removeAtIndex(parameterString.endIndex.predecessor())
        
        return parameterString
    }
    
    func generateSignatureBaseString(method: String, url: String, parameterString: String) -> String {
        var baseString = method.uppercaseString
        baseString += "&"
        baseString += url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        baseString += "&"
        baseString += parameterString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet(charactersInString:"&=\"#%/<>?@\\^`{|}").invertedSet)!
        
        return baseString
    }
    
    func authStringFromDict(dict: [String:String]) -> String {
        var DST = "OAUTH "
        for (key, value) in dict {
            DST += key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            DST += "="
            DST += "\""
            DST += value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet(charactersInString:"&=\"#%/<>?@\\^`{|}").invertedSet)!
            DST += "\""
            DST += ", "
        }
        DST.removeAtIndex(DST.endIndex.predecessor())
        DST.removeAtIndex(DST.endIndex.predecessor())
        
        return DST
    }
    
    func randomStringWithLength (len : Int) -> String {
        
        let letters : String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : String = String()
        
        for _ in Range(0...len) {
            let length = UInt32(letters.characters.count)
            let rand = letters.startIndex.advancedBy(Int(arc4random_uniform(length)))
            randomString.append(letters[rand])
        }
        
        return randomString
    }
}