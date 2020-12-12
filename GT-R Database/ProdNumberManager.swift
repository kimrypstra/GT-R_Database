//
//  ProdNumberManager.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 10/12/20.
//

import Foundation

class ProdNumberManager {
    var series: String
    
    init(series: String) {
        self.series = series
    }
    
    func getColourCodes() -> [String] {
        do {
            let tsvString = try String(contentsOfFile: Bundle.main.path(forResource: "\(series)Prod", ofType: ".txt")!)
            let lines = tsvString.components(separatedBy: "\r\n")
            // lines[0] is the colour codes
            let colourCodes = lines[0].components(separatedBy: "\t").filter({$0 != "" && $0 != " "})
            return colourCodes
        } catch let error {
            print("Error getting colour codes: \(error)")
            return []
        }
        
    }
    
    func keys() -> [String] {
        var keys: [String] = []
        do {
            let tsvString = try String(contentsOfFile: Bundle.main.path(forResource: "\(series)Prod", ofType: ".txt")!)
            let lines = tsvString.components(separatedBy: "\r\n")
            // lines[0] is the colour codes
            let colourCodes = lines[0].components(separatedBy: "\t").filter({$0 != "" && $0 != " "})
            var codeIndices: [Int: String] = [:]
            for (index, code) in colourCodes.enumerated() {
                codeIndices[index] = code
            }
            for index in 1...lines.count - 2 {
                let components = lines[index].components(separatedBy: "\t").filter({$0 != "" && $0 != " "})
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
    
    func generateProdNumbers() -> [String : Any] {
        var prodNumbers: [String : Any] = [:]
        
        do {
            let tsvString = try String(contentsOfFile: Bundle.main.path(forResource: "\(series)Prod", ofType: ".txt")!)
            let lines = tsvString.components(separatedBy: "\r\n")
            // lines[0] is the colour codes
            let colourCodes = lines[0].components(separatedBy: "\t").filter({$0 != "" && $0 != " "})
            var codeIndices: [Int: String] = [:]
            for (index, code) in colourCodes.enumerated() {
                codeIndices[index] = code
            }
            
            
            for index in 1...lines.count - 2 {
                let components = lines[index].components(separatedBy: "\t").filter({$0 != "" && $0 != " "})
                // components[0] is the model
                guard components.count > 0 else {
                    continue
                }
                
                let model = components[0]
                var colourEntries: [String : Int] = [:]
                
                for index in 1...components.count - 1 {
                    let value = components[index]
                    let colourCode = colourCodes[index - 1]
                    colourEntries[colourCode] = Int(value)
                }
                prodNumbers[model] = colourEntries
            }
            let total = Int(lines[lines.count - 2].components(separatedBy: "\t").last!)
            prodNumbers["Total"] = total
            // This is nasty - fix it so the last line in the lines array isn't "" then we can just get the total from lines.last.components...
        } catch let error {
            print("Can't open prod string: \(error)")
        }
        
        return prodNumbers
    }
}
