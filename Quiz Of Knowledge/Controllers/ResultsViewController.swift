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
    @IBOutlet weak var replayLBL: UILabel!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var scoreVCLBL: UILabel!
    @IBOutlet weak var tickLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var crossLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var correctAnswersLBL: UILabel!
    @IBOutlet weak var wrongAnswersLBL: UILabel!
    @IBOutlet weak var newRecordLBL: UILabel!
    @IBOutlet weak var correctAnswersTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var correctAnsConstraint: NSLayoutConstraint!
    
    
    private let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    internal var score: Int?
    internal var categoryID: Int?
    internal var categoryName: String?
    internal var correctAnswer: Int?
    internal var wrongAnswer: Int?
    internal var highestScore: Int?
    private var quizBrain = QuizBrain()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIpadSettings()
        CheckForiPhoneModel()
        checkforHighScore()
//        print("User Score is: \(score)")
        
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
        if let score = score, let highestScore = highestScore, let id = categoryID {
            if score > highestScore {
                updateScoreinSQLite(with: score, for: id)
                gameOverLBL.text = "Congratulations!"
                scoreLBL.text = ("Score is: \(score)")
                newRecordLBL.isHidden = false
                newRecordLBL.fadeINOut()
            } else {
                print("No need to Update Score!")
                gameOverLBL.text = "Game Over!"
                scoreLBL.text = ("Score is: \(score)")
                newRecordLBL.isHidden = true
            }
        }
    }
    
    private func updateScoreinSQLite(with score: Int, for id: Int){
        quizBrain.update(with: score, for: id)
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
            newRecordLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 65)
            wrongAnswersLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 35)
            titleBottomConstraint.constant = -50
            correctAnswersTopConstraint.constant = -200
            tickLeadingConstraint.constant = 200
            crossLeadingConstraint.constant = 200
            correctAnsConstraint.constant = -200
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
            changeBottomViewheightMultiplier(with: 0.13, for: 0.75)
        } else {
            changeBottomViewheightMultiplier(with: 0.14, for: 0.50)
        }
    }
    
    //MARK:- button functions
    
    @IBAction func replayButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.selectedCategoryQuizStoryboard) as! SelectedQuizViewController
            newVC.categoryID = self.categoryID
            newVC.categoryName = self.categoryName
            self.navigationController?.pushViewController(newVC, animated: true)
        } else {
            let newVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.selectedCategoryQuizStoryboard) as! SelectedQuizViewController
            newVC.categoryID = self.categoryID
            newVC.categoryName = self.categoryName
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func scoreButton(_ sender: UIButton) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.scoreVCStoryboard) as! ScoreViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        } else {
            let newVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.scoreVCStoryboard) as! ScoreViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        
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
