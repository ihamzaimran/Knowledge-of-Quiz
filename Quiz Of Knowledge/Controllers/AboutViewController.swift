//
//  AboutViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 07/10/2020.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var facebookLBL: UILabel!
    @IBOutlet weak var twitterLBL: UILabel!
    @IBOutlet weak var shareLBL: UILabel!
    @IBOutlet weak var rateusLBL: UILabel!
    @IBOutlet weak var feedbackLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var bottomStackViewHeightMultiplie: NSLayoutConstraint!
    @IBOutlet weak var socialMediaHeightMultiplier: NSLayoutConstraint!
    @IBOutlet weak var titleLBLBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialMediaBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewConstraintFromCenterY: NSLayoutConstraint!
    @IBOutlet weak var quizKnowledgeDescriptionLBL: UILabel!
    @IBOutlet weak var bottomStackViewWidthMultiplier: NSLayoutConstraint!
    @IBOutlet weak var socialMediaStackViewWidthMultiplier: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    
    //MARK:- variables
    
    private let externalLinkVC = OpenExternalLinkModel()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setIpadSettings()
        CheckForiPhoneModel()
    }
    
    //MARK:- Functions for changing settings of the views depending on the device
    
    // adjusting settings for ipad for better user experience
    private func setIpadSettings(){
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            
            quizKnowledgeDescriptionLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
            titleLBLBottomConstraint.constant = -50
            buttonBottomConstraint.constant = -50
            socialMediaBottomConstraint.constant = 80
            bottomStackViewConstraintFromCenterY.constant = 250
            titleLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 40)
            facebookLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 20)
            twitterLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 20)
            rateusLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 20)
            shareLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 20)
            feedbackLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 20)
            
        default:
            break
        }
    }
    
    //function to change bottom view width multiplier
    private func changeStackViewMultiplier(height x:CGFloat, width y: CGFloat) {
        let newBottomStackViewHeightConstraint = bottomStackViewHeightMultiplie.constraintWithMultiplier(x)
        let newSocialMediaStackViewHeightConstraint = socialMediaHeightMultiplier.constraintWithMultiplier(x)
        let newBottomStackViewWidthConstraint = bottomStackViewWidthMultiplier.constraintWithMultiplier(y)
        
        var newSocialMediaStackWidthConstraint: NSLayoutConstraint
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            newSocialMediaStackWidthConstraint = socialMediaStackViewWidthMultiplier.constraintWithMultiplier(0.35)
        default:
            newSocialMediaStackWidthConstraint = socialMediaStackViewWidthMultiplier.constraintWithMultiplier(0.5)
        }
        view.removeConstraint(bottomStackViewHeightMultiplie)
        view.removeConstraint(socialMediaHeightMultiplier)
        view.removeConstraint(bottomStackViewWidthMultiplier)
        view.removeConstraint(socialMediaStackViewWidthMultiplier)
        view.addConstraint(newBottomStackViewHeightConstraint)
        view.addConstraint(newSocialMediaStackViewHeightConstraint)
        view.addConstraint(newBottomStackViewWidthConstraint)
        view.addConstraint(newSocialMediaStackWidthConstraint)
        view.layoutIfNeeded()
        bottomStackViewHeightMultiplie = newBottomStackViewHeightConstraint
        socialMediaHeightMultiplier = newSocialMediaStackViewHeightConstraint
        bottomStackViewWidthMultiplier = newBottomStackViewWidthConstraint
        socialMediaStackViewWidthMultiplier = newSocialMediaStackWidthConstraint
    }
    
    //function to check which iPhone model is app running on, so to adjust button heights and widths accordingly.
    private func CheckForiPhoneModel(){
        
        let size = UIScreen.main.bounds.size
        let height = size.height
        if height <= 736 {
            changeStackViewMultiplier(height: 0.15, width: 0.75)
        }
        else if height <= 900 {
            changeStackViewMultiplier(height: 0.14, width: 0.75)
        } else {
            changeStackViewMultiplier(height: 0.14, width: 0.5)
        }
    }
    
    //MARK:- Buttons Pressed Links
    
    @IBAction func facebookButton(_ sender: UIButton) {
        externalLinkVC.openSocialMediaLink(Constants.OpenExternalLinks.facebookApp, Constants.OpenExternalLinks.facebookLink)
    }
    
    @IBAction func twitterButton(_ sender: UIButton) {
        externalLinkVC.openSocialMediaLink(Constants.OpenExternalLinks.twitterApp, Constants.OpenExternalLinks.twitterLink)
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        let shareAll = [Constants.OpenExternalLinks.aboutVCShareButtonDescription]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func rateusButton(_ sender: UIButton) {
        externalLinkVC.openExternalLink(with: Constants.OpenExternalLinks.knowledgeOfQuizAppLink)
    }
    
    @IBAction func feedbackButton(_ sender: UIButton) {
        sendEmail()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- extension MAILMFComposeViewDelegate

extension AboutViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail(){
        
        let email = "feedback@suavesolutions.net"
        let subject = "Comments and Suggestions-Quiz of Knowledge"
        let bodyText = "Via Knowledge of Quiz"
        
        if MFMailComposeViewController.canSendMail(){
            
            let mail = MFMailComposeViewController() //creating a mfmailcomposeviewcontroller object
            mail.mailComposeDelegate = self
            mail.setSubject(subject)
            mail.setToRecipients([email])
            mail.setMessageBody(bodyText, isHTML: false)
            self.present(mail, animated: true, completion: nil)
        } else if let emailURL = externalLinkVC.getEmailAppURL(to: email, subject: subject, body: bodyText) {
            UIApplication.shared.open(emailURL)
        } else {
            print("Error occured! Couldn't send email!")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
