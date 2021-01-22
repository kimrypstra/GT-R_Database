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
        CarColour(code: "WV2", name: "Sparkling Silver", colour: #colorLiteral(red: 0.5450533628, green: 0.5411676764, blue: 0.5615847111, alpha: 1), lightTextRequired: false),
        CarColour(code: "1N3", name: "Silver #KL0/Grey #KH2", colour: #colorLiteral(red: 0.2817033827, green: 0.415558815, blue: 0.4891158342, alpha: 1), lightTextRequired: false),
        CarColour(code: "1N4", name: "Silver #KL0/Grey #KM1", colour: #colorLiteral(red: 0.7218230367, green: 0.7333028316, blue: 0.7700868845, alpha: 1), lightTextRequired: false),
        CarColour(code: "2R8", name: "White #QM1/Black #KH3", colour: #colorLiteral(red: 0.9019135237, green: 0.9019936919, blue: 0.9018464684, alpha: 1), lightTextRequired: false),
        CarColour(code: "AN0", name: "Super Clear Red", colour: #colorLiteral(red: 0.4365019798, green: 0.2039727271, blue: 0.2366291285, alpha: 1), lightTextRequired: false),
        CarColour(code: "AR1", name: "Super Clear red II", colour: #colorLiteral(red: 0.4475283623, green: 0.05518782884, blue: 0.1158859655, alpha: 1), lightTextRequired: false),
        CarColour(code: "BN6", name: "Deep Marine Blue", colour: #colorLiteral(red: 0.1023396328, green: 0.1096676663, blue: 0.1829155385, alpha: 1), lightTextRequired: false),
        CarColour(code: "BT2", name: "Chamption Blue", colour: #colorLiteral(red: 0.0871996358, green: 0.2933940589, blue: 0.5894206762, alpha: 1), lightTextRequired: false),
        CarColour(code: "DN0", name: "Green Metallic", colour: #colorLiteral(red: 0.4327161014, green: 0.5058917403, blue: 0.501704514, alpha: 1), lightTextRequired: false),
        CarColour(code: "KH2", name: "Gun Grey Metallic", colour: #colorLiteral(red: 0.231338948, green: 0.2313939631, blue: 0.2231310904, alpha: 1), lightTextRequired: false),
        CarColour(code: "KH3", name: "Black", colour: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), lightTextRequired: false),
        CarColour(code: "KL0", name: "Spark Silver Metallic", colour: #colorLiteral(red: 0.6273975968, green: 0.6274861693, blue: 0.619166553, alpha: 1), lightTextRequired: false),
        CarColour(code: "KN6", name: "Dark Grey Pearl", colour: #colorLiteral(red: 0.1723573506, green: 0.1607885957, blue: 0.1648578942, alpha: 1), lightTextRequired: false),
        CarColour(code: "LP2", name: "Midnight Purple", colour: #colorLiteral(red: 0.2145657539, green: 0.1175275669, blue: 0.1988671124, alpha: 1), lightTextRequired: false),
        CarColour(code: "WK1", name: "Silky Snow Pearl", colour: #colorLiteral(red: 0.9293631911, green: 0.9294455647, blue: 0.9292942286, alpha: 1), lightTextRequired: false),
        CarColour(code: "326", name: "Crystal White", colour: #colorLiteral(red: 0.9803410172, green: 0.9804276824, blue: 0.980268538, alpha: 1), lightTextRequired: false),
        CarColour(code: "691", name: "White #625/Black #505", colour: #colorLiteral(red: 0.9921050668, green: 0.9921928048, blue: 0.9920318723, alpha: 1), lightTextRequired: false),
        CarColour(code: "732", name: "Black Pearl Metallic", colour: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), lightTextRequired: false),
        CarColour(code: "2M8", name: "White #326/Black #KH3", colour: #colorLiteral(red: 0.9685769677, green: 0.9686626792, blue: 0.9685052037, alpha: 1), lightTextRequired: false),
        CarColour(code: "AH3", name: "Red Pearl Metallic", colour: #colorLiteral(red: 0.5020172596, green: 0.06323806196, blue: 0.05073405057, alpha: 1), lightTextRequired: false),
        CarColour(code: "BJ0", name: "Light Blue Metallic", colour: #colorLiteral(red: 0.6366808414, green: 0.6978898644, blue: 0.8000714183, alpha: 1), lightTextRequired: false),
        CarColour(code: "BL0", name: "Greyish Blue Pearl", colour: #colorLiteral(red: 0.4093336463, green: 0.470410049, blue: 0.5806432366, alpha: 1), lightTextRequired: false),
        CarColour(code: "DH0", name: "Dark Green Metallic", colour: #colorLiteral(red: 0.3005988896, green: 0.4195825756, blue: 0.4318272471, alpha: 1), lightTextRequired: false),
        CarColour(code: "DH3", name: "Greenish Silver", colour: #colorLiteral(red: 0.6237468123, green: 0.6352849603, blue: 0.6556916833, alpha: 1), lightTextRequired: false),
        CarColour(code: "JK0", name: "Yellowish Green Metallic", colour: #colorLiteral(red: 0.6275568604, green: 0.6392714381, blue: 0.6145037413, alpha: 1), lightTextRequired: false),
        CarColour(code: "KG1", name: "Jet Silver Metallic", colour: #colorLiteral(red: 0.6014562845, green: 0.6704840064, blue: 0.7440865636, alpha: 1), lightTextRequired: false),
        CarColour(code: "KH6", name: "Pearl White", colour: #colorLiteral(red: 0.9097562432, green: 0.9098370671, blue: 0.9096887112, alpha: 1), lightTextRequired: false),
        CarColour(code: "KJ1", name: "Yellowish Silver", colour: #colorLiteral(red: 0.7532973886, green: 0.7725368142, blue: 0.7970253825, alpha: 1), lightTextRequired: false),
        CarColour(code: "TG0", name: "Light Grey Metallic", colour: #colorLiteral(red: 0.6755274534, green: 0.7214580774, blue: 0.8032326102, alpha: 1), lightTextRequired: false),
        CarColour(code: "TH1", name: "Dark Blue Pearl", colour: #colorLiteral(red: 0.09935035557, green: 0.1330476999, blue: 0.2629569471, alpha: 1), lightTextRequired: false)
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
