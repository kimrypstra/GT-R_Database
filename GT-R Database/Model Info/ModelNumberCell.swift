//
//  ModelNumberCell.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 8/11/20.
//

import Foundation
import UIKit

class ModelNumberCell: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NissanOpti", size: 10)
        label.textAlignment = .left
        label.text = ""
        label.textColor = .black
        return label
    }()
    
    var code: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NissanOpti", size: 10)
        label.textAlignment = .left
        label.text = ""
        label.textColor = .black
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NissanOpti", size: 10)
        label.textAlignment = .right
        label.text = ""
        label.textColor = .black
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.allowsDefaultTighteningForTruncation = true
        label.minimumScaleFactor = 0.5
        //label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var modelNumberIdentifier: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura Medium Italic", size: 10)
        label.textAlignment = .right
        label.text = ""
        label.textColor = .red
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        addSubview(code)
        addSubview(descriptionLabel)
        addSubview(modelNumberIdentifier)
        
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 35, height: 0, enableInsets: false)
        code.anchor(top: topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 30, height: 0, enableInsets: false)
        descriptionLabel.anchor(top: topAnchor, left: code.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0, enableInsets: false)
        modelNumberIdentifier.anchor(top: topAnchor, left: nil, bottom: descriptionLabel.topAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 10, enableInsets: false)
        
    }
    
}
