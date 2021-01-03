//
//  ProdNumberManager.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 10/12/20.
//

import Foundation
import UIKit

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
            var headers = lines[0].components(separatedBy: "\t")
            
            // remove carriage returns from the last colour code
            headers[headers.count - 1] = headers[headers.count - 1].replacingOccurrences(of: "\r", with: "")
            
            //colourCodes.removeFirst()
            print("Headers: \(headers)")
            return headers
        } catch let error {
            print("Error getting headers: \(error)")
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
    
    func getColumnWidths(for font: UIFont, height: CGFloat, pad: CGFloat) -> [CGFloat] {
        var widths: [CGFloat] = []
        
        for column in 0...getHeaders().count - 1 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
            label.text = getLongestStringForColumn(col: column).string.lengthOfLongestBracketedComponent()
            label.font = font
            if column == 0 {
                label.numberOfLines = 2
            } else {
                label.numberOfLines = 1
            }
            label.sizeToFit()
            widths.append(label.frame.width + pad)
        }
        
        return widths
    }
    
    func getLongestStringForColumn(col: Int) -> (string: String, index: Int) {
        do {
            // An array to hold all the strings in the column
            var strings: [(string: String, index: Int)] = []
            
            // Split into lines
            let tsvString = try String(contentsOfFile: Bundle.main.path(forResource: "\(series)\(mode.rawValue)", ofType: ".tsv")!)
            let lines = tsvString.components(separatedBy: "\n")
            
            // Get the string for the column for each line
            for index in 0...lines.count - 1 {
                let components = lines[index].components(separatedBy: "\t")
                
                guard components.count > 0 else {
                    continue
                }
                
                let string = components[col]
                strings.append((string, col))
            }
            
            // Get the largest string value
            return strings.sorted(by: {$0.string.count > $1.string.count}).first!
            
        } catch let error {
            print("Error: \(error)")
            return ("Error: \(error)", -1)
        }
        
    }
    
    func generateData() -> [String : Any] {
        
        /*
         ["V-Spec II" :
                    ["QV1" : "20",
                    "AR1" : "15"],
         "M-Spec" :
                    ["Blah" : "Blah"]
         ]
         */
        
        
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
