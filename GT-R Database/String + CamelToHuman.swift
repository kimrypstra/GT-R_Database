//
//  String + CamelToHuman.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 7/11/20.
//

import Foundation

extension String {
    func camelToHuman() -> String {
        
            return self
                .replacingOccurrences(of: "([A-Z])",
                                      with: " $1",
                                      options: .regularExpression,
                                      range: range(of: self))
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .capitalized // If input is in llamaCase
        }
}
