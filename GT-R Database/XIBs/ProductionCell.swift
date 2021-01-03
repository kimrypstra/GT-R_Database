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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
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
    
    func commonInit() {
        let bundle = Bundle(for: ProductionCell.self)
        bundle.loadNibNamed("ProductionCell", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setUp(type: CellType, text: String, coordinate: CGPoint, delegate: ProductionCellDelegate) {
        setType(to: type)
        //label.text = text
        
        label.text = text.splitBracketedSubstringsIntoNewlines()
        
        self.coordinate = coordinate
        self.delegate = delegate
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
        case .LeftHeader:
            label.font = UIFont(name: "NissanOpti", size: 10)
            label.numberOfLines = 2
        case .TopHeader:
            label.font = UIFont(name: "NissanOpti", size: 10)
            label.numberOfLines = 1

        case .Blank:
            label.numberOfLines = 1
            label.removeFromSuperview()
        }
    }
}
