//
//  SelectedQuizViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 09/10/2020.
//

import UIKit

class SelectedQuizViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var backButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heartGreen2BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heartGreen1BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heartGreen3BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryTitleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var timeRemainingLBL: UILabel!
    
    //MARK:- variables
    internal var categoryID: Int?
    internal var categoryName: String?
    private var time = 5
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setCategoryTitle()
        setIpadSettings()
        timer()
    }
    
    func timer() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true);
    }
    
    @objc func updateUI(){
        time -= 1
        timeRemainingLBL.text = String(time)
        
        if time == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.resultsStoryboard) as! ResultsViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        
    }
    
    func setCategoryTitle() {
        if let category = categoryName {
            titleLBL.text = category
        }
    }
    
    
    //MARK:- functions to change views settings depending on the device
    
    // adjusting settings for ipad for better user experience
    private func setIpadSettings(){
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            titleLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 30)
            categoryTitleBottomConstraint.constant = 50
            backButtonBottomConstraint.constant = -50
            heartGreen1BottomConstraint.constant = -70
            heartGreen2BottomConstraint.constant = -70
            heartGreen3BottomConstraint.constant = -70
            scoreLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 22)
            timeRemainingLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 22)
        default:
            break
        }
    }
    
    //MARK:- functions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
