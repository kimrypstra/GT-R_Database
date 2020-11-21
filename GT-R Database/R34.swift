//
//  R34.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 16/11/20.
//

import UIKit

class R34: Car {
    /*
    // It's essential that these variables are named according to the database column names
    @objc dynamic var ID: String = "Unknown"
    @objc dynamic var VIN: String = "Unknown"
    @objc dynamic var Grade: String = "Unknown"
    @objc dynamic var Series: String = "Unknown"
    @objc dynamic var Colour: String = "Unknown"
    @objc dynamic var ColourPath: String = "Unknown"
    @objc dynamic var ProductionDate: String = "Unknown"
    @objc dynamic var Plant: String = "Unknown"
    @objc dynamic var interiorCode: String = "Unknown"
    @objc dynamic var VINRanges: String = "Unknown"
    @objc dynamic var prodNumbers: String = "Unknown"
    @objc dynamic var numberInColour: String = "Unknown"
    @objc dynamic var numberInGrade: String = "Unknown"
    @objc dynamic var extendedModelCode: String = "Unknown"
    
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
    
 */
    
    // Text in red to describe what the value actually is
    let modelNumberDescriptions = [
        "Body", "Engine", "Axle", "Car Model", "Doors", "Base Grade", "Transmission", "Fuel System", "Headlights", "Stereo and AC", "Rear Window", "Wiper/Police"
    ]
    
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
        
        for index in 1...12 {
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
        var result = dbMan.readVINDataFromDB(tableName: gen, attributesToRetrieve: [], attributeToSearch: "Colour", valueToSearch: Colour, fuzzy: false) as! [R34]
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
