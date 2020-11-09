//
//  SmallCell.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 7/11/20.
//

import Foundation
import UIKit

class SmallCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var label : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NissanOpti", size: 10)
        label.textAlignment = .left
        label.text = "test"
        label.textColor = .black
        return label
    }()
    
    var value : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NissanOpti", size: 10)
        label.textAlignment = .right
        label.text = "test"
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        addSubview(value)
        
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0, enableInsets: false)
        value.anchor(top: topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0, enableInsets: false)
        
    }
    
}
