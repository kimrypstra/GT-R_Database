//
//  R32.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 16/11/20.
//

import UIKit

class R32: Car {
    
    // Text in red to describe what the value actually is
    @objc dynamic let modelNumberDescriptions = [
        "Body",
        "Engine",
        "Drive",
        "Car Model",
        "Doors",
        "Base Grade",
        "Transmission",
        "Intake",
        "11th Digit",
        "12th Digit",
        "13th Digit",
        "14th Digit"
    ]
    
    @objc dynamic let modelCodeDigits = [
        "1",
        "2",
        "3",
        "4-6",
        "7",
        "8",
        "9",
        "10",
        "11",
        "12",
        "13",
        "14"
    ]

    // Returns the model code without any "_"
    @objc override dynamic var modelCode: String {
        var string = ""
        
        for index in 1...12 {
            let val = value(forKey: "Model\(index)") as! String
            if val != "Unknown" && val != "_" {
                string.append(val)
            }
        }
        
        return string
    }
    
//    @objc override dynamic var ExtendedModelCode: String {
//        var string = ""
//        
//        for index in 1...12 {
//            let val = value(forKey: "Model\(index)") as! String
//            if val != "Unknown" {
//                string.append(val)
//            }
//        }
//        
//        return string
//    }
    
    // Value that comes out with a print()
    override var description: String {
        var returnString = ""
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            returnString.append("\(child.label!): \(child.value)\n")
        }
        return returnString
    }
    
    private func getGradeNumber(gen: String) {
        let dbMan = DBManager()
        var result = dbMan.readVINDataFromDB(tableName: gen, attributesToRetrieve: [], attributeToSearch: "Grade", valueToSearch: Grade, fuzzy: false) as! [R32]
        let count = result.count
        //print(result)
        //result.sort(by: {$0.VIN < $1.VIN})
        
        let reference = result.filter({$0.VIN == self.VIN})
        let index = result.firstIndex(of: reference.first!)! + 1
        
        numberInGrade = "\(index) of \(count)"
    }
    
    private func getColourNumber(gen: String) {
        let dbMan = DBManager()
        var result = dbMan.readVINDataFromDB(tableName: gen, attributesToRetrieve: [], attributeToSearch: "Colour", valueToSearch: Colour, fuzzy: false) as! [R32]
        result = result.filter({$0.Grade == Grade})
        let count = result.count
        //print(result)
        //result.sort(by: {$0.VIN < $1.VIN})
        let reference = result.filter({$0.VIN == self.VIN})
        let index = result.firstIndex(of: reference.first!)! + 1
        
        numberInColour = "\(index) of \(count)"
    }
    
    
    override func getNumbers(generation: String) {
        getColourNumber(gen: generation)
        getGradeNumber(gen: generation)
    }
 
    
    override class func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
}
