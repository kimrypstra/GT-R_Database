//
//  ProdNumbersViewController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 10/12/20.
//

import UIKit

class TSVTableViewController: UIViewController, UIScrollViewDelegate, ProductionCellDelegate {

    // comment
    var mode: ParseMode!
    var series: String!
    var scroll: UIScrollView?
    
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
    
    var numberOfColumns: CGFloat = 0 // including left header
    var numberOfRows: CGFloat = 0 // including top header

    //TODO: Make cell width auto-sizing (column should size to fit widest text)
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
    let desiredCellHeight: CGFloat = 40
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
    var rowStack: UIStackView?
    
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
        
        setUpTable()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topFloaterLeftAlign.constant = scrollView.contentOffset.x
        leftFloaterTopAlign.constant = scrollView.contentOffset.y * -1
    }
    
    func setUpTable() {
        let tsvMan = TSVManager(series: series, mode: mode)
        let numbers: [String : Any] = tsvMan.generateData()
        let keys = tsvMan.keys()
        let colours = tsvMan.getHeaders()
        let colourMan = ColourManager()
        
        numberOfRows = CGFloat(keys.count)
        numberOfColumns = CGFloat(colours.count)
        
        let columnWidths = tsvMan.getColumnWidths(for: UIFont(name: "NissanOpti", size: 10)!, height: desiredCellHeight, pad: 10)
        
        var totalWidth: CGFloat {
            var total: CGFloat = 0
            for width in columnWidths {
                total += width
            }
            return total
        }
        
        // Set up the scroll view
        scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
        //scroll?.backgroundColor = .yellow
        scroll?.contentSize.width = totalWidth
        scroll?.contentSize.height = (desiredCellHeight * numberOfRows)
        scroll?.delegate = self
        scroll?.bounces = false
        containerView.addSubview(scroll!)
        
        //let width = (desiredCellWidth * (numberOfColumns - 1)) + firstRowWidth

        let height = (desiredCellHeight * numberOfRows)
        
        columnStack = UIStackView(frame: CGRect(x: 0, y: 0, width: totalWidth, height: height))
        columnStack!.distribution = .fill
        
        topFloaterHeight.constant = desiredCellHeight
        topFloaterWidth.constant = totalWidth
        
        leftFloaterWidth.constant = columnWidths[0]
        leftFloaterHeight.constant = height
        //floater.distribution = .fill
        
        for col in 0...Int(numberOfColumns - 1) {
            if col == 0 {
                // These are the left headers
                rowStack = UIStackView(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: height))
                let const = NSLayoutConstraint(item: rowStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: columnWidths[col])
                rowStack!.addConstraint(const)
                rowStack!.distribution = .fillEqually
                rowStack!.axis = .vertical
                
                for row in 0...Int(numberOfRows - 1) {
                    if row == 0 {
                        // MARK: Top Left (blank)
                        let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                        view.setUp(type: .Blank, text: colours[col], coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                        let const = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: columnWidths[col])
                        view.addConstraint(const)
                        //rowStack!.addArrangedSubview(view)
                        topFloater.addArrangedSubview(view)
                    } else {
                        // MARK: First Column (Left headers)
                        let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                        view.setUp(type: .LeftHeader, text: keys[row], coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                        let const = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: desiredCellHeight)
                        //rowStack!.addArrangedSubview(view)
                        leftFloater.addArrangedSubview(view)
                    }
                }
                columnStack!.addArrangedSubview(rowStack!)
            } else {
                // These are NOT the left headers
                rowStack = UIStackView(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: height))
                let const = NSLayoutConstraint(item: rowStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: columnWidths[col])
                rowStack!.addConstraint(const)
                rowStack!.distribution = .fillEqually
                rowStack!.axis = .vertical
                for row in 0...Int(numberOfRows - 1) {
                    if row == 0 {
                        // MARK: Top Row
                        //let view = ProdCell(value: colours[col - 1], frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight), type: .TopHeader)
                        let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                        let text = colours[col]
                        var colour: CarColour? = nil
                        if text != "Total" && text != "Unknown" && text != "???" {
                            colour = colourMan.getColourForCode(code: text)
                        }
                        
                        view.setUp(type: .TopHeader, text: text, coordinate: CGPoint(x: col, y: row), swatchColour: colour, delegate: self)
                        let const = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: columnWidths[col])
                        view.addConstraint(const)
                        
                        topFloater.addArrangedSubview(view)
                        
//                        let blank = ProductionCell(frame: view.frame)
//                        blank.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
//                        blank.addConstraint(const)
//                        rowStack!.addArrangedSubview(blank)
                        
                        //floatingHeader!.addArrangedSubview(view)
                    } else {
                        // MARK: Main Cells
                        if let modelData = numbers[keys[row]] as? [String : String] {
                            // The model data exists
                            if let data = modelData[colours[col]] {
                                // There is a number for that colour
                                let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                                
                                view.setUp(type: .Cell, text: "\(data.replacingOccurrences(of: "\"", with: ""))", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                                rowStack!.addArrangedSubview(view)
                            } else {
                                let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                                view.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                                rowStack!.addArrangedSubview(view)
                            }
                        } else {
                            let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: columnWidths[col], height: desiredCellHeight))
                            view.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), swatchColour: nil, delegate: self)
                            rowStack!.addArrangedSubview(view)
                        }
                    }
                }
                columnStack!.addArrangedSubview(rowStack!)
            }
        }
        scroll?.addSubview(columnStack!)
    }
    
    func didTapProductionCell(at point: CGPoint) {
        if CGFloat(selectedRow) == point.y && CGFloat(selectedColumn) == point.x {
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
        
        let headerCell = leftFloater.arrangedSubviews[row - 1] as! ProductionCell
        headerCell.setSelected(to: true)
        
        for (index, subview) in columnStack!.arrangedSubviews.enumerated() where index != 0 {
            let rowStack = subview as! UIStackView
            // Line has row-1 because the subviews don't count the empty one at the top
            let cell = rowStack.arrangedSubviews[row - 1] as! ProductionCell
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
        
        let headerCell = leftFloater.arrangedSubviews[row - 1] as! ProductionCell
        headerCell.setSelected(to: false)
        
        for (index, subview) in columnStack!.arrangedSubviews.enumerated() where index != selectedColumn && index != 0 {
            let rowStack = subview as! UIStackView
            // Line has row-1 because the subviews don't count the empty one at the top
            let cell = rowStack.arrangedSubviews[row - 1] as! ProductionCell
            cell.setSelected(to: false)
        }
    }
    
    func clearSelectionForColumn(col: Int) {
        guard selectedColumn != -1 else {return}
        
        let headerCell = topFloater.arrangedSubviews[col] as! ProductionCell
        headerCell.setSelected(to: false)
        
        let stack = columnStack?.arrangedSubviews[col] as! UIStackView
        for (index, sub) in stack.arrangedSubviews.enumerated() where index != selectedRow - 1 {
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
