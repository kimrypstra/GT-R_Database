import UIKit
import SwiftUI
import Firebase
import SafariServices

class VINSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, VINPlateDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
        "Ads",
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
    
    @objc dynamic var keysSection2: [String] = [
        "Japanese History Check",
        //        "Order Verification Letter & Dash Plaque"
    ]
    
    @objc dynamic var keysSection3: [String] = []
    
    @objc dynamic var keysSection4: [String] = [
        "VIN Ranges",
        "Production Numbers",
        "New Pricing"
    ]
    
    var titleString: String = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        headerView.delegate = self
        
        
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
            titleString = "BNR32 VIN Search"
            keysSection0.insert("Extended Model Code", at: keysSection0.firstIndex(of: "Interior Code")!)
            keysSection0.remove(at: keysSection0.firstIndex(of: "Seat")!)
            
        case "R33":
            highestModelNumberIndex = 15
            titleString = "BCNR33 VIN Search"
            
        case "R34":
            highestModelNumberIndex = 15
            titleString = "BNR34 VIN Search"
            imageView.contentMode = .scaleAspectFill
            keysSection0.remove(at: keysSection0.firstIndex(of: "Interior Code")!)
            
        default:
            highestModelNumberIndex = 1
        }
        
        headerView.setTitle(to: titleString)
        
        for int in 1...highestModelNumberIndex {
            keysSection3.append("\(int)")
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
        print("did layout subviews")
        vinPlate.rootView.series = series!
        vinPlate.rootView.delegate = self
        vinPlate.rootView.imageName = "\(series!)VinPlate"
        vinPlate.view.backgroundColor = .clear
        
        let sidePad = 10
        let topPad = 10
        let width = Int(self.view.bounds.width) - (sidePad * 2)
        
        // This should be a square otherwise the layout shifts to the left
        vinPlate.view.frame = CGRect(x: sidePad, y: Int(searchField.frame.maxY) + topPad, width: width, height: Int(tableView.frame.height))
        
        let recog = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        vinPlate.view.addGestureRecognizer(recog)
        
        self.view.addSubview(vinPlate.view)
        
        let const = NSLayoutConstraint(item: vinPlate.view, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 20)
        self.view.addConstraint(const)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        toolbar.barStyle = .default
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(doASearch), for: .touchUpInside)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.titleLabel?.font = UIFont(name: "NissanOpti", size: 12)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.allowsDefaultTighteningForTruncation = true
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
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
        guard let image = imageView.image else { return }
        let imageRatio: CGFloat = image.size.height / image.size.width
        imageView.frame.size.height = self.view.frame.width * imageRatio
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if searchField.text == searchPrefix && string == "" {
            print("p1")
            return false
        }
        
        let allowedChars = NSCharacterSet.alphanumerics
        var flag = true
        for char in string {
            if allowedChars.contains(UnicodeScalar(String(char))!) == false {
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
            let text = textField.text?.replacingOccurrences(of: lastSearchPrefix, with: "")
            textField.text = "\(searchPrefix)\(text!)"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButton(searchButton)
        return true
    }
    
    @objc func doASearch() {
        guard let query = self.searchField.text else { return }
        
        DispatchQueue.main.async {
            self.searchField.resignFirstResponder()
            self.vinPlate.view.alpha = 0
            self.imageView.image = nil 
            self.spinner.isHidden = false
            self.spinner.startAnimating()
        }
        
        DispatchQueue.global().async {
            
            let dbMan = DBManager()
            
            switch self.series! {
            case "R32":
                let searchResult = dbMan.readVINDataFromDB(tableName: self.series!, attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: query, fuzzy: false)
                if !searchResult.isEmpty {
                    self.searchResult = searchResult.first as! R32
                } else {
                    self.searchResult = nil
                    print("No result")
                }
            case "R33":
                let searchResult = dbMan.readVINDataFromDB(tableName: self.series!, attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: query, fuzzy: false)
                if !searchResult.isEmpty {
                    self.searchResult = searchResult.first as! R33
                } else {
                    self.searchResult = nil
                    print("No result")
                }
            case "R34":
                let searchResult = dbMan.readVINDataFromDB(tableName: self.series!, attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: query, fuzzy: false)
                if !searchResult.isEmpty {
                    self.searchResult = searchResult.first as! R34
                } else {
                    self.searchResult = nil
                    print("No result")
                }
            default:
                self.searchResult = nil
            }
            
            guard self.searchResult != nil else {
                self.vinPlate.rootView.failedSearch = true
                self.vinPlate.view.alpha = 1
                self.spinner.stopAnimating()
                
                UIView.animate(withDuration: 0.5) {
                    self.vinPlate.view.alpha = 1
                }
                self.imageView.image = nil
                self.imageView.frame.size.height = 0
                self.tableView.reloadData()
                return
            }
            
            // From this point, the search is successful
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                UIView.animate(withDuration: 0.1) {
                    self.vinPlate.view.alpha = 0
                }
                
                
                
                let colourPath = self.searchResult!.ColourPath
                let filename = colourPath.components(separatedBy: "\\").last?.components(separatedBy: ".").first
                let filetype = colourPath.components(separatedBy: "\\").last?.components(separatedBy: ".").last
                
                if let path = Bundle.main.path(forResource: filename, ofType: filetype) {
                    if let img = UIImage(contentsOfFile: path) {
                        self.imageView.image = img
                        let desiredImageViewAspectRatio: CGFloat = img.size.height / img.size.width
                        
                        UIView.animate(withDuration: 0.2) {
                            self.imageView.frame.size.height = self.view.frame.width * desiredImageViewAspectRatio
                            self.view.layoutIfNeeded()
                        }
                    }
                } else {
                    print("Image path not found for \(colourPath)")
                    self.imageView.image = nil
                    UIView.animate(withDuration: 0.2) {
                        self.imageView.frame.size.height = 0
                        self.view.layoutIfNeeded()
                    }
                }
                
                self.searchResult!.getNumbers(generation: self.series!)
                self.tableView.reloadData()
            }
        }
    }
    
    func share() {
        // Take a screenshot, or render a new image how we want it
        guard searchResult != nil else { return }
        
        let image = takeScreenshot(shouldSave: false)
        
        // Present a share sheet
        let activityVC = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = headerView
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
        
        var view = ScreenshotView(title: titleString)
        view.setup(title: "\(series!) \(searchResult!.Grade)",
                   vin: searchResult?.VIN,
                   grade: searchResult?.Grade,
                   colourText: searchResult?.Colour,
                   productionDate: searchResult?.ProductionDate,
                   modelCode: searchResult?.modelCode,
                   seat: searchResult?.Seat,
                   carImage: imageView.image,
                   interiorCode: searchResult?.InteriorCode)
        
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
        if searchResult == nil {
            return 0
        } else {
            return sectionNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard searchResult != nil else {
            print("SearchResult is empty")
            return 0
        }
        
        switch section {
        case 0:
            return keysSection0.count
        case 1:
            return keysSection1.count
        case 2:
            return keysSection2.count
        case 3:
            return keysSection3.count
        case 4:
            return keysSection1.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // Search Result
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
            
        case 1:
            // Your production number
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
            
        case 2:
            // Ads
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = (value(forKey: "keysSection\(indexPath.section)") as! [String])[indexPath.row]
            cell.textLabel?.font = UIFont(name: "NissanOpti", size: 10)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .white
            cell.accessoryType = .none
            cell.contentView.backgroundColor = UIColor(named: "torqueGTred")
            return cell
            
        case 3:
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
        case 4:
            // Links
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = (value(forKey: "keysSection\(indexPath.section)") as! [String])[indexPath.row]
            cell.textLabel?.font = UIFont(name: "NissanOpti", size: 10)
            cell.textLabel?.textColor = .black
            cell.textLabel?.textAlignment = .left
            cell.contentView.backgroundColor = .white
            return cell
        default:
            // Should never happen
            fatalError("Invalid section")
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
        if section == 2 {
            return nil
        }
        
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
        case 3:
            return 80
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 2:
            // Ads
            switch indexPath.row {
            case 0:
                handleJapaneseHistoryCheckButton()
            case 1:
                handleDashPlaqueButton()
            default:
                break
            }
        case 4:
            // Links
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

extension VINSearchController {
    func handleJapaneseHistoryCheckButton() {
        if let url = URL(string: BaseURL.japaneseHistoryCheck + "?vin=\(searchResult?.VIN ?? "")") {
            let webView = SFSafariViewController(url: url)
            self.present(webView, animated: true)
            Analytics.logEvent(AnalyticsEventViewItem,
                               parameters: [AnalyticsParameterItemName: "Japanese History Check Website"])
        }
    }
    
    func handleDashPlaqueButton() {
        if let url = URL(string: BaseURL.dashPlaque) {
            let webView = SFSafariViewController(url: url)
            self.present(webView, animated: true)
            Analytics.logEvent(AnalyticsEventViewItem,
                               parameters: [AnalyticsParameterItemName: "Dash Plaque Website"])
        }
    }
}
