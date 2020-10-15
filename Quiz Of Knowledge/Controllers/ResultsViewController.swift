//
//  ResultsViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 12/10/2020.
//

import UIKit

class ResultsViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var gameOverLBL: UILabel!
    @IBOutlet weak var titleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var bottomStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var replayLBL: UILabel!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var scoreVCLBL: UILabel!
    @IBOutlet weak var tickLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var crossLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var correctAnswersLBL: UILabel!
    @IBOutlet weak var wrongAnswersLBL: UILabel!
    
    private let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    internal var score: Int?
    internal var categoryID: Int?
    internal var categoryName: String?
    internal var correctAnswer: Int?
    internal var wrongAnswer: Int?
    internal var highestScore: Int?
    @IBOutlet weak var newRecordLBL: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIpadSettings()
        CheckForiPhoneModel()
        checkforHighScore()
        
        if let correct = correctAnswer, let wrong = wrongAnswer {
            correctAnswersLBL.text = "Correct Answers: \(correct)"
            wrongAnswersLBL.text = "Wrong Answers: \(wrong)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.removeViewController(SelectedQuizViewController.self)
        self.navigationController?.removeViewController(GameRulesViewController.self)
        self.navigationController?.removeViewController(QuizViewController.self)
    }
    
    private func checkforHighScore(){
        if let score = score, let highestScore = highestScore{
            if score > highestScore {
                gameOverLBL.text = "Congratulations!"
                scoreLBL.text = ("Score is: \(score)")
                newRecordLBL.isHidden = false
                newRecordLBL.fadeINOut()
            } else {
                gameOverLBL.text = "Game Over!"
                scoreLBL.text = ("Score is: \(score)")
                newRecordLBL.isHidden = true
            }
            
        }
    }
    
    //MARK:- functions to change views settings depending on the device
    
    // adjusting settings for ipad for better user experience
    private func setIpadSettings(){
        
        switch (deviceIdiom) {
        case .pad:
            gameOverLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 40)
            scoreLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 30)
            scoreVCLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
            homeLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
            replayLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
            correctAnswersLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 35)
            wrongAnswersLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 35)
            titleBottomConstraint.constant = -50
//            bottomStackViewTopConstraint.constant = 150
            tickLeadingConstraint.constant = 200
            crossLeadingConstraint.constant = 200
        default:
            break
        }
    }
    
    //function to change bottom view width multiplier
    private func changeBottomViewheightMultiplier(with height: CGFloat, for width: CGFloat) {
        
        let newHeightConstraint = bottomStackViewHeightConstraint.constraintWithMultiplier(height)
        switch (deviceIdiom) {
        case .pad:
            let newWidthConstraint = bottomStackViewWidthConstraint.constraintWithMultiplier(width)
            view.removeConstraint(bottomStackViewWidthConstraint)
            view.addConstraint(newWidthConstraint)
            view.layoutIfNeeded()
            bottomStackViewWidthConstraint = newWidthConstraint
        default:
            break
        }
        
        view.removeConstraint(bottomStackViewHeightConstraint)
        view.addConstraint(newHeightConstraint)
        view.layoutIfNeeded()
        bottomStackViewHeightConstraint = newHeightConstraint
    }
    
    
    //function to check which iPhone model is app running on, so to adjust button heights and widths accordingly.
    private func CheckForiPhoneModel(){
        
        let size = UIScreen.main.bounds.size
        let height = size.height
        if height <= 736 {
            changeBottomViewheightMultiplier(with: 0.15, for: 0.75)
        }
        else if height <= 900 {
            changeBottomViewheightMultiplier(with: 0.12, for: 0.75)
        } else {
            changeBottomViewheightMultiplier(with: 0.14, for: 0.50)
        }
    }
    
    //MARK:- button functions
    
    @IBAction func replayButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.selectedCategoryQuizStoryboard) as! SelectedQuizViewController
        newVC.categoryID = self.categoryID
        newVC.categoryName = self.categoryName
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func scoreButton(_ sender: UIButton) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.scoreVCStoryboard) as! ScoreViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}


//MARK:- extension for removing view controller

extension UINavigationController {

    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
            print("View Controller Successfully removed!")
        } else {
            print("View Controller not found!")
        }
    }
}


//MARK:- extension to fadeIN/Out new record label

extension UILabel {
    //function for button animation for correct answer
    internal func fadeINOut(){
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseOut, animations: {
                self.alpha = 1.0
            }) { (finished: Bool) -> Void in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
                    self.alpha = 0.0
                }) { (finished: Bool)->Void in
                    UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                        self.alpha = 1.0
                    }, completion: nil)
                }
            }
        })
    }
}
