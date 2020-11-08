//
//  VINSearchResultController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 7/11/20.
//

import UIKit

class VINSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchField: UITextField!
    
    var searchResult: [R34] = []
    
    var map: [String : String] = [
        "VIN" : "VIN",
        "Grade" : "Grade",
        "Colour" : "Colour",
        "Model Number" : "modelCode",
        "Plant" : "Plant",
        "Seat" : "Seat",
        "Production Date" : "ProductionDate",
        "numberInSeries" : "numberInSeries",
        "numberInColour" : "numberInColour",
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
        "numberInSeries",
        "numberInColour",
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ModelNumberCell.self, forCellReuseIdentifier: "modelNumberCell")
        tableView.register(SmallCell.self, forCellReuseIdentifier: "smallCell")
        tableView.reloadData()
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        doASearch()
    }
    
    func doASearch() {
        let dbMan = DBManager()
        
        guard searchField.text != nil else {return}
        
        searchResult = dbMan.readVINDataFromDB(tableName: "R34", attributesToRetrieve: [], attributeToSearch: "VIN", valueToSearch: searchField.text!, fuzzy: false)
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard searchResult.count > 0 else {
            print("SearchResult is empty")
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
        guard searchResult.count > 0 else {
            print("SearchResult is empty")
            return 0
        }
        return (value(forKey: "keysSection\(section)") as! [String]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "modelNumberCell") as! ModelNumberCell
            cell.label.text = (value(forKey: "keysSection\(indexPath.section)") as! [String])[indexPath.row]
            let codeValue = searchResult.first!.value(forKey: "Model\(indexPath.row + 1)") as! String
            cell.code.text = codeValue
            let keys = value(forKey: "keysSection\(indexPath.section)") as! [String]
            cell.value.text = "\(searchResult.first!.value(forKey: map[keys[indexPath.row]]!)!)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "smallCell") as! SmallCell
            cell.label.text = (value(forKey: "keysSection\(indexPath.section)") as! [String])[indexPath.row]
            let keys = value(forKey: "keysSection\(indexPath.section)") as! [String]
            cell.value.text = "\(searchResult.first!.value(forKey: map[keys[indexPath.row]]!)!)"
            
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
