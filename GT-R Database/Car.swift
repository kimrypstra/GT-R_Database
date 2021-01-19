//
//  DataStructures.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 1/11/20.
//

import Foundation

class Car: NSObject {
    
    // It's critical that these names have the same names as the SQL Columns
    // If not we would need to write a map to convert

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
    @objc dynamic var Readable1: String = "Unknown"

    @objc dynamic var Model2: String = "Unknown"
    @objc dynamic var Readable2: String = "Unknown"

    @objc dynamic var Model3: String = "Unknown"
    @objc dynamic var Readable3: String = "Unknown"

    @objc dynamic var Model4: String = "Unknown"
    @objc dynamic var Readable4: String = "Unknown"

    @objc dynamic var Model5: String = "Unknown"
    @objc dynamic var Readable5: String = "Unknown"

    @objc dynamic var Model6: String = "Unknown"
    @objc dynamic var Readable6: String = "Unknown"

    @objc dynamic var Model7: String = "Unknown"
    @objc dynamic var Readable7: String = "Unknown"

    @objc dynamic var Model8: String = "Unknown"
    @objc dynamic var Readable8: String = "Unknown"

    @objc dynamic var Model9: String = "Unknown"
    @objc dynamic var Readable9: String = "Unknown"

    @objc dynamic var Model10: String = "Unknown"
    @objc dynamic var Readable10: String = "Unknown"

    @objc dynamic var Model11: String = "Unknown"
    @objc dynamic var Readable11: String = "Unknown"

    @objc dynamic var Model12: String = "Unknown"
    @objc dynamic var Readable12: String = "Unknown"

    @objc dynamic var Model13: String = "Unknown"
    @objc dynamic var Readable13: String = "Unknown"

    @objc dynamic var Model14: String = "Unknown"
    @objc dynamic var Readable14: String = "Unknown"

    @objc dynamic var Model15: String = "Unknown"
    @objc dynamic var Readable15: String = "Unknown"
    
    @objc dynamic var VINRanges: String = "Unknown"
    @objc dynamic var prodNumbers: String = "Unknown"
    @objc dynamic var numberInColour: String = "Unknown"
    @objc dynamic var numberInGrade: String = "Unknown"
    @objc dynamic var InteriorCode: String = "Unknown"
    @objc dynamic var extendedModelCode: String = "Unknown"
    
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
    
    func modelSubstringIdentifier(for series: String, at index: Int) -> String {
        switch series {
        case "R32":
            return r32identifiers[index]
        case "R33":
            return r33identifiers[index]
        case "R34":
            return r34identifiers[index]
        default:
            return "Unknown Identifier"
        }
    }
    
    private let r32identifiers = [
        "Body", "Engine", "Axle", "Car Model", "Doors", "Base Grade", "Transmission", "Fuel System", "Headlights", "Stereo and AC", "Rear Window", "Wiper/Police"
    ]
    
    private let r33identifiers = [
        "Body", "Engine", "Axle", "Handle", "Base Grade", "Transmission", "Car Model", "Intake", "Destination", "Seating Capacity", "Paint", "Rear Window", "Spec", "Stereo", "Safety"
    ]
    
    private let r34identifiers = [
        "Body", "Engine", "Axle", "Handle", "Drive", "Grade", "Transmission", "Car Model", "Fuel System", "UNKNOWN", "Seating Capacity", "UNKNOWN", "Spec", "Stereo", "Unknown"
    ]
    
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
        // Gets which car this is in all cars of that colour in this generation
        let dbMan = DBManager()
        var result = dbMan.readVINDataFromDB(tableName: gen, attributesToRetrieve: [], attributeToSearch: "Colour", valueToSearch: Colour, fuzzy: false)
        result = result.filter({$0.Grade == Grade})
        let count = result.count
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
}




