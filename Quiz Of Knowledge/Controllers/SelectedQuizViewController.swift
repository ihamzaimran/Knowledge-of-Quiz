//
//  SelectedQuizViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 09/10/2020.
//

import UIKit
import SQLite3

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
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var questionLBL: UILabel!
    @IBOutlet weak var firstButtonStackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondButtonStackTopConstraint: NSLayoutConstraint!
    
    //MARK:- variables
    internal var categoryID: Int?
    internal var categoryName: String?
    private var time = 10
    private let quizBrain = QuizBrain()
    private var questionAnswerDictionary = [[String:String]]()
    private var currentQuestion = 0
    private var numbers: [Int] = []
    private var questionAnswered = false
    private var score = 0
    private var clockTimer = Timer()
    
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
        timer()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //timer function
    private func timer() {
        self.clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true);
    }
    
    //getting question from QuizBrain
    private func updateQuestion(){
        time = 10
        buttonA.buttonShadow()
        buttonB.buttonShadow()
        buttonC.buttonShadow()
        buttonD.buttonShadow()
        buttonA.adjustButtonText()
        buttonB.adjustButtonText()
        buttonC.adjustButtonText()
        buttonD.adjustButtonText()
        
        buttonA.tag = 0
        buttonB.tag = 0
        buttonC.tag = 0
        buttonD.tag = 0
        
        if !questionAnswerDictionary.isEmpty {
            if currentQuestion <= questionAnswerDictionary.count - 1{
                
                questionLBL.text = questionAnswerDictionary[currentQuestion]["question"]
                let answers = questionAnswerDictionary[currentQuestion]["allAnswers"]
                if let ans = answers {
                    var allAnswersArray = ans.components(separatedBy: ",")
                    allAnswersArray = allAnswersArray.shuffled()
                    
                    buttonA.setTitle(allAnswersArray[0], for: .normal)
                    buttonB.setTitle(allAnswersArray[1], for: .normal)
                    buttonC.setTitle(allAnswersArray[2], for: .normal)
                    buttonD.setTitle(allAnswersArray[3], for: .normal)
                }
            } else {
                print("No more Questions.")
            }
        }
    }
    
    //function to run on timer
    @objc func updateTimer(){
        time -= 1
        timeRemainingLBL.text = String(time)
        if time == 1 {
            currentQuestion += 1
            timeRemainingLBL.text = String(time)
            updateQuestion()
        }
        if currentQuestion > 19 {
            clockTimer.invalidate()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(identifier: Constants.StoryboardIDs.resultsStoryboard) as! ResultsViewController
            newVC.score = score
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    //setting category title
    private func setCategoryTitle() {
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
            titleLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 35)
            questionLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
            categoryTitleBottomConstraint.constant = 50
            backButtonBottomConstraint.constant = -50
            heartGreen1BottomConstraint.constant = -70
            heartGreen2BottomConstraint.constant = -70
            heartGreen3BottomConstraint.constant = -70
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
        
        questionAnswered = true
        
        let userAnswer = sender.titleLabel?.text
        if let answer = userAnswer{
            let userGotIt = checkAnswer(answer)
            print("user got it? : \(userGotIt)")
            if !userGotIt {
                sender.tag = 0
                animateButtons()
                print("Try again...")
            }else {
                sender.tag = 1
                animateButtons()
                print("yayyyyy.....!!!")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.currentQuestion += 1
                self.updateQuestion()
            }
        }
    }
    
    private func animateButtons(){
        
        if buttonA.tag == 1 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.buttonA.backgroundColor = .green
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.buttonA.backgroundColor = .red
            }
        }
        if buttonB.tag == 1 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.buttonB.backgroundColor = .green
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.buttonB .backgroundColor = .red
            }
        }
        if buttonC.tag == 1 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.buttonC.backgroundColor = .green
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.buttonC .backgroundColor = .red
            }
        }
        if buttonD.tag == 1 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.buttonD.backgroundColor = .green
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.buttonD.backgroundColor = .red
            }
        }
    }
    
    private func checkAnswer(_ userAnswer: String) -> Bool{
        
        if (userAnswer == questionAnswerDictionary[currentQuestion]["correctAnswer"]){
            score += 1;
            return true;
        }
        return false;
    }
    
}


//MARK:- UIButton extension to get Shadow Effect
extension UIButton {
    func buttonShadow(){
        self.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5.0
    }
    
    func adjustButtonText(){
        self.titleLabel?.minimumScaleFactor = 0.65
        self.titleLabel?.numberOfLines = 4
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}
