//
//  ModelInfoController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 31/10/20.
//

import UIKit

class ModelInfoController: UIViewController {

    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var modelNameLabel: UILabel!
    @IBOutlet weak var modelCodeLabel: UILabel!
    var modelCode: String?
    
    let tempModelDict = [
        "BNR32" : "R32 GT-R",
        "BCNR33" : "R33 GT-R",
        "BNR34" : "R34 GT-R"
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
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
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
