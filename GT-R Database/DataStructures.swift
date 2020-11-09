//
//  DataStructures.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 1/11/20.
//

import Foundation

class R34: NSObject {
    @objc dynamic var ID: String = "_"
    @objc dynamic var VIN: String = "_"
    @objc dynamic var Grade: String = "_"
    @objc dynamic var Series: String = "_"
    @objc dynamic var Colour: String = "_"
    @objc dynamic var ColourPath: String = "_"
    @objc dynamic var ProductionDate: String = "_"
    @objc dynamic var Plant: String = "_"
    @objc dynamic var Seat: String = "_"
    @objc dynamic var Model1: String = "_"
    @objc dynamic var Model2: String = "_"
    @objc dynamic var Model3: String = "_"
    @objc dynamic var Model4: String = "_"
    @objc dynamic var Model5: String = "_"
    @objc dynamic var Model6: String = "_"
    @objc dynamic var Model7: String = "_"
    @objc dynamic var Model8: String = "_"
    @objc dynamic var Model9: String = "_"
    @objc dynamic var Model10: String = "_"
    @objc dynamic var Model11: String = "_"
    @objc dynamic var Model12: String = "_"
    @objc dynamic var Model13: String = "_"
    @objc dynamic var Model14: String = "_"
    @objc dynamic var Model15: String = "_"
    @objc dynamic var VINRanges: String = "_"
    @objc dynamic var prodNumbers: String = "_"
    @objc dynamic var numberInColour: String = "_"
    @objc dynamic var numberInGrade: String = "_"
    
    private func getGradeNumber() {
        let dbMan = DBManager()
        var result = dbMan.readVINDataFromDB(tableName: "R34", attributesToRetrieve: [], attributeToSearch: "Grade", valueToSearch: Grade, fuzzy: false)
        let count = result.count
        //print(result)
        //result.sort(by: {$0.VIN < $1.VIN})
        let reference = result.filter({$0.VIN == self.VIN})
        let index = result.firstIndex(of: reference.first!)! + 1
        
        numberInGrade = "\(index) of \(count)"
    }
    
     private func getColourNumber() {
        let dbMan = DBManager()
        var result = dbMan.readVINDataFromDB(tableName: "R34", attributesToRetrieve: [], attributeToSearch: "Colour", valueToSearch: Colour, fuzzy: false)
        result = result.filter({$0.Grade == Grade})
        let count = result.count
        //print(result)
        //result.sort(by: {$0.VIN < $1.VIN})
        let reference = result.filter({$0.VIN == self.VIN})
        let index = result.firstIndex(of: reference.first!)! + 1
        
        numberInColour = "\(index) of \(count)"
    }
    
    func getNumbers() {
        getColourNumber()
        getGradeNumber()
    }
    
    override class func value(forUndefinedKey key: String) -> Any? {
        return nil 
    }
    
    @objc dynamic var modelCode: String {
        return "\(Model1)\(Model2)\(Model3)\(Model4)\(Model5)\(Model6)\(Model7)\(Model8)\(Model9)\(Model10)\(Model11)\(Model12)\(Model13)\(Model14)\(Model15)"
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

//struct modelNumberStartColumn {
//    static let r34: Int32 = 8
//}
//
//struct modelNumberOffset {
//    static let bodyType: Int32 = 0
//    static let engine: Int32 = 1
//    static let drive: Int32 = 2
//    static let driverSide: Int32 = 3
//    static let grade: Int32 = 4
//    static let gearbox: Int32 = 5
//    static let generation: Int32 = 6
//    static let aspiration: Int32 = 7
//    static let coldWeather: Int32 = 8
//    static let seatCapacity: Int32 = 9
//    static let superFineHardCoat: Int32 = 10
//    static let glass: Int32 = 11
//    static let trim: Int32 = 12
//    static let stereo: Int32 = 13
//    static let safety: Int32 = 14
//}
