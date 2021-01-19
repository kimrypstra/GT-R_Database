//
//  Colours.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 13/1/21.
//

import Foundation
import UIKit

class CarColour: NSObject {
    let code: String
    let name: String
    let colour: UIColor
    let lightTextRequired: Bool
    let dbRepresentation: String
    
    init(code: String, name: String, colour: UIColor, lightTextRequired: Bool) {
        self.code = code
        self.name = name
        self.colour = colour
        self.lightTextRequired = lightTextRequired
        self.dbRepresentation = "\(code) - \(name)"
    }
    
    convenience init(dbRepresentation: String) {
        print("Attempting to init with dbRep: \(dbRepresentation)")
        let colourMan = ColourManager()
        if let colour = colourMan.getColourForDBRepresentation(dbRepresentation: dbRepresentation) {
            self.init(code: colour.code, name: colour.name, colour: colour.colour, lightTextRequired: colour.lightTextRequired)
        } else {
            print("No colour found for dbRepresentation: \(dbRepresentation)")
            let col = ColourManager.nilColour
            self.init(code: col.code, name: col.name, colour: col.colour, lightTextRequired: col.lightTextRequired)
        }
    }
}

class ColourManager: NSObject {
    static let nilColour = CarColour(code: "", name: "", colour: UIColor.clear, lightTextRequired: false)
    
    let colours: [CarColour] = [
        CarColour(code: "3W9", name: "Black #?/White#?", colour: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), lightTextRequired: false),
        CarColour(code: "AR2", name: "Active Red", colour: #colorLiteral(red: 0.7122970223, green: 0.0909647271, blue: 0.09065987915, alpha: 1), lightTextRequired: false),
        CarColour(code: "BP9", name: "Dark Blue Pearl", colour: #colorLiteral(red: 0.1680269837, green: 0.242465198, blue: 0.5140451789, alpha: 1), lightTextRequired: false),
        CarColour(code: "BV5", name: "Dark Metal Blue", colour: #colorLiteral(red: 0.110447593, green: 0.1332258582, blue: 0.1943612695, alpha: 1), lightTextRequired: true),
        CarColour(code: "EV1", name: "Lightning Yellow", colour: #colorLiteral(red: 0.9790872931, green: 0.9653491378, blue: 0.1096117571, alpha: 1), lightTextRequired: false),
        CarColour(code: "EY0", name: "Silica Brass", colour: #colorLiteral(red: 0.6497175097, green: 0.5923954248, blue: 0.4221065938, alpha: 1), lightTextRequired: false),
        CarColour(code: "GV1", name: "Black Pearl", colour: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), lightTextRequired: true),
        CarColour(code: "JW0", name: "Millenium Jade", colour: #colorLiteral(red: 0.4005199969, green: 0.4432640374, blue: 0.3480771184, alpha: 1), lightTextRequired: false),
        CarColour(code: "KR4", name: "Sonic Silver", colour: #colorLiteral(red: 0.6942896843, green: 0.7058998942, blue: 0.7098891139, alpha: 1), lightTextRequired: false),
        CarColour(code: "KV2", name: "Athlete Silver", colour: #colorLiteral(red: 0.6193754673, green: 0.6039115787, blue: 0.6284177899, alpha: 1), lightTextRequired: false),
        CarColour(code: "LV4", name: "Midnight Purple II", colour: #colorLiteral(red: 0.2264132202, green: 0.1410844028, blue: 0.2103253305, alpha: 1), lightTextRequired: true),
        CarColour(code: "LX0", name: "Midnight Purple III", colour: #colorLiteral(red: 0.5467392802, green: 0.3606091738, blue: 0.4991256595, alpha: 1), lightTextRequired: true),
        CarColour(code: "QM1", name: "White", colour: #colorLiteral(red: 0.9999478459, green: 1, blue: 0.9998740554, alpha: 1), lightTextRequired: false),
        CarColour(code: "QT1", name: "Pearl White", colour: #colorLiteral(red: 0.9332844615, green: 0.9333672523, blue: 0.9332153201, alpha: 1), lightTextRequired: false),
        CarColour(code: "QX1", name: "Pearl White", colour: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), lightTextRequired: false),
        CarColour(code: "TV2", name: "Bayside Blue", colour: #colorLiteral(red: 0.02124947868, green: 0.1128262952, blue: 0.7996029854, alpha: 1), lightTextRequired: true),
        CarColour(code: "WV2", name: "Sparkling Silver", colour: #colorLiteral(red: 0.5450533628, green: 0.5411676764, blue: 0.5615847111, alpha: 1), lightTextRequired: false)
    ]

    func getColourForDBRepresentation(dbRepresentation: String) -> CarColour? {
        var code = String(dbRepresentation.split(separator: "-").first!)
        code = code.replacingOccurrences(of: " ", with: "")
        return getColourForCode(code: code)
    }
    
    func getColourForCode(code: String) -> CarColour? {
        if let colour = colours.filter({$0.code == code}).first {
            return colour
        } else {
            print("Unknown colour code: \(code)")
            return nil
        }
    }
    
    func getNameForCode(code: String) -> String? {
        if let colour = colours.filter({$0.code == code}).first {
            return colour.name
        } else {
            print("Unknown colour code: \(code)")
            return nil
        }
    }
    
}
