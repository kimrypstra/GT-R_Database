//
//  ProdCell.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 12/12/20.
//

import Foundation
import UIKit

enum CellType {
    case Cell
    case LeftHeader
    case TopHeader
    case Blank
}

class ProdCell: UIView {
    private var value: String
    private var label: UILabel
    private var type: CellType
    
    init(value: String, frame: CGRect, type: CellType) {
        self.value = value
        self.label = UILabel()
        self.type = type
        super.init(frame: frame)
        setUp(value: value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp(value: String) {
        label.frame = self.bounds
        label.center.x = self.center.x
        label.center.y = self.center.y
        label.textAlignment = .center
        
        
        setValueLabel(to: value)
        setType(to: type)
        addSubview(label)
    }
    
    func setType(to type: CellType) {
        self.type = type
        
        switch self.type {
        case .Cell:
            label.font = UIFont(name: "Futura", size: 10)
        case .LeftHeader:
            label.font = UIFont(name: "NissanOpti", size: 10)
        case .TopHeader:
            label.font = UIFont(name: "NissanOpti", size: 10)
        case .Blank:
            label.removeFromSuperview()
        }
    }
    
    func setValueLabel(to value: String) {
        self.value = value
        self.label.text = self.value
    }
}
