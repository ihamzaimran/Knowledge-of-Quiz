//
//  Models.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 08/10/2020.
//

import Foundation
import MessageUI

class OpenExternalLinkModel {
    
    //function to open page in social media app if available else open in browser
    internal func openSocialMediaLink(_ socialMediaAppURL: String, _ socialMediaLinkURL: String){
        if let url = URL(string: socialMediaAppURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        if let url = URL(string: socialMediaLinkURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //function to open external links
    internal func openExternalLink(with urlString: String){
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, completionHandler: nil)
        } else {
            print("Error occured! Couldn't open link.")
            return
        }
        
    }

    
    //function to get email app urls
    internal func getEmailAppURL(to: String, subject: String, body: String) -> URL? {
        
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
}
