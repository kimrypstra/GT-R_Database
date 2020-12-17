//
//  ProdNumberManager.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 10/12/20.
//

import Foundation

enum ParseMode: String {
    case VIN = "VIN"
    case Production = "Prod"
}

class TSVManager {
    var series: String
    var mode: ParseMode
    
    init(series: String, mode: ParseMode) {
        self.series = series
        self.mode = mode
    }
    
    func getHeaders() -> [String] {
        do {
            let tsvString = try String(contentsOfFile: Bundle.main.path(forResource: "\(series)\(mode.rawValue)", ofType: ".tsv")!)
            let lines = tsvString.components(separatedBy: "\n")
            // lines[0] is the colour codes
            var colourCodes = lines[0].components(separatedBy: "\t")
            colourCodes[colourCodes.count - 1] = colourCodes[colourCodes.count - 1].replacingOccurrences(of: "\r", with: "")
            colourCodes.removeFirst()
            print(colourCodes)
            return colourCodes
        } catch let error {
            print("Error getting colour codes: \(error)")
            return []
        }
    }
    
    func keys() -> [String] {
        var keys: [String] = []
        do {
            let tsvString = try String(contentsOfFile: Bundle.main.path(forResource: "\(series)\(mode.rawValue)", ofType: ".tsv")!)
            let lines = tsvString.components(separatedBy: "\n")
            // lines[0] is the colour codes
            let colourCodes = lines[0].components(separatedBy: "\t")
            var codeIndices: [Int: String] = [:]
            for (index, code) in colourCodes.enumerated() {
                codeIndices[index] = code
            }
            for index in 0...lines.count - 1 {
                let components = lines[index].components(separatedBy: "\t")
                // components[0] is the model
                guard components.count > 0 else {
                    continue
                }
                
                let model = components[0]
                keys.append(model)
            }
        } catch let error {
            print("Error: \(error)")
        }
        return keys
    }
    
    func generateData() -> [String : Any] {
        var prodNumbers: [String : Any] = [:]
        
        do {
            let tsvString = try String(contentsOfFile: Bundle.main.path(forResource: "\(series)\(mode.rawValue)", ofType: ".tsv")!)
            let lines = tsvString.components(separatedBy: "\n")
            // lines[0] is the colour codes
            var colourCodes = lines[0].components(separatedBy: "\t")
            colourCodes[colourCodes.count - 1] = colourCodes[colourCodes.count - 1].replacingOccurrences(of: "\r", with: "")
            //colourCodes
            
            var codeIndices: [Int: String] = [:]
            for (index, code) in colourCodes.enumerated() {
                codeIndices[index] = code
            }
            
            
            for line in 0...lines.count - 1 {
                let components = lines[line].components(separatedBy: "\t")
                // components[0] is the model
                guard components.count > 0 else {
                    print("Components 0")
                    continue
                }
                
                let model = components[0]
                var colourEntries: [String : String] = [:]
                
                for index in 0...components.count - 1 {
                    let value = components[index].replacingOccurrences(of: "\r", with: "")
                    let colourCode = colourCodes[index]
                    colourEntries[colourCode] = "\(value)"
                }
                prodNumbers[model] = colourEntries
            }
            
        } catch let error {
            print("Can't open prod string: \(error)")
        }
        
        return prodNumbers
    }
}
