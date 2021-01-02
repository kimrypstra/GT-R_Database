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
    
    @IBOutlet weak var floater: UIStackView!
    @IBOutlet weak var floaterWidth: NSLayoutConstraint!
    @IBOutlet weak var floaterHeight: NSLayoutConstraint!
    @IBOutlet weak var floaterLeftAlign: NSLayoutConstraint!
    
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
    var floatingHeader: UIStackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.frame = topBannerView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerView.layer.insertSublayer(gradient, at: 0)
    
        setUpTable()
        
        switch mode {
        case .Production:
            titleLabel.text = "\(series!) Production Numbers"
        case .VIN:
            titleLabel.text = "\(series!) VIN Ranges"
        default:
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        setUpFloater()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        floaterLeftAlign.constant = scrollView.contentOffset.x
    }
    
    func setUpFloater() {

        //floater.backgroundColor = .red
    }
    
    func setUpTable() {
        let tsvMan = TSVManager(series: series, mode: mode)
        let numbers: [String : Any] = tsvMan.generateData()
        let keys = tsvMan.keys()
        let colours = tsvMan.getHeaders()
        
        numberOfRows = CGFloat(numbers.keys.count)
        numberOfColumns = CGFloat(tsvMan.getHeaders().count + 1)
        
        scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
        //scroll?.backgroundColor = .yellow
        scroll?.contentSize.width = (desiredCellWidth * (numberOfColumns - 1)) + firstRowWidth
        scroll?.contentSize.height = (desiredCellHeight * numberOfRows)
        scroll?.delegate = self
        scroll?.bounces = false
        containerView.addSubview(scroll!)
        
        let widths = tsvMan.getColumnWidths(for: UIFont(name: "NissanOpti", size: 10)!)
        print(widths)
        let width = (desiredCellWidth * (numberOfColumns - 1)) + firstRowWidth
        var totalWidth: CGFloat {
            var total: CGFloat = 0
            for number in widths {
                total += number
            }
            return total
        }
        
        let height = (desiredCellHeight * numberOfRows)
        
        columnStack = UIStackView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        columnStack!.distribution = .fill
        
        floaterHeight.constant = desiredCellHeight
        floaterWidth.constant = width
        //floater.distribution = .fill
        
        for col in 0...Int(numberOfColumns - 1) {
            if col == 0 {
                rowStack = UIStackView(frame: CGRect(x: 0, y: 0, width: firstRowWidth, height: height))
                let const = NSLayoutConstraint(item: rowStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: firstRowWidth)
                //const.priority = .required
                rowStack!.addConstraint(const)
                rowStack!.distribution = .fillEqually
                rowStack!.axis = .vertical
                for row in 0...Int(numberOfRows - 1) {
                    if row == 0 {
                        // MARK: Top Left (blank)
                        let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: firstRowWidth, height: desiredCellHeight))
                        view.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), delegate: self)
                        let const = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: firstRowWidth)
                        view.addConstraint(const)
                        //rowStack!.addArrangedSubview(view)
                        floater.addArrangedSubview(view)
                    } else {
                        // MARK: First Column
                        let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: firstRowWidth, height: desiredCellHeight))
                        view.setUp(type: .LeftHeader, text: keys[row], coordinate: CGPoint(x: col, y: row), delegate: self)
                        rowStack!.addArrangedSubview(view)
                    }
                }
                columnStack!.addArrangedSubview(rowStack!)
            } else {
                rowStack = UIStackView(frame: CGRect(x: 0, y: 0, width: width / numberOfRows, height: height))
                let const = NSLayoutConstraint(item: rowStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: desiredCellWidth)
                //const.priority = .defaultLow
                rowStack!.addConstraint(const)
                rowStack!.distribution = .fillEqually
                rowStack!.axis = .vertical
                for row in 0...Int(numberOfRows - 1) {
                    if row == 0 {
                        // MARK: Top Row
                        //let view = ProdCell(value: colours[col - 1], frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight), type: .TopHeader)
                        let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight))
                        view.setUp(type: .TopHeader, text: colours[col - 1], coordinate: CGPoint(x: col, y: row), delegate: self)
                        let const = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: desiredCellWidth)
                        view.addConstraint(const)
                        //rowStack!.addArrangedSubview(view)
                        floater.addArrangedSubview(view)
                        //floatingHeader!.addArrangedSubview(view)
                    } else {
                        // MARK: Main Cells
                        if let modelData = numbers[keys[row]] as? [String : String] {
                            // The model data exists
                            if let colourData = modelData[colours[col - 1]] {
                                // There is a number for that colour
                                let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight))
                                view.setUp(type: .Cell, text: "\(colourData)", coordinate: CGPoint(x: col, y: row), delegate: self)
                                rowStack!.addArrangedSubview(view)
                            } else {
                                let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight))
                                view.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), delegate: self)
                                rowStack!.addArrangedSubview(view)
                            }
                        } else {
                            let view = ProductionCell(frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight))
                            view.setUp(type: .Blank, text: "", coordinate: CGPoint(x: col, y: row), delegate: self)
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
        didTapTopHeaderCell(at: point)
        didTapLeftHeaderCell(at: point)
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
        for subview in columnStack!.arrangedSubviews {
            let rowStack = subview as! UIStackView
            let cell = rowStack.arrangedSubviews[row] as! ProductionCell
            cell.setSelected(to: true)
        }
    }
    
    func setSelectionForColumn(column: Int) {
        clearSelectionForColumn(col: selectedColumn)
        selectedColumn = column
        let stack = columnStack?.arrangedSubviews[column] as! UIStackView
        for sub in stack.arrangedSubviews {
            let view = sub as! ProductionCell
            view.setSelected(to: true)
        }
    }
    
    func clearSelectionForRow(row: Int) {
        guard selectedRow != -1 else {return}
        
        for (index, subview) in columnStack!.arrangedSubviews.enumerated() where index != selectedColumn {
            let rowStack = subview as! UIStackView
            let cell = rowStack.arrangedSubviews[row] as! ProductionCell
            cell.setSelected(to: false)
        }
    }
    
    func clearSelectionForColumn(col: Int) {
        guard selectedColumn != -1 else {return}
        
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
