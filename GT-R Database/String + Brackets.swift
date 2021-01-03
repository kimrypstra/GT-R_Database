//
//  String + Brackets.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 2/1/21.
//

import Foundation

extension String {
    
    func extractBracketedComponents() -> [String] {
        var returnValue: [String] = []
        guard self.contains("(") && self.contains(")") else {
            print("Incomplete or no brackets")
            return [self]
        }
    
        let components = self.components(separatedBy: "(")
        
        for (index, component) in components.enumerated() {
            if index > 0 {
                returnValue.append("(\(component)")
            } else {
                returnValue.append(component)
            }
            
        }
        
        return returnValue
    }
    
    func splitBracketedSubstringsIntoNewlines() -> String {
        let components = self.extractBracketedComponents()
        
        guard components.count > 1 else {
            //print("Not enough components; returning \(components.first!)")
            return components.first!
        }
        
        var returnValue = ""

        for (index, component) in components.enumerated() {
            if index > 0 {
                returnValue.append("\n\(component)")
            } else {
                returnValue.append(component)
            }
        }
        print(returnValue)
        return returnValue
    }
    
    func lengthOfLongestBracketedComponent() -> String {
        let components = self.extractBracketedComponents()
        let sorted = components.sorted(by: {$0.count > $1.count})
        return sorted.first!
    }
}
