//
//  SpecialModelViewController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 21/11/20.
//

import UIKit

class SpecialModelViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    var specialModelName: String!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        gradient.frame = topBannerView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerView.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = specialModelName
        
        // Extract the image name
        if let path = Bundle.main.path(forResource: specialModelName, ofType: "txt") {
            do {
                let text = try String(contentsOfFile: path)
                
                textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
                let firstLine = text.components(separatedBy: "\n").first?.replacingOccurrences(of: "\r", with: "")
                let imageName = firstLine?.components(separatedBy: "\\").last
                let imageNamePrefix = imageName?.components(separatedBy: ".").first
                if let imagePath = Bundle.main.path(forResource: imageNamePrefix, ofType: "jpg") {
                    let image = UIImage(contentsOfFile: imagePath)
                    imageView.image = image
                    
                    let imageRatio: CGFloat = image!.size.height / image!.size.width

                    self.imageViewHeight.constant = self.view.frame.width * imageRatio
                    self.view.layoutIfNeeded()
                    
                } else {
                    print("Can't get path for image")
                }
                
                // TODO: Some way for the double tab indented information to line up
                
                /*
                 
                
                 
                let displayText = NSMutableAttributedString(string: text.replacingOccurrences(of: firstLine!, with: ""))
                let para = NSMutableParagraphStyle()
                para.alignment = NSTextAlignment.left
                var tabRanges: [NSRange] = []
                do {
                    let regex = try NSRegularExpression(pattern: "\t\t", options: .caseInsensitive)
                    let results = regex.matches(in: displayText.string, options: .withTransparentBounds, range: NSMakeRange(0, displayText.length))
                    for result in results {
                        tabRanges.append(result.range)
                    }
                    for range in tabRanges {
                        var counter = 0
                        var end = false
                        while end == false {
                            let char = displayText.mutableString.substring(with: NSMakeRange(range.location + range.length + counter, 1))
                            print(char)
                            if char == "\r" {
                                end = true
                            } else {
                                counter += 1
                            }
                        }
                        displayText.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(range.location + 1, range.location + counter))
                    }
                    
                } catch let error {
                    print("Regex Error: \(error)")
                }
                
                print("Discovered \(tabRanges.count) double tabs")
                */
                
                
                
                var displayText = text.replacingOccurrences(of: firstLine!, with: "")
                displayText = displayText.replacingOccurrences(of: "\t\t", with: ": ")
                displayText = displayText.replacingOccurrences(of: "*", with: "●")
                    
                textView.text = displayText
                
            } catch let error {
                print("Error: \(error)")
            }
            
        } else {
            print("Text path not found")
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
