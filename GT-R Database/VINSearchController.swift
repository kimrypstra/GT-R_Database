//
//  VINSearchResultController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 7/11/20.
//

import UIKit
import SwiftUI
import Firebase

class VINSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, VINPlateDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    var vinPlate = UIHostingController(rootView: VINPlate())
    
    var alreadyPresented: Bool = false
    
    var searchResult: Car?
    var series: String?
    var searchPrefix: String = "" {
        didSet {
            textFieldDidChangeSelection(searchField)
        }
    }
    var lastSearchPrefix: String = ""
    
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
        "Production Numbers",
        "New Pricing"
    ]
    
    var labelText: String = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        shareButton.isEnabled = false

        switch series! {
        case "R34":
            searchPrefix = "BNR34-"
        case "R33":
            searchPrefix = "BCNR33-"
        case "R32":
            searchPrefix = "BNR32-"
        default:
            print("Error - invalid model code: \(series)")
            searchPrefix = ""
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard !alreadyPresented else {
            return
        }
        
        alreadyPresented = true // A flag that, when true, blocks the search from resetting when this view is returned to from the vin ranges view 
        
        searchField.text = searchPrefix
        
        // Set up model numbers and row labels for specific cases
        var highestModelNumberIndex = 0
        switch series {
        case "R32":
            highestModelNumberIndex = 12
            labelText = "BNR32 VIN Search"
            keysSection0.insert("Extended Model Code", at: keysSection0.firstIndex(of: "Interior Code")!)
            keysSection0.remove(at: keysSection0.firstIndex(of: "Seat")!)
            
        case "R33":
            highestModelNumberIndex = 15
            labelText = "BCNR33 VIN Search"
            
        case "R34":
            highestModelNumberIndex = 15
            labelText = "BNR34 VIN Search"
            imageView.contentMode = .scaleAspectFill
            keysSection0.remove(at: keysSection0.firstIndex(of: "Interior Code")!)
            
        default:
            highestModelNumberIndex = 1
        }
        
        titleLabel.text = labelText
        
        for int in 1...highestModelNumberIndex {
            keysSection2.append("\(int)")
        }
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ModelNumberCell.self, forCellReuseIdentifier: "modelNumberCell")
        tableView.register(SmallCell.self, forCellReuseIdentifier: "smallCell")
        tableView.reloadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: "VIN Search Screen",
                                        "Series" : "\(series!)"])
    }
    
    override func viewDidLayoutSubviews() {
        let gradient = CAGradientLayer()
        gradient.frame = topBannerView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerView.layer.insertSublayer(gradient, at: 0)
        
        vinPlate.rootView.series = series!
        vinPlate.rootView.delegate = self
        vinPlate.rootView.imageName = "\(series!)VinPlate"
        vinPlate.view.backgroundColor = .clear
        
        let sidePad = 10
        let topPad = 0
        let width = Int(self.view.bounds.width) - (sidePad * 2)
        
        // This should be a square otherwise the layout shifts to the left
        vinPlate.view.frame = CGRect(x: sidePad, y: Int(searchButton.frame.maxY) + topPad, width: width, height: Int(tableView.frame.height))
        
        
        let recog = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        vinPlate.view.addGestureRecognizer(recog)
        
        self.view.addSubview(vinPlate.view)
        
        let const = NSLayoutConstraint(item: vinPlate.view, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 20)
        self.view.addConstraint(const)
        
        //        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        //        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        //        numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
        //                             [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
        //                             [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
        //        [numberToolbar sizeToFit];
        //        numberTextField.inputAccessoryView = numberToolbar;
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        toolbar.barStyle = .default
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(textFieldShouldReturn(_:)), for: .touchUpInside)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.titleLabel?.font = UIFont(name: "NissanOpti", size: 12)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.setTitle("Search", for: .normal)
        button.tintColor = .black
        button.frame.size.width += 50
        
        toolbar.items = [UIBarButtonItem(systemItem: .flexibleSpace), UIBarButtonItem(customView: button)]
        
        searchField.inputAccessoryView = toolbar
    }
    
    @objc func handleTap() {
        searchField.resignFirstResponder()
    }
    
    func didTapVINRangesButton() {
        performSegue(withIdentifier: "vin", sender: nil)
    }
    
    func didTapVINCountry(country: String) {
        lastSearchPrefix = searchPrefix
        vinPlate.rootView.imageName = "\(series!)\(country)"
        
        switch country {
        case "GreatBritain":
            searchPrefix = "JN1GAP\(series!)U"
        case "Singapore":
            searchPrefix = "JN1GBN\(series!)A"
        case "HongKong":
            searchPrefix = "BNR34-\(series!)"
        case "NewZealand":
            searchPrefix = "JN1GBN\(series!)A"
        default:
            print("Unrecognised country, back to normal")
            vinPlate.rootView.imageName = "\(series!)VinPlate"
            switch series! {
            case "R34":
                searchPrefix = "BNR34-"
            case "R33":
                searchPrefix = "BCNR33-"
            case "R32":
                searchPrefix = "BNR32-"
            default:
                print("Unknown series")
            }
        }
        
        //searchPrefix = vinPrefix
    }
    
    func didTapContactUs() {
        performSegue(withIdentifier: "about", sender: nil)
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
        
        //let allowedChars = ["0","1","2","3","4","5","6","7","8","9"]
        let allowedChars = NSCharacterSet.alphanumerics
        var flag = true
        for char in string {
            if allowedChars.contains(UnicodeScalar(String(char))!) == false {
                flag = false
                print("Nope")
            }
            
//            if allowedChars.contains(String(char)) == false {
//                flag = false
//                print("Nope")
//            }
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
            let text = textField.text?.replacingOccurrences(of: lastSearchPrefix, with: "")
            textField.text = "\(searchPrefix)\(text!)"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButton(searchButton)
        return true
    }
    
    func doASearch() {
        let dbMan = DBManager()
        
        // Maybe set searchResult back to nil and have the tableview/images reset to nil before searching?
        
        guard searchField.text != nil else {return}
        
        switch series! {
        case "R32":
            let searchResult = dbMan.readVINDataFromDB(tableName: series!, attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: searchField.text!, fuzzy: false)
            if !searchResult.isEmpty {
                self.searchResult = searchResult.first as! R32
            } else {
                self.searchResult = nil
                print("No result")
            }
        case "R33":
            let searchResult = dbMan.readVINDataFromDB(tableName: series!, attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: searchField.text!, fuzzy: false)
            if !searchResult.isEmpty {
                self.searchResult = searchResult.first as! R33
            } else {
                self.searchResult = nil
                print("No result")
            }
        case "R34":
            let searchResult = dbMan.readVINDataFromDB(tableName: series!, attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: searchField.text!, fuzzy: false)
            if !searchResult.isEmpty {
                self.searchResult = searchResult.first as! R34
            } else {
                self.searchResult = nil
                print("No result")
            }
        default:
            searchResult = nil
        }
        
        guard searchResult != nil else {
            vinPlate.rootView.failedSearch = true
            
            UIView.animate(withDuration: 0.5) {
                self.vinPlate.view.alpha = 1
            }
            imageView.image = nil
            imageViewHeight.constant = 0
            tableView.reloadData()
            return
        }
        
        // From this point, the search is successful
        
        UIView.animate(withDuration: 0.1) {
            self.vinPlate.view.alpha = 0
        }
        
        shareButton.isEnabled = true
        
        let colourPath = searchResult!.ColourPath
        let filename = colourPath.components(separatedBy: "\\").last?.components(separatedBy: ".").first
        let filetype = colourPath.components(separatedBy: "\\").last?.components(separatedBy: ".").last
        
        if let path = Bundle.main.path(forResource: filename, ofType: filetype) {
            let img = UIImage(contentsOfFile: path)
            imageView.image = img
            let imageRatio: CGFloat = 200 / 480
            //let imageRatio: CGFloat = img!.size.height / img!.size.width

            UIView.animate(withDuration: 0.2) {
                self.imageViewHeight.constant = self.view.frame.width * imageRatio
                self.view.layoutIfNeeded()
            }
        } else {
            print("Image path not found for \(colourPath)")
            imageView.image = nil
            UIView.animate(withDuration: 0.2) {
                self.imageViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }

        searchResult!.getNumbers(generation: series!)
        print(searchResult?.modelCode)
        tableView.reloadData()
    }
    
    @IBAction func shareButton(_ sender: Any) {
        // Take a screenshot, or render a new image how we want it
        let image = takeScreenshot(shouldSave: false)
        
        // Present a share sheet
        let activityVC = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = shareButton
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if !success{
                print("cancelled")
                return
            }
            let activity = "\(activity!.rawValue.split(separator: ".").last!)"
            Analytics.logEvent("Shared_Screenshot", parameters: ["Activity" : "\(activity)"])
            print("Logged event")

            return
        }
        
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
        
        host.view.removeFromSuperview()
        
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
            let modelCodeDigits = (searchResult!.value(forKey: "modelCodeDigits") as! [String])[indexPath.row]
            if stringIsValid(string: modelCodeDigits) {
                cell.label.text = modelCodeDigits
            } else {
                cell.label.text = ""
            }
            
            // Eg: B
            let codeValue = searchResult!.value(forKey: "Model\(indexPath.row + 1)") as! String
            if stringIsValid(string: codeValue) {
                cell.code.text = codeValue
            } else {
                cell.label.text = ""
            }
            
            // Eg: RB26DETT Type Engine
            let descriptionLabel = "\(searchResult!.value(forKey: "Readable\(indexPath.row + 1)")!)".replacingOccurrences(of: "\"", with: "")
            if stringIsValid(string: descriptionLabel) {
                cell.descriptionLabel.text = descriptionLabel
            } else {
                cell.label.text = ""
            }
            
            // Eg: Engine
            //cell.modelNumberIdentifier.text = searchResult!.modelSubstringIdentifier(for: series!, at: indexPath.row)
            let modelNumberDescription = (searchResult?.value(forKey: "modelNumberDescriptions") as! [String])[indexPath.row]
            if stringIsValid(string: modelNumberDescription) {
                cell.modelNumberIdentifier.text = modelNumberDescription
            } else {
                cell.label.text = ""
            }

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
                let grade = searchResult!.Grade
                if stringIsValid(string: grade) {
                    labelText = grade
                } else {
                    labelText = ""
                }
            }
            if labelText == "Number in Colour" {
                if let colourCode = searchResult!.Colour.split(separator: "-").first?.replacingOccurrences(of: " ", with: "") {
                    let grade = searchResult!.Grade
                    if stringIsValid(string: grade) {
                        labelText = "\(searchResult!.Grade) and \(colourCode)"
                    } else {
                        labelText = ""
                    }
                }
            }
            
            cell.label.text = labelText
            
            let keys = value(forKey: "keysSection\(indexPath.section)") as! [String]
            let value = searchResult!.value(forKey: map[keys[indexPath.row]]!)! as! String
            if stringIsValid(string: value) {
                cell.value.text = "\(value)"
            } else {
                cell.value.text = "" 
            }
            return cell
        }
    }
    
    func stringIsValid(string: String) -> Bool {
        guard string != "" else {return false}
        guard string != " " else {return false}
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 30))
        label.text = sectionNames[section]
        if section == 3 {
            var prefix: String {
                return series!
            }
            label.text = "\(prefix.components(separatedBy: "-").first!) GT-R More Information"
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
            case 2:
                self.performSegue(withIdentifier: "price", sender: self)
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
        case "price":
            let IVC = segue.destination as! TSVTableViewController
            IVC.mode = .Pricing
            IVC.series = series
        default:
            return
        }
     }
     
    
}
