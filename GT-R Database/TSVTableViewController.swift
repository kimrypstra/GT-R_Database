//
//  ProdNumbersViewController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 10/12/20.
//

import UIKit
import Firebase

class TSVTableViewController: UIViewController, UIScrollViewDelegate, ProductionCellDelegate {

    // comment
    var mode: ParseMode!
    var series: String!
    //var scroll: UIScrollView?
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topFloater: UIStackView!
    @IBOutlet weak var topFloaterWidth: NSLayoutConstraint!
    @IBOutlet weak var topFloaterHeight: NSLayoutConstraint!
    @IBOutlet weak var topFloaterLeftAlign: NSLayoutConstraint!
    @IBOutlet weak var leftFloater: UIStackView!
    @IBOutlet weak var leftFloaterWidth: NSLayoutConstraint!
    @IBOutlet weak var leftFloaterHeight: NSLayoutConstraint!
    @IBOutlet weak var leftFloaterTopAlign: NSLayoutConstraint!
    @IBOutlet weak var floaterBlocker: UIView!
    @IBOutlet weak var floaterBlockerHeight: NSLayoutConstraint!
    @IBOutlet weak var floaterBlockerWidth: NSLayoutConstraint!
    @IBOutlet weak var shadowCellHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowCell: UIView!
    
    var numberOfColumns: CGFloat = 0 // including left header
    var numberOfRows: CGFloat = 0 // including top header
    var desiredCellWidth: CGFloat {
        switch mode {
        case .Production:
            return 100
        case .VIN:
            return 200
        default:
            return 100
        }
    }
    var desiredCellHeight: CGFloat = 40
    var firstRowWidth: CGFloat {
        switch mode {
        case .Production:
            return 200
        case .VIN:
            return 300
        default:
            return 200
        }
    }
    var selectedRow = -1
    var selectedColumn = -1
    var columnStack: UIStackView?
    //var rowStack: UIStackView?
    var height: CGFloat = 0
    var columnWidths: [CGFloat] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.frame = topBannerView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerView.layer.insertSublayer(gradient, at: 0)
        
        switch mode {
        case .Production:
            titleLabel.text = "\(series!) Production Numbers"
        case .VIN:
            titleLabel.text = "\(series!) VIN Ranges"
        case .Pricing:
            titleLabel.text = "\(series!) New Pricing"
        default:
            return
        }
        self.view.clipsToBounds = true
        setUpTable()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topFloaterLeftAlign.constant = scrollView.contentOffset.x
        leftFloaterTopAlign.constant = scrollView.contentOffset.y * -1
        
        // Just use clipsToBounds
//        // Work out which cells are off the screen based on column widths and x offset
//        var offset = scrollView.contentOffset.x
//        var rightmostCellPastLeftEdge = 0
//
//        for (index, width) in columnWidths.enumerated() {
//            offset -= width
//            if offset < 0 {
//                rightmostCellPastLeftEdge = index
//                break
//            }
//        }
//
//        for (index, cell) in topFloater.arrangedSubviews.enumerated() where index <= rightmostCellPastLeftEdge {
//            cell.alpha = 0
//        }
//
//        for (index, cell) in topFloater.arrangedSubviews.enumerated() where index > rightmostCellPastLeftEdge {
//            cell.alpha = 1
//        }

    }
    
    func setUpTable() {
        let tsvMan = TSVManager(series: series, mode: mode)
        let numbers: [String : Any] = tsvMan.generateData()
        let keys = tsvMan.keys()
        let colours = tsvMan.getHeaders()
        let colourMan = ColourManager()
        
        numberOfRows = CGFloat(keys.count)
        
        numberOfColumns = CGFloat(colours.count)
        height = desiredCellHeight * numberOfRows
        columnWidths = tsvMan.getColumnWidths(for: UIFont(name: "NissanOpti", size: 10)!, height: desiredCellHeight, pad: 15)
        
        var totalWidth: CGFloat {
            var total: CGFloat = 0
            for width in columnWidths {
                total += width
            }
            return total
        }
        
        var stretchColumn: Int {
            switch mode {
            case .Pricing:
                return 1
            default:
                return 0
            }
        }
        
        // If the total width is less than the screen width, bump up a column to make it exact
        if totalWidth < scroll.frame.width {
            columnWidths[stretchColumn] += scroll.frame.width - totalWidth
        }
        
        // Set up the scroll view
        scroll?.contentSize.width = totalWidth
        scroll?.contentSize.height = desiredCellHeight * numberOfRows 
        scroll?.delegate = self
        scroll?.bounces = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        containerView.addSubview(scroll!)
        
        floaterBlockerWidth.constant = columnWidths[0]
        floaterBlockerHeight.constant = desiredCellHeight

        columnStack = UIStackView(frame: CGRect(x: 0, y: 0, width: totalWidth, height: height))
        columnStack!.distribution = .fill
        
        topFloaterHeight.constant = desiredCellHeight
        topFloaterWidth.constant = totalWidth

        leftFloaterWidth.constant = columnWidths[0]
        leftFloaterHeight.constant = height
        
        shadowCellHeight.constant = topFloaterHeight.constant
        shadowCell.backgroundColor = UIColor.white
        shadowCell.layer.shadowColor = UIColor.black.cgColor
        shadowCell.layer.shadowOffset = CGSize(width: 0, height: 5)
        shadowCell.layer.shadowRadius = 5
        shadowCell.layer.shadowOpacity = 0.125
        shadowCell.clipsToBounds = false

        for col in 0...Int(numberOfColumns - 1) {
            if col == 0 {
                //MARK: These are the left headers
                let rowStack = UIStackView(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: height))
                let const = NSLayoutConstraint(item: rowStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: columnWidths[col])
                rowStack.addConstraint(const)
                rowStack.distribution = .fillEqually
                rowStack.axis = .vertical
                
                for row in 0...Int(numberOfRows - 1) {
                    if row == 0 {
                        // MARK: Top Left (blank)
                        let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                        view.setUp(type: .Blank, text:
                                "", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                        let const = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: columnWidths[col])
                        view.addConstraint(const)
                        
                        let duplicate = ProductionCell(frame: view.frame)
                        duplicate.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                        let dupeConst = NSLayoutConstraint(item: duplicate, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: desiredCellHeight)
                        duplicate.addConstraint(dupeConst)
                        
                        //rowStack.addArrangedSubview(duplicate)
                        topFloater.addArrangedSubview(view)
                        leftFloater.addArrangedSubview(duplicate)
                    } else {
                        // MARK: First Column (Left headers)
                        let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                        view.setUp(type: .LeftHeader, text: keys[row], coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                        let const = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: desiredCellHeight)
                        view.addConstraint(const)
                        
//                        let duplicate = ProductionCell(frame: view.frame)
//                        duplicate.setUp(type: .Cell, text: "Spacer", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
//                        let dupeConst = NSLayoutConstraint(item: duplicate, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: desiredCellHeight)
//                        duplicate.addConstraint(dupeConst)
//
//                        rowStack.addArrangedSubview(duplicate)
                        leftFloater.addArrangedSubview(view)
                    }
                }
                columnStack!.addArrangedSubview(rowStack)
            } else {
                // These are NOT the left headers
                let rowStack = UIStackView(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: height))
                let const = NSLayoutConstraint(item: rowStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: columnWidths[col])
                rowStack.addConstraint(const)
                rowStack.distribution = .fillEqually
                rowStack.axis = .vertical
                for row in 0...Int(numberOfRows - 1) {
                    if row == 0 {
                        // MARK: Top Row
                        let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                        let text = colours[col]
                        var colour: CarColour? = nil
                        if text != "Total" && text != "Unknown" && text != "???" {
                            colour = colourMan.getColourForCode(code: text)
                        }
                        
                        view.setUp(type: .TopHeader, text: text, coordinate: CGPoint(x: col, y: row), swatchColour: colour, delegate: self)
                        let const = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: columnWidths[col])
                        view.addConstraint(const)
                        
                        let duplicate = ProductionCell(frame: view.frame)
                        duplicate.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                        let dupeConst = NSLayoutConstraint(item: duplicate, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: desiredCellHeight)
                        duplicate.addConstraint(dupeConst)
                        
                        rowStack.addArrangedSubview(duplicate)
                        topFloater.addArrangedSubview(view)
                        
                    } else {
                        // MARK: Main Cells
                        if let modelData = numbers[keys[row]] as? [String : String] {
                            // The model data exists
                            if let data = modelData[colours[col]] {
                                // There is a number for that colour
                                let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                                
                                view.setUp(type: .Cell, text: "\(data.replacingOccurrences(of: "\"", with: ""))", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                                rowStack.addArrangedSubview(view)
                            } else {
                                let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                                view.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                                rowStack.addArrangedSubview(view)
                            }
                        } else {
                            // The model data does not exist
                            let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                            view.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                            rowStack.addArrangedSubview(view)
                        }
                    }
                }
                columnStack!.addArrangedSubview(rowStack)
            }
        }
        scroll?.addSubview(columnStack!)
    }
    
    override func viewDidLayoutSubviews() {
//        topFloater.layer.shadowColor = UIColor.black.cgColor
//        topFloater.layer.shadowOffset = CGSize(width: 0, height: 5)
//        topFloater.layer.shadowRadius = 5
//        topFloater.layer.shadowOpacity = 0.125
//        topFloater.clipsToBounds = false
//        //topFloater.layer.shadowPath = UIBezierPath(rect: topFloater.bounds).cgPath
//        //topFloater.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: topFloater.bounds.width, height: 1)).cgPath
//
//        floaterBlocker.layer.shadowColor = UIColor.black.cgColor
//        floaterBlocker.layer.shadowOffset = CGSize(width: 0, height: 5)
//        floaterBlocker.layer.shadowRadius = 5
//        floaterBlocker.layer.shadowOpacity = 0.125
//        floaterBlocker.clipsToBounds = false
//        //floaterBlocker.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: floaterBlocker.bounds.width, height: 1)).cgPath
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: "Table Screen",
                                        "Series" : "\(series!)",
                                        "Mode" : "\(mode!.rawValue)"])
    }
    
    func didTapProductionCell(at point: CGPoint) {
        if CGFloat(selectedRow) == point.y && CGFloat(selectedColumn) == point.x {
            // If you tap a cell that is currently selected
            didTapLeftHeaderCell(at: point)
            didTapTopHeaderCell(at: point)
        } else {
            if CGFloat(selectedColumn) != point.x {
                didTapTopHeaderCell(at: point)
            }
            
            if CGFloat(selectedRow) != point.y {
                didTapLeftHeaderCell(at: point)
            }
        }
    }
    
    func didTapTopHeaderCell(at point: CGPoint) {
        print("top")
        if Int(point.x) == selectedColumn {
            clearSelectionForColumn(col: Int(point.x))
            selectedColumn = -1
        } else {
            setSelectionForColumn(column: Int(point.x))
        }
    }
    
    func didTapLeftHeaderCell(at point: CGPoint) {
        print("left")
        if Int(point.y) == selectedRow {
            clearSelectionForRow(row: Int(point.y))
            selectedRow = -1
        } else {
            setSelectionForRow(row: Int(point.y))
        }
    }
    
    func setSelectionForRow(row: Int) {
        clearSelectionForRow(row: selectedRow)
        selectedRow = row
        
        let headerCell = leftFloater.arrangedSubviews[row] as! ProductionCell
        headerCell.setSelected(to: true)
        
        for (index, subview) in columnStack!.arrangedSubviews.enumerated() where index != 0 {
            let rowStack = subview as! UIStackView
            let cell = rowStack.arrangedSubviews[row] as! ProductionCell
            cell.setSelected(to: true)
        }
    }
    
    func setSelectionForColumn(column: Int) {
        clearSelectionForColumn(col: selectedColumn)
        selectedColumn = column
        
        let headerCell = topFloater.arrangedSubviews[column] as! ProductionCell
        headerCell.setSelected(to: true)
        
        let stack = columnStack?.arrangedSubviews[column] as! UIStackView
        for sub in stack.arrangedSubviews {
            let view = sub as! ProductionCell
            view.setSelected(to: true)
        }
    }
    
    func clearSelectionForRow(row: Int) {
        guard selectedRow != -1 else {return}
        
        let headerCell = leftFloater.arrangedSubviews[row] as! ProductionCell
        headerCell.setSelected(to: false)
        
        for (index, subview) in columnStack!.arrangedSubviews.enumerated() where index != selectedColumn && index != 0 {
            let rowStack = subview as! UIStackView
            let cell = rowStack.arrangedSubviews[row] as! ProductionCell
            cell.setSelected(to: false)
        }
    }
    
    func clearSelectionForColumn(col: Int) {
        guard selectedColumn != -1 else {return}
        
        let headerCell = topFloater.arrangedSubviews[col] as! ProductionCell
        headerCell.setSelected(to: false)
        
        let stack = columnStack?.arrangedSubviews[col] as! UIStackView
        for (index, sub) in stack.arrangedSubviews.enumerated() where index != selectedRow {
            let view = sub as! ProductionCell
            view.setSelected(to: false)
        }
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
