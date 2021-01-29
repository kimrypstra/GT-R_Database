//
//  ProductionCell.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 14/12/20.
//

import UIKit

enum CellType {
    case Cell
    case LeftHeader
    case TopHeader
    case Blank
}

class ProductionCell: UIView {
    var coordinate: CGPoint?
    var delegate: ProductionCellDelegate? 
    private var type: CellType = .Cell
    private var selectionColour: UIColor = UIColor.black.withAlphaComponent(0.25) {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.selectionView.backgroundColor = self.selectionColour
            }
            
        }
    }
    
    var selected: Bool = false
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var swatchView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: ProductionCell.self)
        bundle.loadNibNamed("ProductionCell", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func didLongPress(_ sender: Any) {
        print("did long press")
    }
    
    @IBAction func didTap(_ sender: Any) {
        switch type {
        case .Blank:
            break
            //delegate?.didTapProductionCell(at: coordinate!)
        case .Cell:
            delegate?.didTapProductionCell(at: coordinate!)
        case .LeftHeader:
            delegate?.didTapLeftHeaderCell(at: coordinate!)
        case .TopHeader:
            delegate?.didTapTopHeaderCell(at: coordinate!)
        }
    }
    
    
    func setUp(type: CellType, text: String, coordinate: CGPoint, swatchColour: CarColour?, delegate: ProductionCellDelegate) {
        setType(to: type)
        
        if type == .LeftHeader || type == .TopHeader {
            label.text = text.splitBracketedSubstringsIntoNewlines()
        } else {
            label.text = text
        }
        
        self.coordinate = coordinate
        self.delegate = delegate
        
        if swatchColour != nil {
            swatchView.backgroundColor = swatchColour?.colour
            swatchView.layer.cornerRadius = 8
            
            if swatchColour?.lightTextRequired == true {
                label.textColor = .white
            }
            //swatchView.layer.borderWidth = 3
            //swatchView.layer.borderColor = UIColor.black.cgColor
        } else {
            swatchView.removeFromSuperview()
        }
    }
    
    func setSelected(to state: Bool) {
        selected = state
        
        switch self.type {
        case .Cell:
            selectionView.round(corners: [.bottomLeft, .topLeft, .bottomRight, .topRight], cornerRadius: 0)
        case .LeftHeader:
            selectionView.round(corners: [.topLeft, .bottomLeft], cornerRadius: Double(selectionView.bounds.height / 3))
            //selectionView.addShadow(shadowColor: .clear, offSet: CGSize(width: 0, height: 0), opacity: 0, shadowRadius: 0, cornerRadius: 10, corners: [.topLeft, .bottomLeft])
        case .TopHeader:
            selectionView.round(corners: [.topLeft, .topRight], cornerRadius: Double(selectionView.bounds.height / 3))
        case .Blank:
            break
            //label.removeFromSuperview()
        }
        
        if selected == true {
            self.selectionColour = UIColor.black.withAlphaComponent(0.25)
        } else {
            self.selectionColour = UIColor.clear
        }
    }
    
    func getLabelWidth() -> CGFloat {
        label.sizeToFit()
        return label.frame.width
    }
    
    private func setType(to type: CellType) {
        self.type = type
        
        label.textAlignment = .center
        
        switch self.type {
        case .Cell:
            label.font = UIFont(name: "Futura", size: 10)
            label.numberOfLines = 1
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
        case .LeftHeader:
            label.font = UIFont(name: "NissanOpti", size: 10)
            label.numberOfLines = 2
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        case .TopHeader:
            label.font = UIFont(name: "NissanOpti", size: 10)
            label.numberOfLines = 2
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        case .Blank:
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
            label.numberOfLines = 1
            label.removeFromSuperview()
        }
        
    }
}
