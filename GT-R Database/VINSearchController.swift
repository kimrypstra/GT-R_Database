//
//  VINSearchResultController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 7/11/20.
//

import UIKit

class VINSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var searchResult: [R34] = [R34()]
    
    var map: [String : String] = [
        "VIN" : "VIN",
        "Grade" : "Grade",
        "Colour" : "Colour",
        "Model Number" : "modelCode",
        "Plant" : "Plant",
        "Seat" : "Seat",
        "ProductionDate" : "ProductionDate"
    ]
    
    @objc dynamic var keysSection0: [String] = [
        "VIN",
        "Grade",
        "Colour",
        "Model Number"
    ]
    
    @objc dynamic var keysSection1: [String] = [
        "Plant"
    ]
    
    @objc dynamic var keysSection2: [String] = [
        "Seat",
        "ProductionDate"
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camel = "vin"
        print(camel.camelToHuman())
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SmallCell.self, forCellReuseIdentifier: "smallCell")
        doASearch()
        tableView.reloadData()
    }
    
    func doASearch() {
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
        return (value(forKey: "keysSection\(section)") as! [String]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "smallCell") as! SmallCell
        cell.label.text = (value(forKey: "keysSection\(indexPath.section)") as! [String])[indexPath.row]
        let keys = value(forKey: "keysSection\(indexPath.section)") as! [String]
        cell.value.text = "\(searchResult.first!.value(forKey: map[keys[indexPath.row]]!)!)"
        
        return cell
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
