//
//  ResultsViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 12/10/2020.
//

import UIKit

class ResultsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var gameOverLBL: UILabel!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var bottomStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewTopConstraint: NSLayoutConstraint!
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        setIpadSettings()
        CheckForiPhoneModel()
    }
    
    //MARK:- functions to change views settings depending on the device
    
    // adjusting settings for ipad for better user experience
    private func setIpadSettings(){
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            gameOverLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 40)
            scoreLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
            titleBottomConstraint.constant = -50
        default:
            break
        }
    }
    
    //function to change bottom view width multiplier
    private func changeBottomViewheightMultiplier(with height: CGFloat) {
        
        let newConstraint = bottomStackViewHeightConstraint.constraintWithMultiplier(height) 
        view.removeConstraint(bottomStackViewHeightConstraint)
        view.addConstraint(newConstraint)
        view.layoutIfNeeded()
        bottomStackViewHeightConstraint = newConstraint
    }
    
    
    //function to check which iPhone model is app running on, so to adjust button heights and widths accordingly.
    private func CheckForiPhoneModel(){
        
        let size = UIScreen.main.bounds.size
        let height = size.height
        if height <= 736 {
            changeBottomViewheightMultiplier(with: 0.16)
        }
        else if height <= 900 {
            changeBottomViewheightMultiplier(with: 0.14)
        } else {
            changeBottomViewheightMultiplier(with: 0.17)
        }
    }
    
}
