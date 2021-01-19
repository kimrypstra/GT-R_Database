//
//  Screenshot.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 14/1/21.
//

import UIKit

class Screenshot: UIView {

    @objc @IBOutlet dynamic var contentView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: Screenshot.self)
        bundle.loadNibNamed("Screenshot", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
