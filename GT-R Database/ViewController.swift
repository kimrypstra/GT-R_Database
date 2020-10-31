//
//  ViewController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 31/10/20.
//

import UIKit

@IBDesignable

extension UIColor {
    var bannerTopColour: UIColor {
        return UIColor(displayP3Red: 39/255, green: 39/255, blue: 39/255, alpha: 1)
    }
    
    var bannerBottomColour: UIColor {
        return UIColor(displayP3Red: 21/255, green: 21/255, blue: 21/255, alpha: 1)
    }
}

extension UILabel {
    func dim() {
        UIView.animate(withDuration: 1) {
            self.textColor = .lightGray
        }
    }
    
    func undim() {
        UIView.animate(withDuration: 1) {
            self.textColor = .black
        }
    }
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var topBannerBackgroundView: UIView!
    
    @IBOutlet weak var r32Stack: UIStackView!
    @IBOutlet weak var r32label1: UILabel!
    @IBOutlet weak var r32label2: UILabel!
    
    @IBOutlet weak var r33Stack: UIStackView!
    @IBOutlet weak var r33label1: UILabel!
    @IBOutlet weak var r33label2: UILabel!
    
    @IBOutlet weak var r34Stack: UIStackView!
    @IBOutlet weak var r34label1: UILabel!
    @IBOutlet weak var r34label2: UILabel!
    
    var labels: [UILabel] = []
    var selectedModel: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up top banner
        let gradient = CAGradientLayer()
        gradient.frame = topBannerBackgroundView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerBackgroundView.layer.insertSublayer(gradient, at: 0)
        
        // Set up gesture recognizers
        let r32recog = UITapGestureRecognizer(target: self, action:"didTapR32")
        r32recog.name = "r32"
        r32Stack.addGestureRecognizer(r32recog)
        
        let r33recog = UITapGestureRecognizer(target: self, action:"didTapR33")
        r33recog.name = "r33"
        r33Stack.addGestureRecognizer(r33recog)
        
        let r34recog = UITapGestureRecognizer(target: self, action:"didTapR34")
        r34recog.name = "r34"
        r34Stack.addGestureRecognizer(r34recog)
        
        // Intialise label list
        labels = [
            r32label1,
            r32label2,
            r33label1,
            r33label2,
            r34label1,
            r34label2
        ]
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch touches.first?.gestureRecognizers?.first?.name {
        case "r32":
            r32label1.dim()
            r32label2.dim()
        case "r33":
            r33label1.dim()
            r33label2.dim()
        case "r34":
            r34label1.dim()
            r34label2.dim()
        default:
            print("Unknown recognizer name")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for label in labels {
            label.undim()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for label in labels {
            label.undim()
        }
    }
    
    @objc func didTapR32() {
        selectedModel = "BNR32"
        self.performSegue(withIdentifier: "modelInfo", sender: self)
    }
    
    @objc func didTapR33() {
        selectedModel = "BCNR33"
        self.performSegue(withIdentifier: "modelInfo", sender: self)

    }
    
    @objc func didTapR34() {
        selectedModel = "BNR34"
        self.performSegue(withIdentifier: "modelInfo", sender: self)

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if selectedModel == "BNR32" || selectedModel == "BCNR33" || selectedModel == "BNR34" {
            return true
        } else if identifier == "about" {
            return true
        } else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "modelInfo":
            let IVC = segue.destination as! ModelInfoController
            IVC.modelCode = selectedModel
        default:
            print("Unknown segue identifier")
        }
    }
}

