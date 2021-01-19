//
//  R34.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 16/11/20.
//

import UIKit

class R34: Car {
    
    // Text in red to describe what the digit represents 
    @objc dynamic let modelNumberDescriptions = [
        "Body", "Engine", "Axle", "Handle", "Base Grade", "Transmission", "Car Model", "Intake", "Destination", "Seating Capacity", "14th Digit", "15th Digit", "16th Digit", "17th Digit", "18th Digit"
    ]
    
    // Descriptor for which model code digit it is
    @objc dynamic let modelCodeDigits = [
        "1",
        "2-3",
        "4",
        "5",
        "6",
        "7",
        "8-10",
        "11",
        "12",
        "13",
        "14",
        "15",
        "16",
        "17",
        "18"
    ]

    // Returns the model code
    @objc override dynamic var modelCode: String {
        var string = ""
        
        for index in 1...15 {
            let val = value(forKey: "Model\(index)") as! String
            if val != "Unknown" {
                string.append(val)
            }
        }
        
        return string
    }
    
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
        var result = dbMan.readVINDataFromDB(tableName: gen, attributesToRetrieve: [], attributeToSearch: "Grade", valueToSearch: Grade, fuzzy: false) as! [R34]
        let count = result.count
        //print(result)
        //result.sort(by: {$0.VIN < $1.VIN})
        
        let reference = result.filter({$0.VIN == self.VIN})
        let index = result.firstIndex(of: reference.first!)! + 1
        
        numberInGrade = "\(index) of \(count)"
    }
    
    private func getColourNumber(gen: String) {
        let dbMan = DBManager()
        var result = dbMan.readVINDataFromDB(tableName: gen, attributesToRetrieve: [], attributeToSearch: "Colour", valueToSearch: self.Colour, fuzzy: false) as! [R34]
        result = result.filter({$0.Grade == Grade})
        let count = result.count
        //print(result)
        //result.sort(by: {$0.VIN < $1.VIN})
        if let reference = result.filter({$0.VIN == self.VIN}).first {
            let index = result.firstIndex(of: reference)! + 1
            numberInColour = "\(index) of \(count)"
        } else {
            numberInColour = "Unknown"
        }
    }
    
    override func getNumbers(generation: String) {
        getColourNumber(gen: generation)
        getGradeNumber(gen: generation)
    }
    
    override class func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
}
