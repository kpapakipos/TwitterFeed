//
//  TimelineViewController.swift
//  TwitterFeed
//
//  Created by Keegan Papakipos on 6/22/16.
//  Copyright © 2016 kpapakipos. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    var username: String?
    var topic: String?
    
    let signatureURL = "https://stream.twitter.com/1.1/statuses/sample.json"
    let signatureMethod = "POST"
    let nonce = TimelineViewController.randomStringWithLength(32)
    let time = String(Int(NSDate().timeIntervalSince1970))

    override func viewDidLoad() {
        super.viewDidLoad()
        showTimeline()
    }
    
    func showTimeline() {
        if let url = NSURL(string: signatureURL) {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = signatureMethod
            request.HTTPBody = "track=\(topic!)".dataUsingEncoding(NSUTF8StringEncoding)
            
            let oAuthSignature = generateOAuthSignature()
            
            var authDict = [String:String]()
            authDict["oauth_consumer_key"] = "2yKU22Au5pK2fYHKEchCeoy49"
            authDict["oauth_nonce"] = nonce
            authDict["oauth_signature"] = oAuthSignature
            authDict["oauth_signature_method"] = "HMAC-SHA1"
            authDict["oauth_timestamp"] = time
            authDict["oauth_token"] = "2212884445-kJuT5u1UqVUqBlS0RwnFaxJSrZmKbCpqvXmPC7O"
            authDict["oauth_version"] = "1.0"
            
            print(authStringFromDict(authDict))
            request.addValue(authStringFromDict(authDict), forHTTPHeaderField: "Authorization")
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            session.dataTaskWithRequest(request).resume()
        }
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        print("received data")
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        print(response)
        if let httpURLResponse = response as? NSHTTPURLResponse {
            if httpURLResponse.statusCode == 200 {
                completionHandler(NSURLSessionResponseDisposition.Allow)
            }
        }
    }
    
    func generateOAuthSignature() -> String {
        var parameterDict = ["track":topic!]
        parameterDict["oauth_consumer_key"] = "2yKU22Au5pK2fYHKEchCeoy49"
        parameterDict["oauth_nonce"] = nonce
        parameterDict["oauth_signature_method"] = "HMAC-SHA1"
        parameterDict["oauth_timestamp"] = time
        parameterDict["oauth_token"] = "2212884445-kJuT5u1UqVUqBlS0RwnFaxJSrZmKbCpqvXmPC7O"
        parameterDict["oauth_version"] = "1.0"
        
        let signatureBaseString = generateSignatureBaseString(signatureMethod, url: signatureURL, parameterString: generateParameterString(parameterDict))
        let consumerSecret = "6wLr8VaMFDBLHqgoc0whkIuqZWvHM6YxVNmjCCxsTKXOFIF5lh"
        let myAccessCodeSecret = "QRvPr2FoIifTe5lSRLNEDAYjeuMLKRT7N63Y6EpFbm26f"
        let signingKey = consumerSecret.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())! + "&" + myAccessCodeSecret.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        return signatureBaseString.hmac(HMACAlgorithm.SHA1, key: signingKey)
    }
    
    func generateSignatureBaseString(method: String, url: String, parameterString: String) -> String {
        var baseString = method.uppercaseString
        baseString += "&"
        baseString += url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        baseString += "&"
        baseString += parameterString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet(charactersInString:"&=\"#%/<>?@\\^`{|}").invertedSet)!
        
        print(baseString)
        return baseString
    }
    
    func authStringFromDict(dict: [String:String]) -> String {
        var DST = "OAUTH "
        for (key, value) in dict.sort({$0.0 < $1.0}) {
            DST += key.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
            DST += "="
            DST += "\""
            DST += value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet(charactersInString:"+&=\"#%/<>?@\\^`{|}").invertedSet)!
            DST += "\""
            DST += ", "
        }
        DST.removeAtIndex(DST.endIndex.predecessor())
        DST.removeAtIndex(DST.endIndex.predecessor())
        
        return DST
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
    
    static func randomStringWithLength (len : Int) -> String {
        
        let letters : String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : String = String()
        
        for _ in Range(0...len) {
            let length = UInt32(letters.characters.count)
            let rand = letters.startIndex.advancedBy(Int(arc4random_uniform(length)))
            randomString.append(letters[rand])
        }
        
        return randomString
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.protectionSpace.host == "stream.twitter.com" {
                completionHandler(
                    NSURLSessionAuthChallengeDisposition.UseCredential,
                    NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
            }
        }
    }
}