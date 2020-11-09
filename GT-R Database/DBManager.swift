//
//  DBManager.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 5/11/20.
//

import Foundation
import SQLite3
import UIKit

class DBManager {
    var db: OpaquePointer?
    let nameOfDB = "GTRRegistry"
    
    func readVINDataFromDB(tableName: String, attributesToRetrieve: [String], attributeToSearch: String, valueToSearch: String, fuzzy: Bool) -> [R34] {
        
        if db == nil {
            openDB()
        }
        
        var attributesSubstring = ""
        var fuzzySubstring = "IS"
        var fuzzyWildcard = ""
        
        if fuzzy {
            fuzzySubstring = "LIKE"
            fuzzyWildcard = "%"
        }
        
        if attributesToRetrieve.count == 0 {
            attributesSubstring = "*"
        } else {
            for (index, attribute) in attributesToRetrieve.enumerated() {
                attributesSubstring.append(attribute)
                if index < attributesToRetrieve.count - 1 {
                    attributesSubstring.append(", ")
                }
            }
        }
        
        //this is our select query
        let readQueryString = "SELECT \(attributesSubstring) FROM \(tableName) WHERE \(attributeToSearch)  \(fuzzySubstring) '\(fuzzyWildcard)\(valueToSearch)\(fuzzyWildcard)'"
        
        //statement pointer
        var readstmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, readQueryString, -1, &readstmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing read: \(errmsg)")
            return []
        }
        
        //ID, VIN, Grade, Series, Colour, ProductionDate, Plant, Seat, ModelNumber
        //traversing through all the records
        
        var returnArray: [R34] = []
        
        while(sqlite3_step(readstmt) == SQLITE_ROW){
            // TODO: Do the full database, and implement the additional columns. And add tolerance for nil values
            let car = R34()
            
            var varIndex: [String] = []
            let mirror = Mirror(reflecting: car)
            for child in mirror.children {
                varIndex.append(child.label!)
            }
            
            let columnCount: Int32 = Int32(varIndex.count - 1)
            
            for column in 0...columnCount {
                if sqlite3_column_type(readstmt, column) != SQLITE_NULL {
                    let value = String(cString: sqlite3_column_text(readstmt, column))
                    car.setValue(value, forKey: varIndex[Int(column)])
                }
            }
            
            returnArray.append(car)
            //print("ID: \(id), VIN: \(vin), GRADE: \(grade), SERIES: \(series), COLOUR: \(colour), PRODDATE: \(prodDate), PLANT: \(plant), SEAT: \(seat), MODELNUM: \(modelNumber)")
        }
        
        return returnArray
    }
    
    func insertDataIntoTable(tableName: String, parameterNames: [String], parameterValues: [String]) {
        // ID,VIN,Grade,Series,Colour,,Production Date,Plant,Seat,ModelNumber
        //print("Parameter names: \(parameterNames) Parameter values: \(parameterValues)")
        var parameterNamesSubstring = ""
        var placeHolderSubstring = ""
        for (index, name) in parameterNames.enumerated() {
            parameterNamesSubstring.append("'\(name)'")
            placeHolderSubstring.append("?")
            if index < parameterNames.count - 1 {
                parameterNamesSubstring.append(", ")
                placeHolderSubstring.append(", ")
            }
        }
    
        let insertStatementString = "INSERT INTO \(tableName) (\(parameterNamesSubstring)) VALUES (\(placeHolderSubstring));"
        //print(insertStatementString)
        
        var insertStatement: OpaquePointer?
        // 1
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            for (index, value) in parameterValues.enumerated() {
                sqlite3_bind_text(insertStatement, Int32(index + 1), NSString(string: value).utf8String, -1, nil)
            }

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                //print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nINSERT statement is not prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
        
        //displaying a success message
        //print("Success?")
        
    }
    
    func addTableToDB(nameOfTable: String, parameters: [String]) {
        var parameterNamesSubstring = ""
        for (index, parameter) in parameters.enumerated() {
            
            parameterNamesSubstring.append("'\(parameter)' TEXT")
            if index == 0 {
                parameterNamesSubstring.append(" PRIMARY KEY")
            }
            if index < parameters.count - 1 {
                parameterNamesSubstring.append(", ")
            }
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS \(nameOfTable) (\(parameterNamesSubstring))", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        } else {
            //outputTextField.stringValue = "Table added"
        }
    }
    
    func openDB() -> Bool {
        let urlString = "\(Bundle.main.path(forResource: nameOfDB, ofType: "sqlite")!)"
        guard let fileURL: URL? = URL(fileURLWithPath: urlString) else {
            print("Can't open, fileURL mangled: \(urlString)")
            return false
        }
        if sqlite3_open(fileURL?.path, &db) != SQLITE_OK {
            print("Error opening database")
            return false
        } else {
            return true 
        }
    }
    
    func setUpDBFile(nameOfDB: String) {
        do {
            
            let pathString = "\(Bundle.main.bundlePath)\(nameOfDB).sqlite"
            //print(pathString)
            let fileURL = URL(string: pathString)
            FileManager.default.createFile(atPath: pathString, contents: "".data(using: .utf8), attributes: nil)
            
            if sqlite3_open(fileURL!.path, &db) != SQLITE_OK {
                print("Error opening database")
            } else {
                //outputTextField.stringValue = "Database created"
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        
    }
}
