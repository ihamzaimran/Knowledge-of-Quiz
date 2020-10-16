//
//  DBHelper.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 09/10/2020.
//

import Foundation
import SQLite3

class DBHelper{
    
    let dbName  = "QuizOfKnowledge.sqlite"
    var db:OpaquePointer?
    
    private func getDBPath()->URL{
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbName)
        return fileURL
    }
    
    internal func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let finalDatabaseURL = documentsUrl.appendingPathComponent(dbName)
        
        do {
            if !fileManager.fileExists(atPath: finalDatabaseURL.path) {
                print("DB does not exist in documents folder")
                
                if let dbFilePath = Bundle.main.path(forResource: "QuizOfKnowledge", ofType: "sqlite") {
                    try fileManager.copyItem(atPath: dbFilePath, toPath: finalDatabaseURL.path)
                } else {
                    print("Uh oh - QuizOfKnowledge.sqlite is not in the app bundle")
                }
            } else {
                print("Database file found at path: \(finalDatabaseURL.path)")
            }
        } catch {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error: \(errmsg)")
        }
    }
    
    internal func openDatabase() {
        
        let dbFilePath = getDBPath()
        if sqlite3_open_v2(dbFilePath.path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX | SQLITE_OPEN_CREATE, nil) == SQLITE_OK {
            print("CONNECTION SUCCESSFUL\n")
        } else {
            print("CONNECTION FAILURE")
        }
    }
    
    internal func queryDatabase(with query: String) -> OpaquePointer?{
        var OperationStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &OperationStatement, nil) !=
            SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("preparing  error: \(errmsg)")
        }
        //         sqlite3_finalize(OperationStatement)
        return OperationStatement
    }
    
    internal func updateScore(query: String){
        
        if query == ""{
            return
        }
        
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Score successfully updated!")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("preparing  error: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("preparing  error: \(errmsg)")
            print("Update statement is not prepared!")
        }
        sqlite3_finalize(updateStatement)
    }
    
    internal func closeDatabase() {
        sqlite3_close(db)
        print("Connection close successfully")
    }
}
