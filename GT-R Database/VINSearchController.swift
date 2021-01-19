//
//  VINSearchResultController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 7/11/20.
//

import UIKit
import SwiftUI


class VINSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var alreadyPresented: Bool = false
    
    var searchResult: Car?
    var series: String?
    var searchPrefix: String {
        switch series! {
        case "R34":
            return "BNR34-"
        case "R33":
            return "BCNR33-"
        case "R32":
            return "BNR32-"
        default:
            print("Error - invalid model code: \(series)")
            return ""
        }
    }
    
    var map: [String : String] = [
        "VIN" : "VIN",
        "Grade" : "Grade",
        "Colour" : "Colour",
        "Model Code" : "modelCode",
        "Manufactured at" : "Plant",
        "Seat" : "Seat",
        "Production Date" : "ProductionDate",
        "Number in Grade" : "numberInGrade",
        "Number in Colour" : "numberInColour",
        "VIN Ranges" : "VINRanges",
        "Production Numbers" : "prodNumbers",
        "1" : "Model1",
        "2-3" : "Model2",
        "4" : "Model3",
        "5" : "Model4",
        "6" : "Model5",
        "7" : "Model6",
        "8-10" : "Model7",
        "11" : "Model8",
        "12" : "Model9",
        "13" : "Model10",
        "14" : "Model11",
        "15" : "Model12",
        "16" : "Model13",
        "17" : "Model14",
        "18" : "Model15",
        "Interior Code" : "InteriorCode",
        "Extended Model Code" : "extendedModelCode"
    ]
    
    let sectionNames = [
        "Result",
        "Your Production Number",
        "Model Code",
        "More Information"
    ]
    
    
    @objc dynamic var keysSection0: [String] = [
        "VIN",
        "Grade",
        "Colour",
        "Production Date",
        "Model Code",
        "Interior Code",
        "Seat"
    ]
    
    @objc dynamic var keysSection1: [String] = [
        "Number in Grade",
        "Number in Colour",
        "Manufactured at"
    ]
    
    @objc dynamic var keysSection2: [String] = []
    
    @objc dynamic var keysSection3: [String] = [
        "VIN Ranges",
        "Production Numbers"
    ]
    
    var labelText: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        shareButton.isEnabled = false
         //This needs to adapt to the series
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard !alreadyPresented else {
            return
        }
        
        alreadyPresented = true
        
        searchField.text = searchPrefix
        
        // Set up model numbers and row labels for specific cases
        var highestModelNumberIndex = 0
        switch series {
        case "R32":
            highestModelNumberIndex = 12
            labelText = "BNR32 GT-R VIN Search"
            keysSection0.insert("Extended Model Code", at: keysSection0.firstIndex(of: "Interior Code")!)
            keysSection0.remove(at: keysSection0.firstIndex(of: "Seat")!)
        case "R33":
            highestModelNumberIndex = 15
            labelText = "BCNR33 GT-R VIN Search"
        case "R34":
            highestModelNumberIndex = 15
            labelText = "BNR34 GT-R VIN Search"
            imageView.contentMode = .scaleAspectFill
            keysSection0.remove(at: keysSection0.firstIndex(of: "Interior Code")!)
        default:
            highestModelNumberIndex = 1
        }
        
        titleLabel.text = labelText
        
        for int in 1...highestModelNumberIndex {
            keysSection2.append("\(int)")
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = topBannerView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerView.layer.insertSublayer(gradient, at: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ModelNumberCell.self, forCellReuseIdentifier: "modelNumberCell")
        tableView.register(SmallCell.self, forCellReuseIdentifier: "smallCell")
        tableView.reloadData()
    }
    
    @IBAction func exitButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchField.resignFirstResponder()
        doASearch()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard imageView.image != nil else {return}
        let imageRatio: CGFloat = 200 / 480 // What??

        imageViewHeight.constant = (self.view.frame.width * imageRatio) - (scrollView.contentOffset.y)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if searchField.text == searchPrefix && string == "" {
            print("p1")
            return false
        }
        
        let allowedChars = ["0","1","2","3","4","5","6","7","8","9"]
        var flag = true
        for char in string {
            if allowedChars.contains(String(char)) == false {
                flag = false
                print("Nope")
            }
        }
        
        return flag
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // examine the string
        // make sure the first characters are "BNR34-"
        
        
        let commonPrefix = textField.text?.commonPrefix(with: searchPrefix)
        if commonPrefix == searchPrefix {
            print("IS OK")
        } else {
            print("IS NO OK")
            textField.text = "\(searchPrefix)\(textField.text!)"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Begin editing")
        
    }
    
    func doASearch() {
        let dbMan = DBManager()
        
        guard searchField.text != nil else {return}
        
        switch series! {
        case "R32":
            let searchResult = dbMan.readVINDataFromDB(tableName: series!, attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: searchField.text!, fuzzy: false)
            if !searchResult.isEmpty {
                self.searchResult = searchResult.first as! R32
            } else {
                print("No result")
            }
        case "R33":
            let searchResult = dbMan.readVINDataFromDB(tableName: series!, attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: searchField.text!, fuzzy: false)
            if !searchResult.isEmpty {
                self.searchResult = searchResult.first as! R33
            } else {
                print("No result")
            }
        case "R34":
            let searchResult = dbMan.readVINDataFromDB(tableName: series!, attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: searchField.text!, fuzzy: false)
            if !searchResult.isEmpty {
                self.searchResult = searchResult.first as! R34
            } else {
                print("No result")
            }
        default:
            searchResult = nil
        }
        
        guard searchResult != nil else {
            return
        }
        
        shareButton.isEnabled = true
        
        let colourPath = searchResult!.ColourPath
        let filename = colourPath.components(separatedBy: "\\").last?.components(separatedBy: ".").first
        let filetype = colourPath.components(separatedBy: "\\").last?.components(separatedBy: ".").last
        
        if let path = Bundle.main.path(forResource: filename, ofType: filetype) {
            imageView.image = UIImage(contentsOfFile: path)
            let imageRatio: CGFloat = 200 / 480
            
            UIView.animate(withDuration: 0.2) {
                self.imageViewHeight.constant = self.view.frame.width * imageRatio
                self.view.layoutIfNeeded()
            }
        } else {
            print("Image path not found")
        }

        searchResult!.getNumbers(generation: series!)
        print(searchResult?.modelCode)
        tableView.reloadData()
        //tableView.reloadSections([0], with: .top)
//        self.tableView.performBatchUpdates({
//                self.tableView.insertRows(at: [IndexPath(row: self.keysSection0.count - 1,
//                                                         section: 0)],
//                                          with: .automatic)
//            }, completion: nil)

    }
    
    @IBAction func shareButton(_ sender: Any) {
        // Take a screenshot, or render a new image how we want it
        let image = takeScreenshot(shouldSave: false)
        
        // Present a share sheet
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = shareButton
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func takeScreenshot(shouldSave: Bool) -> UIImage? {
        
        var screenshotImage: UIImage?
        
        var view = ScreenshotView(title: titleLabel.text!)
        view.setup(title: "\(series!) \(searchResult!.Grade)", vin: searchResult?.VIN, grade: searchResult?.Grade, colourText: searchResult?.Colour, productionDate: searchResult?.ProductionDate, modelCode: searchResult?.modelCode, seat: searchResult?.Seat, carImage: imageView.image, interiorCode: searchResult?.InteriorCode)
        
        let host = UIHostingController(rootView: view)
        host.view.frame = CGRect(x: self.view.bounds.width * -1, y: 0, width: self.view.bounds.width, height: self.view.bounds.width)
        self.view.addSubview(host.view)

        let layer = host.view.layer
        //let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0.0);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in: context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard searchResult != nil else {
            print("SearchResult is nil")
            return 0
        }
        
        let mirror = Mirror(reflecting: self)
        var sectionNumbers: [Int] = []
        for child in mirror.children {
            if child.label?.contains("keysSection") == true {
                sectionNumbers.append(Int(child.label!.replacingOccurrences(of: "keysSection", with: ""))!)
            }
        }
        sectionNumbers.sort()
        print("Number of Sections: \(sectionNumbers.last)")
        return sectionNumbers.last! + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard searchResult != nil else {
            print("SearchResult is empty")
            return 0
        }
        return (value(forKey: "keysSection\(section)") as! [String]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 2:
            // MODEL NUMBERS
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "modelNumberCell") as! ModelNumberCell
            
            // Eg: 2
            cell.label.text = (searchResult!.value(forKey: "modelCodeDigits") as! [String])[indexPath.row]
            
            // Eg: B
            let codeValue = searchResult!.value(forKey: "Model\(indexPath.row + 1)") as! String
            cell.code.text = codeValue
            
            // Eg: RB26DETT Type Engine
            cell.descriptionLabel.text = "\(searchResult!.value(forKey: "Readable\(indexPath.row + 1)")!)".replacingOccurrences(of: "\"", with: "")
            // Eg: Engine
            //cell.modelNumberIdentifier.text = searchResult!.modelSubstringIdentifier(for: series!, at: indexPath.row)
            cell.modelNumberIdentifier.text = (searchResult?.value(forKey: "modelNumberDescriptions") as! [String])[indexPath.row]

            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = (value(forKey: "keysSection\(indexPath.section)") as! [String])[indexPath.row]
            cell.textLabel?.font = UIFont(name: "NissanOpti", size: 10)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "smallCell") as! SmallCell
            
            var labelText = (value(forKey: "keysSection\(indexPath.section)") as! [String])[indexPath.row]
            if labelText == "Number in Grade" {
                labelText = searchResult!.Grade
            }
            if labelText == "Number in Colour" {
                let colourCode = searchResult!.Colour.split(separator: "-").first!.replacingOccurrences(of: " ", with: "")
                labelText = "\(searchResult!.Grade) and \(colourCode)"
            }
            
            cell.label.text = labelText
            
            let keys = value(forKey: "keysSection\(indexPath.section)") as! [String]
            let key = keys[indexPath.row]
            let value = searchResult!.value(forKey: map[keys[indexPath.row]]!)! as! String
            cell.value.text = "\(value)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 30))
        label.text = sectionNames[section]
        if section == 3 {
            var prefix = searchPrefix
            label.text = "\(prefix.components(separatedBy: "-").first!) More Information"
        }
        label.font = UIFont(name: "NissanOpti", size: 15)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 2:
//            let aCell = ModelNumberCell()
//            aCell.descriptionLabel.text = "\(searchResult!.value(forKey: "DescriptionModel\(indexPath.row + 1)D")!)".replacingOccurrences(of: "\"", with: "")
//            aCell.layoutIfNeeded()
//            let height = aCell.descriptionLabel.textRect(forBounds: aCell.descriptionLabel.bounds, limitedToNumberOfLines: 3).height
//
            //CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

            return 80
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 3:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "vin", sender: self)
            case 1:
                self.performSegue(withIdentifier: "prod", sender: self)
            default:
                break
            }
        default:
            break
        }
    }
    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "vin":
            let IVC = segue.destination as! TSVTableViewController
            IVC.mode = .VIN
            IVC.series = series
        case "prod":
            let IVC = segue.destination as! TSVTableViewController
            IVC.mode = .Production
            IVC.series = series
        default:
            return
        }
     }
     
    
}
