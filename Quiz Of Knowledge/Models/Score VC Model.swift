//
//  Score VC Model.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 16/10/2020.
//

import Foundation
import SQLite3

class ScoreVCModel {
    
    private var scoreData = [[String:String]]()
    private let db = DBHelper()
    
    internal func getScoreFomSQLite()->[[String:String]] {
        
        var mainDict:[String:String] = [:]
        let query = "select * from Score"
        db.openDatabase()
        let ReturnStatement = db.queryDatabase(with: query)
        
        while sqlite3_step(ReturnStatement) == SQLITE_ROW {
            guard let id = sqlite3_column_text(ReturnStatement, 0) else {fatalError()}
            guard let mode = sqlite3_column_text(ReturnStatement, 1) else {fatalError()}
            guard let score = sqlite3_column_text(ReturnStatement, 2) else {fatalError()}
            guard let categoryNo = sqlite3_column_text(ReturnStatement, 3) else {fatalError()}
            guard let categoryName = sqlite3_column_text(ReturnStatement, 4) else {fatalError()}
            guard let language = sqlite3_column_text(ReturnStatement, 5) else {fatalError()}
            
            let ID = String(cString: id)
            let category_no = String(cString: categoryNo)
            let modeName = String(cString: mode)
            let score_language = String(cString: language)
            let category_name = String(cString: categoryName)
            let scores = String(cString: score)
            
            
            mainDict["ID"] = ID
            mainDict["catgoryNo"] = category_no
            mainDict["mode"] = modeName
            mainDict["name"] = category_name
            mainDict["score"] = scores
            mainDict["language"] = score_language
            
            scoreData.append(mainDict)
        }
        sqlite3_finalize(ReturnStatement)
        db.closeDatabase()
        return scoreData
    }
}

