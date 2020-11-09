//
//  VINSearchResultController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 7/11/20.
//

import UIKit

class VINSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    var searchResult: R34?
    var searchPrefix = "BNR34-"
    
    var map: [String : String] = [
        "VIN" : "VIN",
        "Grade" : "Grade",
        "Colour" : "Colour",
        "Model Number" : "modelCode",
        "Plant" : "Plant",
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
        "18" : "Model15"
    ]
    
    let sectionNames = [
        "Result",
        "Production",
        "Model Code",
        "VIN Ranges",
        "Production Numbers",
        "More Information"
    ]
    
    
    @objc dynamic var keysSection0: [String] = [
        "VIN",
        "Grade",
        "Colour",
        "Production Date",
        "Model Number"
    ]
    
    @objc dynamic var keysSection1: [String] = [
        "Number in Grade",
        "Number in Colour",
        "Plant"
    ]
    
    @objc dynamic var keysSection2: [String] = [
        "1",
        "2-3",
        "4",
        "5",
        "6",
        "7",
        "8-10",
        "11",
        "12",
        "13",
        "14",
        "15",
        "16",
        "17",
        "18"
    ]
    
    @objc dynamic var keysSection3: [String] = [
        "VIN Ranges"
    ]
    
    @objc dynamic var keysSection4: [String] = [
        "Production Numbers"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        searchField.text = searchPrefix //This needs to adapt to the series
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        let imageRatio = imageView.image!.size.height / imageView.image!.size.width

        imageViewHeight.constant = (self.view.frame.width * imageRatio) - (scrollView.contentOffset.y)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if searchField.text == searchPrefix && string == "" {
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
        
        let prefix = "BNR34-"
        let commonPrefix = textField.text?.commonPrefix(with: prefix)
        if commonPrefix == prefix {
            print("IS OK")
        } else {
            print("IS NO OK")
            textField.text = "\(prefix)\(textField.text!)"
        }
    }
    
    func doASearch() {
        let dbMan = DBManager()
        
        guard searchField.text != nil else {return}
        
        searchResult = dbMan.readVINDataFromDB(tableName: "R34", attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: searchField.text!, fuzzy: false).first
        
        guard searchResult != nil else {
            return
        }
        
        let colourPath = searchResult!.ColourPath
        let filename = colourPath.components(separatedBy: "\\").last?.components(separatedBy: ".").first
        let filetype = colourPath.components(separatedBy: "\\").last?.components(separatedBy: ".").last
        
        if let path = Bundle.main.path(forResource: filename, ofType: filetype) {
            imageView.image = UIImage(contentsOfFile: path)
        } else {
            print("Path not found")
        }
        
        let imageRatio = imageView.image!.size.height / imageView.image!.size.width
        
        UIView.animate(withDuration: 0.2) {
            
            self.imageViewHeight.constant = self.view.frame.width * imageRatio
            self.view.layoutIfNeeded()
        }
        
        searchResult!.getNumbers()
        tableView.reloadData()
        //tableView.reloadSections([0], with: .top)
//        self.tableView.performBatchUpdates({
//                self.tableView.insertRows(at: [IndexPath(row: self.keysSection0.count - 1,
//                                                         section: 0)],
//                                          with: .automatic)
//            }, completion: nil)

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
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "modelNumberCell") as! ModelNumberCell
            cell.label.text = (value(forKey: "keysSection\(indexPath.section)") as! [String])[indexPath.row]
            let codeValue = searchResult!.value(forKey: "Model\(indexPath.row + 1)") as! String
            cell.code.text = codeValue
            let keys = value(forKey: "keysSection\(indexPath.section)") as! [String]
            cell.value.text = "\(searchResult!.value(forKey: map[keys[indexPath.row]]!)!)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "smallCell") as! SmallCell
            cell.label.text = (value(forKey: "keysSection\(indexPath.section)") as! [String])[indexPath.row]
            let keys = value(forKey: "keysSection\(indexPath.section)") as! [String]
            cell.value.text = "\(searchResult!.value(forKey: map[keys[indexPath.row]]!)!)"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 30))
        label.text = sectionNames[section]
        label.font = UIFont(name: "NissanOpti", size: 15)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
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
