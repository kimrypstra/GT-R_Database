//
//  ProdNumbersViewController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 10/12/20.
//

import UIKit

class ProdNumbersViewController: UIViewController {

    var series: String!
    var scroll: UIScrollView?
    
    @IBOutlet weak var containerView: UIView!
    
    var numberOfColumns: CGFloat = 10 // including left header
    var numberOfRows: CGFloat = 5
    let hPad: CGFloat = 10
    let vPad: CGFloat = 10
    let desiredCellWidth: CGFloat = 100
    let desiredCellHeight: CGFloat = 50
    let firstRowWidth: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let prodMan = ProdNumberManager(series: series)
        let numbers: [String : Any] = prodMan.generateProdNumbers()
        let keys = prodMan.keys()
        let colours = prodMan.getColourCodes()
        
        
        // test
        let total = numbers["Total"]
        let mSpec = numbers["M-Spec"] as! [String : Int]
        let gv1 = mSpec["GV1"]
        
        numberOfRows = CGFloat(numbers.keys.count)
        numberOfColumns = CGFloat(prodMan.getColourCodes().count + 1)
        
        scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height))
        scroll?.backgroundColor = .yellow
        scroll?.contentSize.width = (desiredCellWidth * (numberOfColumns - 1)) + firstRowWidth
        scroll?.contentSize.height = (desiredCellHeight * numberOfRows)
        containerView.addSubview(scroll!)
        
        let width = (desiredCellWidth * (numberOfColumns - 1)) + firstRowWidth
        let height = (desiredCellHeight * numberOfRows)
        
        let columnStack = UIStackView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        columnStack.distribution = .fill
        
        for col in 0...Int(numberOfColumns - 1) {
            if col == 0 {
                let rowStack = UIStackView(frame: CGRect(x: 0, y: 0, width: firstRowWidth, height: height))
                let const = NSLayoutConstraint(item: rowStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: firstRowWidth)
                //const.priority = .required
                rowStack.addConstraint(const)
                rowStack.distribution = .fillEqually
                rowStack.axis = .vertical
                for row in 0...Int(numberOfRows - 1) {
                    
                    if row == 0 {
                        // MARK: Top Left (blank)
                        let view = ProdCell(value: "", frame: CGRect(x: 0, y: 0, width: firstRowWidth, height: desiredCellHeight), type: .Blank)
                        
                        view.backgroundColor = .red
                        view.layer.borderColor = UIColor.black.cgColor
                        view.layer.borderWidth = 1
                        rowStack.addArrangedSubview(view)
                    } else {
                        // MARK: First Column
                        let view = ProdCell(value: keys[row], frame: CGRect(x: 0, y: 0, width: firstRowWidth, height: desiredCellHeight), type: .LeftHeader)
                        view.backgroundColor = .red
                        view.layer.borderColor = UIColor.black.cgColor
                        view.layer.borderWidth = 1
                        rowStack.addArrangedSubview(view)
                    }
                }
                columnStack.addArrangedSubview(rowStack)
            } else {
                let rowStack = UIStackView(frame: CGRect(x: 0, y: 0, width: width / numberOfRows, height: height))
                let const = NSLayoutConstraint(item: rowStack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: desiredCellWidth)
                //const.priority = .defaultLow
                rowStack.addConstraint(const)
                rowStack.distribution = .fillEqually
                rowStack.axis = .vertical
                for row in 0...Int(numberOfRows - 1) {
                    if row == 0 {
                        // MARK: Top Row
                        let view = ProdCell(value: colours[col - 1], frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight), type: .TopHeader)
                        
                        view.backgroundColor = .red
                        view.layer.borderColor = UIColor.black.cgColor
                        view.layer.borderWidth = 1
                        rowStack.addArrangedSubview(view)
                    } else {
                        
                        // MARK: Main Cells
                        
                        if let modelData = numbers[keys[row]] as? [String : Int] {
                            // The model data exists
                            if let colourData = modelData[colours[col - 1]] {
                                // There is a number for that colour
                                let view = ProdCell(value: String(colourData), frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight), type: .Cell)
                                view.backgroundColor = .red
                                view.layer.borderColor = UIColor.black.cgColor
                                view.layer.borderWidth = 1
                                rowStack.addArrangedSubview(view)
                            } else {
                                let view = ProdCell(value: "", frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight), type: .Blank)
                                view.backgroundColor = .red
                                view.layer.borderColor = UIColor.black.cgColor
                                view.layer.borderWidth = 1
                                rowStack.addArrangedSubview(view)
                            }
                        } else {
                            let view = ProdCell(value: "", frame: CGRect(x: 0, y: 0, width: desiredCellWidth, height: desiredCellHeight), type: .Blank)
                            view.backgroundColor = .red
                            view.layer.borderColor = UIColor.black.cgColor
                            view.layer.borderWidth = 1
                            rowStack.addArrangedSubview(view)
                        }
                    }
                }
                columnStack.addArrangedSubview(rowStack)
            }
        }
        scroll?.addSubview(columnStack)
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
