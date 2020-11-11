//
//  DataStructures.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 1/11/20.
//

import Foundation

class Car: NSObject {
    
    // It's critical that this is in the same order as the SQL Columns
    
    @objc dynamic var ID: String = "Unknown"
    @objc dynamic var VIN: String = "Unknown"
    @objc dynamic var Grade: String = "Unknown"
    @objc dynamic var Series: String = "Unknown"
    @objc dynamic var Colour: String = "Unknown"
    @objc dynamic var ColourPath: String = "Unknown" 
    @objc dynamic var ProductionDate: String = "Unknown"
    @objc dynamic var Plant: String = "Unknown"
    @objc dynamic var Seat: String = "Unknown"
    
    @objc dynamic var Model1: String = "Unknown"
    @objc dynamic var DescriptionModel1D: String = "Unknown"

    @objc dynamic var Model2: String = "Unknown"
    @objc dynamic var DescriptionModel2D: String = "Unknown"

    @objc dynamic var Model3: String = "Unknown"
    @objc dynamic var DescriptionModel3D: String = "Unknown"

    @objc dynamic var Model4: String = "Unknown"
    @objc dynamic var DescriptionModel4D: String = "Unknown"

    @objc dynamic var Model5: String = "Unknown"
    @objc dynamic var DescriptionModel5D: String = "Unknown"

    @objc dynamic var Model6: String = "Unknown"
    @objc dynamic var DescriptionModel6D: String = "Unknown"

    @objc dynamic var Model7: String = "Unknown"
    @objc dynamic var DescriptionModel7D: String = "Unknown"

    @objc dynamic var Model8: String = "Unknown"
    @objc dynamic var DescriptionModel8D: String = "Unknown"

    @objc dynamic var Model9: String = "Unknown"
    @objc dynamic var DescriptionModel9D: String = "Unknown"

    @objc dynamic var Model10: String = "Unknown"
    @objc dynamic var DescriptionModel10D: String = "Unknown"

    @objc dynamic var Model11: String = "Unknown"
    @objc dynamic var DescriptionModel11D: String = "Unknown"

    @objc dynamic var Model12: String = "Unknown"
    @objc dynamic var DescriptionModel12D: String = "Unknown"

    @objc dynamic var Model13: String = "Unknown"
    @objc dynamic var DescriptionModel13D: String = "Unknown"

    @objc dynamic var Model14: String = "Unknown"
    @objc dynamic var DescriptionModel14D: String = "Unknown"

    @objc dynamic var Model15: String = "Unknown"
    @objc dynamic var DescriptionModel15D: String = "Unknown"
    
    @objc dynamic var VINRanges: String = "Unknown"
    @objc dynamic var prodNumbers: String = "Unknown"
    @objc dynamic var numberInColour: String = "Unknown"
    @objc dynamic var numberInGrade: String = "Unknown"
    @objc dynamic var interiorCode: String = "Unknown"
    
    private func getGradeNumber(gen: String) {
        let dbMan = DBManager()
        var result = dbMan.readVINDataFromDB(tableName: gen, attributesToRetrieve: [], attributeToSearch: "Grade", valueToSearch: Grade, fuzzy: false)
        let count = result.count
        //print(result)
        //result.sort(by: {$0.VIN < $1.VIN})
        let reference = result.filter({$0.VIN == self.VIN})
        let index = result.firstIndex(of: reference.first!)! + 1
        
        numberInGrade = "\(index) of \(count)"
    }
    
    private func getColourNumber(gen: String) {
        let dbMan = DBManager()
        var result = dbMan.readVINDataFromDB(tableName: gen, attributesToRetrieve: [], attributeToSearch: "Colour", valueToSearch: Colour, fuzzy: false)
        result = result.filter({$0.Grade == Grade})
        let count = result.count
        //print(result)
        //result.sort(by: {$0.VIN < $1.VIN})
        let reference = result.filter({$0.VIN == self.VIN})
        let index = result.firstIndex(of: reference.first!)! + 1
        
        numberInColour = "\(index) of \(count)"
    }
    
    func getNumbers(generation: String) {
        getColourNumber(gen: generation)
        getGradeNumber(gen: generation)
    }
    
    override class func value(forUndefinedKey key: String) -> Any? {
        return nil 
    }
    
    @objc dynamic var modelCode: String {
        var string = ""
        
        for index in 1...15 {
            let val = value(forKey: "Model\(index)") as! String
            if val != "Unknown" {
                string.append(val)
            }
        }
        
        return string
    }
    
    override var description: String {
        var returnString = ""
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            returnString.append("\(child.label!): \(child.value)\n")
        }
        return returnString
    }
    
}




