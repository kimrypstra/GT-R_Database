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
    
    var series: String! // R32,R33,R34
    var specialModelName: String! // M-Spec Nür (special chars included, this is display text)
    
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
        populateImages()
        
        do {
            //let text = try String(contentsOfFile: path)
            if let text = getModelInfoText() {
                textView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
                let firstLine = text.components(separatedBy: "\n").first?.replacingOccurrences(of: "\r", with: "")
                var displayText = text.replacingOccurrences(of: firstLine!, with: "")
                displayText = displayText.replacingOccurrences(of: "\t\t", with: ": ")
                displayText = displayText.replacingOccurrences(of: "*", with: "●")
                textView.text = displayText
            }
        } catch let error {
            print("Error: \(error)")
        }
        
    }
    
    func populateImages() {
        if let path = imagePaths["\(series!) \(specialModelName!)"] {
            var filenames = getContentsOfFolder(path: path)
            // Then populate image views with images
            
            if let coverImage = UIImage(contentsOfFile: "\(path)/cover.jpg") {
                filenames.removeAll(where: {$0 == "cover.jpg"})
                imageView.image = coverImage
                let imageRatio: CGFloat = coverImage.size.height / coverImage.size.width
                self.imageViewHeight.constant = self.view.frame.width * imageRatio
            } else {
                print("Couldn't find cover image for \(path)/cover.jpg")
            }
            
            let brochureImages = filenames.filter({$0.contains("brochure")})
            print("Found \(brochureImages.count) brochure images")
            filenames.removeAll(where: {$0.contains("brochure")})
            
            print("Found \(filenames.filter({$0.contains(".jpg")}).count) miscellaneous images")
            
        } else {
            print("Coudn't get imagePath")
        }
    }
    
    func getModelInfoText() -> String? {
        if let path = imagePaths["\(series!) \(specialModelName!)"] {
            do {
                let text = try String(contentsOfFile: "\(path)/\(specialModelName!).txt")
                return text
            } catch let error {
                print("Coudn't get string for \(path): \(error)")
                return nil
            }
        } else {
            print("Couldn't get path for text file")
            return nil
        }
    }
    
    func getContentsOfFolder(path: String) -> [String] {
        let fm = FileManager()
        do {
            let contents = try fm.contentsOfDirectory(atPath: path)
            return contents
        } catch let error {
            print("Error getting folder contents: \(error)")
            return []
        }
    }
    
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
