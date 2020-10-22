//
//  SelectedQuizViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 09/10/2020.
//

import UIKit
import SQLite3

class SelectedQuizViewController: UIViewController{
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var backButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryTitleBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var timeRemainingLBL: UILabel!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var questionLBL: UILabel!
    @IBOutlet weak var firstButtonStackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondButtonStackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lifeLine1imageView: UIImageView!
    @IBOutlet weak var lifeLine2imageView: UIImageView!
    @IBOutlet weak var lifeLine3imageView: UIImageView!
    @IBOutlet weak var lifeLine4ImageView: UIImageView!
    @IBOutlet weak var lifeLine5ImageView: UIImageView!
    @IBOutlet weak var lifeLine6ImageView: UIImageView!
    @IBOutlet weak var lifeLineStackViewBottomConstraint: NSLayoutConstraint!
    
    
    //MARK:- variables
    internal var categoryID: Int?
    internal var categoryName: String?
    private var time = 20
    private let quizBrain = QuizBrain()
    private var questionAnswerDictionary = [[String:String]]()
    private var currentQuestion = 0
    private var score = 0
    private var clockTimer:Timer?
    private var consecutiveCount = 0
    private var wrongCount = 0
    private var correntAnswer = 0
    private var wrongAnswer = 0
    private var highestScore = 0
    private var timerCount = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        time = 2
        setCategoryTitle()
        setIpadSettings()
        quizBrain.getQuestionsFomSQLite(for: categoryID)
        questionAnswerDictionary = quizBrain.getQuestions().shuffled()
        updateQuestion()
    }
    
    
    //timer function
    private func timer() {
        
        guard clockTimer == nil else {return}
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer(){
        if clockTimer != nil {
            clockTimer?.invalidate()
            time = 20
            clockTimer = nil
            print("Stop timer fired!")
        }
    }
    
    //function to run on timer
    @objc func updateTimer(){
      
        if time == 1 {
            stopTimer()
            checkButtonPressed()
            currentQuestion += 1
            updateQuestion()
        }
        
        time -= 1
        timeRemainingLBL.text = String(time)
    }
    
    private func checkButtonPressed(){
        wrongCount += 1
        disableLifeLine()
        checkGameOver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        highestScore = quizBrain.getHighestScoreForSelectedCategory(for: categoryID)
        self.navigationController?.removeViewController(ResultsViewController.self)
    }
    
    //getting question from QuizBrain
    private func updateQuestion(){
        
        timer()
        buttonA.buttonShadow()
        buttonB.buttonShadow()
        buttonC.buttonShadow()
        buttonD.buttonShadow()
        buttonA.adjustButtonText()
        buttonB.adjustButtonText()
        buttonC.adjustButtonText()
        buttonD.adjustButtonText()
        buttonA.isUserInteractionEnabled = true
        buttonB.isUserInteractionEnabled = true
        buttonC.isUserInteractionEnabled = true
        buttonD.isUserInteractionEnabled = true
        
        buttonA.tag = 0
        buttonB.tag = 0
        buttonC.tag = 0
        buttonD.tag = 0
        
        if !questionAnswerDictionary.isEmpty {
            if currentQuestion <= questionAnswerDictionary.count - 1 {
                print("Current Question no. \(currentQuestion)")
                questionLBL.text = questionAnswerDictionary[currentQuestion]["question"]
                let answers = questionAnswerDictionary[currentQuestion]["allAnswers"]
                if let ans = answers {
                    var allAnswersArray = ans.components(separatedBy: ",")
                    allAnswersArray = allAnswersArray.shuffled()
                    
                    buttonA.setTitle(allAnswersArray[0], for: .normal)
                    buttonB.setTitle(allAnswersArray[1], for: .normal)
                    buttonC.setTitle(allAnswersArray[2], for: .normal)
                    buttonD.setTitle(allAnswersArray[3], for: .normal)
                    
                    if let correctAns = questionAnswerDictionary[currentQuestion]["correctAnswer"]{
                        
                        switch correctAns{
                        case buttonA.currentTitle:
                            buttonA.tag = 1
                        case buttonB.currentTitle:
                            buttonB.tag = 1
                        case buttonC.currentTitle:
                            buttonC.tag = 1
                        case buttonD.currentTitle:
                            buttonD.tag = 1
                        default:
                            print("Correct Answer not found ?!")
                        }
                    }
                }
            } else {
                goToResultsVC()
            }
        }
    }
    
    //setting category title
    private func setCategoryTitle() {
        if let category = categoryName {
            titleLBL.text = category
        }
    }
    
    private func goToResultsVC(){
        questionAnswerDictionary = []
        stopTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.time = 0
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if #available(iOS 13.0, *) {
                let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.resultsStoryboard) as! ResultsViewController
                newVC.score = self.score
                newVC.categoryID = self.categoryID
                newVC.categoryName = self.categoryName
                newVC.correctAnswer = self.correntAnswer
                newVC.wrongAnswer = self.wrongAnswer
                newVC.highestScore = self.highestScore
                self.navigationController?.pushViewController(newVC, animated: true)
            } else {
                let newVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.resultsStoryboard) as! ResultsViewController
                newVC.score = self.score
                newVC.categoryID = self.categoryID
                newVC.categoryName = self.categoryName
                newVC.correctAnswer = self.correntAnswer
                newVC.wrongAnswer = self.wrongAnswer
                newVC.highestScore = self.highestScore
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        }
    }
    
    
    //MARK:- functions to change views settings depending on the device
    
    // adjusting settings for ipad for better user experience
    private func setIpadSettings(){
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            titleLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 35)
            questionLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
            buttonA.titleLabel?.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 22)
            buttonB.titleLabel?.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 22)
            buttonC.titleLabel?.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 22)
            buttonD.titleLabel?.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 22)
            categoryTitleBottomConstraint.constant = 50
            backButtonBottomConstraint.constant = -50
            lifeLineStackViewBottomConstraint.constant = -70
            firstButtonStackTopConstraint.constant = 75
            secondButtonStackTopConstraint.constant = 50
            scoreLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 22)
            timeRemainingLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 22)
        default:
            break
        }
    }
    
    //MARK:- functions
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        
        buttonA.isUserInteractionEnabled = false
        buttonB.isUserInteractionEnabled = false
        buttonC.isUserInteractionEnabled = false
        buttonD.isUserInteractionEnabled = false
        
        let userAnswer = sender.titleLabel?.text
        if let answer = userAnswer{
            let userGotIt = checkAnswer(answer)
            print("user got it? : \(userGotIt)")
            if !userGotIt {
                stopTimer()
                scoreLBL.text = "Score: \(score)"
                sender.tag = 2
                animateButtons()
                wrongCount += 1
                wrongAnswer += 1
                disableLifeLine()
                checkGameOver()
                print("Wrong Answer = \(wrongCount)")
                print("Try again...")
            }else {
                stopTimer()
                scoreLBL.text = "Score: \(score)"
                sender.tag = 1
                animateButtons()
                consecutiveCount += 1
                correntAnswer += 1
                enableLifeLine()
                checkGameOver()
                print("yayyyyy.....!!!")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                self.currentQuestion += 1
                self.updateQuestion()
            }
        }
    }
    
    
    //func to check if game is over
    private func checkGameOver(){
        if consecutiveCount < 5 {
            if wrongCount >= 3{
                consecutiveCount = 0
                //go to results vc and store data in db and check for higth score etc.
                print("Gameover check")
                goToResultsVC()
            }
        } else if consecutiveCount >= 5 && consecutiveCount < 10 {
            if wrongCount >= 4 {
                consecutiveCount = 5
                //go to results vc and store data in db and check for higth score etc.
                print("Gameover check")
                goToResultsVC()
            }
        } else if consecutiveCount >= 10 && consecutiveCount < 15 {
            if wrongCount >= 5 {
                consecutiveCount = 10
                //go to results vc and store data in db and check for higth score etc.
                print("Gameover check")
                goToResultsVC()
            }
        } else if consecutiveCount >= 15 {
            if wrongCount >= 6 {
                consecutiveCount = 15
                //go to results vc and store data in db and check for higth score etc.
                print("Gameover check")
                goToResultsVC()
            }
        }
    }
    
    //func for animating correct and wrong answer
    private func animateButtons(){
        
        if buttonA.tag == 2 {
            buttonA.animateButtonRedColor()
        }
        else if buttonB.tag == 2 {
            buttonB.animateButtonRedColor()
        }
        else if buttonC.tag == 2 {
            buttonC.animateButtonRedColor()
        }
        else if buttonD.tag == 2 {
            buttonD.animateButtonRedColor()
        }
        
        if buttonA.tag == 1 {
            buttonA.fadeINOut()
        } else if buttonB.tag == 1 {
            buttonB.fadeINOut()
        } else if buttonC.tag == 1 {
            buttonC.fadeINOut()
        } else if buttonD.tag == 1 {
            buttonD.fadeINOut()
        }
    }
    
    //func for checking user answer
    private func checkAnswer(_ userAnswer: String) -> Bool{
        
        if let ans = questionAnswerDictionary[currentQuestion]["correctAnswer"]{
            if userAnswer == ans {
                if time > 15{
                    score += 100
                } else if time > 10{
                    score += 75
                } else if time > 5 {
                    score += 50
                } else {
                    score += 25
                }
                return true
            }
        }
        return false
    }
    
    //func to show lifeLineImageView
    private func enableLifeLine(){
        
        if consecutiveCount == 5{
            if lifeLine2imageView.isHidden == true && lifeLine3imageView.isHidden == true {
                lifeLine2imageView.isHidden = false
            } else if lifeLine3imageView.isHidden == true && lifeLine3imageView.isHidden == false {
                lifeLine3imageView.isHidden = false
            } else {
                lifeLine4ImageView.isHidden = false
            }
        } else if consecutiveCount == 10 {
            if lifeLine2imageView.isHidden == true && lifeLine3imageView.isHidden == true {
                lifeLine2imageView.isHidden = false
            } else if lifeLine3imageView.isHidden == true && lifeLine3imageView.isHidden == false {
                lifeLine3imageView.isHidden = false
            } else if lifeLine2imageView.isHidden == false && lifeLine3imageView.isHidden == false && lifeLine4ImageView.isHidden == true{
                lifeLine4ImageView.isHidden = false
            } else {
                lifeLine5ImageView.isHidden = false
            }
        } else if consecutiveCount == 15 {
            if lifeLine2imageView.isHidden == true && lifeLine3imageView.isHidden == true {
                lifeLine2imageView.isHidden = false
            } else if lifeLine3imageView.isHidden == true && lifeLine3imageView.isHidden == false {
                lifeLine3imageView.isHidden = false
            } else if lifeLine3imageView.isHidden == false && lifeLine4ImageView.isHidden == true{
                lifeLine4ImageView.isHidden = false
            } else if lifeLine5ImageView.isHidden == true && lifeLine4ImageView.isHidden == false && lifeLine3imageView.isHidden == false && lifeLine2imageView.isHidden == false{
                lifeLine5ImageView.isHidden = false
            } else {
                lifeLine6ImageView.isHidden = false
            }
        }
    }
    
    //func for hiding lifeLineImageView
    private func disableLifeLine(){
        
        if consecutiveCount < 5 {
            if wrongCount == 1 {
                consecutiveCount = 0
                lifeLine3imageView.isHidden = true
            } else if wrongCount == 2 {
                consecutiveCount = 0
                lifeLine2imageView.isHidden = true
            } else if wrongCount == 3 {
                consecutiveCount = 0
                lifeLine1imageView.isHidden = true
            }
        } else if consecutiveCount >= 5 && consecutiveCount < 10 {
            if wrongCount == 1 {
                consecutiveCount = 5
                lifeLine4ImageView.isHidden = true
            } else if wrongCount == 2 {
                consecutiveCount = 5
                lifeLine3imageView.isHidden = true
            } else if wrongCount == 3 {
                consecutiveCount = 5
                lifeLine2imageView.isHidden = true
            } else if wrongCount == 4 {
                consecutiveCount = 5
                lifeLine1imageView.isHidden = true
            }
        }  else if consecutiveCount >= 10 && consecutiveCount < 15 {
            if wrongCount == 1 {
                consecutiveCount = 10
                lifeLine5ImageView.isHidden = true
            } else if wrongCount == 2 {
                consecutiveCount = 10
                lifeLine4ImageView.isHidden = true
            } else if wrongCount == 3 {
                consecutiveCount = 10
                lifeLine3imageView.isHidden = true
            } else if wrongCount == 4 {
                consecutiveCount = 10
                lifeLine2imageView.isHidden = true
            } else if wrongCount == 5 {
                consecutiveCount = 10
                lifeLine1imageView.isHidden = true
            }
        } else if consecutiveCount >= 15 {
            if wrongCount == 1 {
                consecutiveCount = 15
                lifeLine6ImageView.isHidden = true
            } else if wrongCount == 2 {
                consecutiveCount = 15
                lifeLine5ImageView.isHidden = true
            } else if wrongCount == 3 {
                consecutiveCount = 15
                lifeLine4ImageView.isHidden = true
            } else if wrongCount == 4 {
                consecutiveCount = 15
                lifeLine3imageView.isHidden = true
            } else if wrongCount == 5 {
                consecutiveCount = 15
                lifeLine2imageView.isHidden = true
            } else if wrongCount == 6 {
                consecutiveCount = 15
                lifeLine1imageView.isHidden = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("Will disappear called.")
        stopTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("did disappear called.")
        stopTimer()
    }
}


//MARK:- UIButton extension to get Shadow Effect
extension UIButton {
    //func for button shadow
    internal func buttonShadow(){
        self.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5.0
    }
    
    //func to adjust button text in button
    internal func adjustButtonText(){
        self.titleLabel?.minimumScaleFactor = 1
        self.titleLabel?.numberOfLines = 4
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    //function for button animation for correct answer
    internal func fadeINOut(){
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.backgroundColor = .green
            self.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            UIView.animate(withDuration: 1.0, delay: 0.1, options: .curveEaseOut, animations: {
                self.backgroundColor = .green
                self.alpha = 1.0
            }) { (finished: Bool) -> Void in
                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
                    self.backgroundColor = .green
                    self.alpha = 0.0
                }) { (finished: Bool)->Void in
                    UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                        self.backgroundColor = .green
                        self.alpha = 1.0
                    }, completion: nil)
                }
            }
        })
    }
    
    //function for animating button on wrong answer
    internal func animateButtonRedColor(){
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            self.backgroundColor = .red
        }
    }
}


