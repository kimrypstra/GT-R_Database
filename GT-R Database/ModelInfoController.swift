//
//  ModelInfoController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 31/10/20.
//

import UIKit
import Firebase

class ModelInfoController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var modelCodeLabel: UILabel!
    var series: String?
    
    let tempModelDict = [
        "R32" : "R32 GT-R",
        "R33" : "R33 GT-R",
        "R34" : "R34 GT-R"
    ]
    
    @objc dynamic let R34TableViewData: [String : [String]] = [
        "" : ["VIN Search",
              "Production Numbers",
              "VIN Ranges",
              "New Pricing"],
        "Special Models" :
            ["M-Spec Nür",
             "V-Spec II Nür",
             "M-Spec",
             "V-Spec II N1",
             "V-Spec II",
             "V-Spec N1",
             "V-Spec",
             "Midnight Purple 3",
             "Midnight Purple 2"],
        "Non-Japanese Delivered" :
            ["Great Britain",
             "Hong Kong",
             "New Zealand",
             "Singapore"],
        "Nismo Cars" :
            ["Z-Tune",
             "Clubman Race Spec (CRS)",
             "F-Sport",
             "R-Tune",
             "S-Tune",
             "Sports Resetting",
             "Nismo Restored Car"
             ]
    ]
    

    
    @objc dynamic let R33TableViewData: [String : [String]] = [
        "" : ["VIN Search",
              "Production Numbers",
              "VIN Ranges",
              "New Pricing"],
        "Special Models" :
            ["V-Spec",
            "V-Spec N1",
            "GT-R LM Limited, V-Spec LM Limited",
            "Autech Version 40th Anniversary"],
        "Non-Japanese Delivered" :
            ["Great Britain"],
        "Nismo Cars" :
            ["400R",
            "GT-R LM",
            "Clubman Race Spec (CRS)",
            "Nismo Restored Car"]
    ]
    
    @objc dynamic let R32TableViewData: [String : [String]] = [
        "" : ["VIN Search",
              "Production Numbers",
              "VIN Ranges",
              "New Pricing"],
        "Special Models" :
            ["GT-R Nismo",
             "N1, V-Spec N1, V-Spec II N1",
             "V-Spec",
             "V-Spec II"],
        "Non-Japanese Delivered" :
            ["Australia"],
        "Nismo Cars" :
            ["Clubman Race Spec (CRS)",
            "Nismo Restored Car"]
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
        
    }
    
    override func viewDidLayoutSubviews() {
        // Set up top banner
        let gradient = CAGradientLayer()
        gradient.frame = topBannerView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modelCodeLabel.text = series
        modelNameLabel.text = tempModelDict[series!]
        imageView.image = UIImage(named: "\(series!.lowercased())side")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: "Model Info Screen",
                                        "Series" : "\(series!)"])
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let topBannerBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 75))
        topBannerBackgroundView.frame.size.width = topBannerBackgroundView.frame.width - (tableView.separatorInset.left * 2)
        topBannerBackgroundView.layer.cornerRadius = 10
        topBannerBackgroundView.clipsToBounds = true
        
        let view = UIView(frame: topBannerBackgroundView.frame)
        view.addSubview(topBannerBackgroundView)
        view.clipsToBounds = false
        
        let gradient = CAGradientLayer()
        gradient.frame = topBannerBackgroundView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerBackgroundView.layer.insertSublayer(gradient, at: 0)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        label.font = UIFont(name: "NissanOpti", size: 15)
        label.textColor = .white
        label.textAlignment = .center
        label.text = tempSectionNames[section]
        view.addSubview(label)
        label.center = view.center
        label.center.y -= 10
        
        view.layer.zPosition = -100
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else {
            return 50
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tempSectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = value(forKey: "\(series!)TableViewData") as! [String : [String]]
        return data[tempSectionNames[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = value(forKey: "\(series!)TableViewData") as! [String : [String]]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = data[tempSectionNames[indexPath.section]]![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "VINSearch", sender: self)
            case 1:
                self.performSegue(withIdentifier: "prodNumbers", sender: self)
            case 2:
                self.performSegue(withIdentifier: "VINRanges", sender: self)
            case 3:
                self.performSegue(withIdentifier: "newPricing", sender: self)
            default:
                print("Unknown cell selected")
                return
            }
        case 1:
            // Special Models
            self.performSegue(withIdentifier: "SpecialModel", sender: self)
        case 2:
            // Non-Japanese models
            self.performSegue(withIdentifier: "SpecialModel", sender: self)
            return
        case 3:
            // Nismo Models
            self.performSegue(withIdentifier: "SpecialModel", sender: self)
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "VINSearch":
            let IVC = segue.destination as! VINSearchController
            IVC.series = series
        case "SpecialModel":
            let IVC = segue.destination as! SpecialModelViewController
            IVC.specialModelName = tableView.cellForRow(at: tableView.indexPathForSelectedRow!)?.textLabel!.text
            IVC.series = series
        case "prodNumbers":
            let IVC = segue.destination as! TSVTableViewController
            IVC.mode = .Production
            IVC.series = series
        case "VINRanges":
            let IVC = segue.destination as! TSVTableViewController
            IVC.mode = .VIN
            IVC.series = series
        case  "newPricing" :
            let IVC = segue.destination as! TSVTableViewController
            IVC.mode = .Pricing
            IVC.series = series 
        default:
            print("Unimplemented")
            return
        }
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }
}
