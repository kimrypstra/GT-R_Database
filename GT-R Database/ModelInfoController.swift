//
//  ModelInfoController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 31/10/20.
//

import UIKit

class ModelInfoController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var modelCodeLabel: UILabel!
    var modelCode: String?
    
    let tempModelDict = [
        "BNR32" : "R32 GT-R",
        "BCNR33" : "R33 GT-R",
        "BNR34" : "R34 GT-R"
    ]
    
    let tempTableViewData: [String : [String]] = [
        "" : ["VIN Search", "Production Numbers", "VIN Ranges"],
        "Special Models" : ["M-Spec Nür", "V-Spec II Nür", "M-Spec", "V-Spec II N1", "V-Spec N1", "Midnight Purple 3", "Midnight Purple 2"],
        "Non-Japanese Delivered" : ["Great Britain", "Hong Kong", "New Zealand", "Singapore"],
        "Nismo Cars" : ["Z-Tune", "Clubman Race Spec (CRS)", "F-Sport", "R-Tune", "S-Tune", "Sports Resetting"]
    ]
    
    let tempSectionNames = [
        "",
        "Special Models",
        "Non-Japanese Delivered",
        "Nismo Cars"
    ]
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up top banner
        let gradient = CAGradientLayer()
        gradient.frame = topBannerView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerView.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modelCodeLabel.text = modelCode
        modelNameLabel.text = tempModelDict[modelCode!]
        imageView.image = UIImage(named: "\(modelCode!.lowercased())side")
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Table View Stuff
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return tempSectionNames[section]
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont(name: "NissanOpti", size: 15)
        label.textColor = .black
        label.text = tempSectionNames[section]
        return label
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tempSectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempTableViewData[tempSectionNames[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = tempTableViewData[tempSectionNames[indexPath.section]]![indexPath.row]
        //cell.selectedBackgroundView?.backgroundColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
