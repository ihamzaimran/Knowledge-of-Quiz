//
//  QuizBrain.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 13/10/2020.
//

import Foundation
import SQLite3

class QuizBrain {
    
    private var data = [[String:String]]()
    private var totalQuestions = 0
    
    internal func getQuestionsFomSQLite(for id: Int?) {
        if let categoryID = id {
            var mainDict:[String:String] = [:]
            let query = "select * from Question where category_no = \(categoryID)"
            let db = DBHelper()
            db.openDatabase()
            
            let ReturnStatement = db.queryDatabase(with: query)
            
            while sqlite3_step(ReturnStatement) == SQLITE_ROW {
                guard let id = sqlite3_column_text(ReturnStatement, 0) else {fatalError()}
                guard let number = sqlite3_column_text(ReturnStatement, 1) else {fatalError()}
                guard let mode = sqlite3_column_text(ReturnStatement, 2) else {fatalError()}
                guard let question = sqlite3_column_text(ReturnStatement, 3) else {fatalError()}
                guard let answer = sqlite3_column_text(ReturnStatement, 4) else {fatalError()}
                guard let language = sqlite3_column_text(ReturnStatement, 5) else {fatalError()}
                
                let ID = String(cString: id)
                let categoryNo = String(cString: number)
                let modeName = String(cString: mode)
                let questions = String(cString: question)
                let answers = String(cString: answer)
                let lang = String(cString: language)
                
                let allAnswersArray = answers.components(separatedBy: ",")
                let correctAnswer = allAnswersArray[0]
                let answer2 = allAnswersArray[1]
                let answer3 = allAnswersArray[2]
                let answer4 = allAnswersArray[3]
                
                mainDict["qID"] = ID
                mainDict["catgoryNo"] = categoryNo
                mainDict["mode"] = modeName
                mainDict["question"] = questions
                mainDict["allAnswers"] = answers
                mainDict["correctAnswer"] = correctAnswer
                mainDict["answer2"] = answer2
                mainDict["answer3"] = answer3
                mainDict["answer4"] = answer4
                mainDict["language"] = lang
                
                data.append(mainDict)
            }
        }
    }
    
    internal func calculateTotalQuestions()->Int{
        totalQuestions = data.count
        return totalQuestions
    }
    
    internal func getQuestions() -> [[String:String]] {
        
        return data
    }

}
