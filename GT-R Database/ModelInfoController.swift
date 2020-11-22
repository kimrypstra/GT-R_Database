//
//  ModelInfoController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 31/10/20.
//

import UIKit

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modelCodeLabel.text = series
        modelNameLabel.text = tempModelDict[series!]
        imageView.image = UIImage(named: "\(series!.lowercased())side")
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 {
            
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
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            label.font = UIFont(name: "NissanOpti", size: 15)
            label.textColor = .white
            label.textAlignment = .center
            label.text = tempSectionNames[section]
            view.addSubview(label)
            label.center = view.center
            label.center.y -= 10
            
            view.layer.zPosition = -100
            
            return view
        } else {
            let label = UILabel()
            label.font = UIFont(name: "NissanOpti", size: 15)
            label.textColor = .black
            label.text = tempSectionNames[section]
            return label
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 50
        default:
            return 30
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegue(withIdentifier: "VINSearch", sender: self)
            default:
                print("Unimplemented")
                return
            }
        case 1:
            // Special Models
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
        default:
            print("Unimplemented")
            return
        }
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
    }
}
