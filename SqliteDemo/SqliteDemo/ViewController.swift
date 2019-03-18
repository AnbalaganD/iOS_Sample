//
//  ViewController.swift
//  SqliteDemo
//
//  Created by Admin on 20/03/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    let dataBaseName = "Student.sqlite"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileUrl = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dataBaseName)
        
        var db: OpaquePointer?
        
        if sqlite3_open(fileUrl.path, &db) == SQLITE_OK {
            print("Database open successfully....")
        } else {
            print("Error to open database!!!")
        }
        
        //Create Table
        let createTableString = "CREATE TABLE IF NOT EXISTS Student (Id INTEGER PRIMARY KEY, Name TEXT, Age INTEGER)"
        var createTableStatement: OpaquePointer?
    
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Student table created....")
            } else {
                print("Student table could not be created!!!")
            }
        } else {
            print("Create statement could not prepared!!!")
        }
        sqlite3_finalize(createTableStatement)
        
        //Insert Data into table
        let insertStatementString = "INSERT INTO Student (Id, Name, Age) VALUES (?, ?, ?)"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let id:Int32 = 1
            let name: NSString = "Anbalagan D"
            let age:Int32 = 23
            
            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, age)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                 print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
             print("Insert statement could not prepared!!!")
        }
        sqlite3_finalize(insertStatement)
        
        //SEELCT
        let selectStatementString = "SELECT * FROM Student"
        var selectStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, selectStatementString, -1, &selectStatement, nil) == SQLITE_OK {
            if sqlite3_step(selectStatement) == SQLITE_ROW {
                
                let id = sqlite3_column_int(selectStatement, 0)
                let name = String(cString: sqlite3_column_text(selectStatement, 1))
                let age = sqlite3_column_int(selectStatement, 2)
                
                print("Selected row : \(id) \t \(name) \t \(age)")
                
            } else {
                print("Could not select row.")
            }
        } else {
            print("Select statement could not prepared!!!")
        }
        sqlite3_finalize(selectStatement)
        
        //DELETE
        let deleteStatementString = "DELETE FROM Student WHERE Id = ?"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            
            let id: Int32 = 1
            
            sqlite3_bind_int(deleteStatement, 1, id)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                 print("Row deleted successfully.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("Delete statement could not prepared!!!")
        }
        sqlite3_finalize(deleteStatement)
        sqlite3_close(db)
    }
}

extension ViewController {
    func setupUI() {
        
    }
}
