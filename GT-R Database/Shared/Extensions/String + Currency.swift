//
//  String + Currency.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 19/1/21.
//

import Foundation

extension String {
    func formatForCurrency() -> String? {
        
        guard let number = Double(self) else {
            print("Could not format \(self) as number")
            return nil
        }
        let nsNumber = NSNumber(floatLiteral: number)
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.currencySymbol = "¥"
        formatter.locale = Locale.current
        
        return formatter.string(from: nsNumber)
    }
}
