//
//  SpecialModelViewController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 21/11/20.
//

import UIKit
import CocoaMarkdown
import Firebase

class SpecialModelViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topBannerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var brochureScrollView: UIScrollView!
    @IBOutlet weak var miscScrollView: UIScrollView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var brochureHeight: NSLayoutConstraint!
    @IBOutlet weak var miscHeight: NSLayoutConstraint!
    
    @IBOutlet weak var miscLabel: UILabel!
    @IBOutlet weak var brochureLabel: UILabel!
    
    var series: String? // R32,R33,R34
    var specialModelName: String! // M-Spec Nür (special chars included, this is display text)
    var brochureImages: [UIImage] = []
    var miscImages: [UIImage] = []
    let ind = UIPageControl()
    var timer: Timer? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient = CAGradientLayer()
        gradient.frame = topBannerView.bounds
        gradient.colors = [UIColor().bannerTopColour.cgColor, UIColor().bannerBottomColour.cgColor]
        topBannerView.layer.insertSublayer(gradient, at: 0)
        stackView.alpha = 0 // Hide the stack view because otherwise we see the images flying down when the screen loads
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = specialModelName
        
        let text = getModelInfoText()
        if text == "" {
            textViewHeight.constant = 0
        }
        
        
        
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let parsed = CMDocument(string: text, options: .hardBreaks)
        
        let attr = CMTextAttributes()
        // MARK:- Font and Paragraph Attributes
        
        // Headers
        attr.addFontAttributes([.family : "NissanOpti", .size : 16], forElementWithKinds: .header1)
        attr.addFontAttributes([.family : "NissanOpti", .size : 14], forElementWithKinds: .header2)
        attr.addFontAttributes([.family : "NissanOpti", .size : 12], forElementWithKinds: .header3)
        attr.addFontAttributes([.family : "Futura", .size : 16, .face : "Bold"], forElementWithKinds: .header4)
        attr.addFontAttributes([.family : "NissanOpti", .size : 14], forElementWithKinds: .header5)
        
        attr.addParagraphStyleAttributes([.firstLineHeadExtraIndent : 25, .headExtraIndent : 10], forElementWithKinds: .header5)
        
        // Unordered List
        attr.addParagraphStyleAttributes([.firstLineHeadExtraIndent : 10, .headExtraIndent : 10], forElementWithKinds: .unorderedList)
        attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .unorderedList)
        
        // Unordered Sublist
        attr.addParagraphStyleAttributes([.firstLineHeadExtraIndent : 20, .headExtraIndent : 10], forElementWithKinds: .unorderedSublist)
        attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .unorderedSublist)
        let bullet = attr.unorderedListAttributes.paragraphStyleAttributes[CMParagraphStyleAttributeName.listItemBulletString]
        attr.addParagraphStyleAttributes([.listItemBulletString : bullet], forElementWithKinds: .unorderedSublist)
        
        // Inline Code
        attr.addParagraphStyleAttributes([.alignment : NSTextAlignment.right.rawValue], forElementWithKinds: .inlineCode)
        attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .inlineCode)
        
        // Text
        attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .text)
        
        
        // MARK:- END
        
        // MARK: Render textView text
        let renderer = CMAttributedStringRenderer(document: parsed, attributes: attr)
        textView.attributedText = renderer!.render()
        
        let bDoc = CMDocument(string: "##### Brochure", options: .hardBreaks)
        let bRend = CMAttributedStringRenderer(document: bDoc, attributes: attr)
        brochureLabel.attributedText = bRend?.render()
        
        let mDoc = CMDocument(string: "##### Miscellaneous Images", options: .hardBreaks)
        let mRend = CMAttributedStringRenderer(document: mDoc, attributes: attr)
        miscLabel.attributedText = mRend?.render()
        
        populateImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stackView.alpha = 1 // Unhide the stack view since it's out of sight now
        guard series != nil else {
            print("Series is nil?")
            Analytics.logEvent("NilValue", parameters: ["variable" : "series", "screen" : "SpecialModelViewController"])
            return
        }
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: "Special Model Screen",
                                        "Series" : "\(series!)",
                                        "Name" : "\(specialModelName!)"])
    }
    
    func populateImages() {
        // First, construct the filepath based on the car informaiton
        if let path = assetPaths["\(series!) \(specialModelName!)"] {
            // Get a list of all files in the folder
            var filenames = getContentsOfFolder(path: path)
            
            // Then populate image views with images...
            // Cover image
            if let coverImage = UIImage(contentsOfFile: "\(path)/cover.jpg") {
                filenames.removeAll(where: {$0 == "cover.jpg"})
                imageView.image = coverImage
                let imageRatio: CGFloat = coverImage.size.height / coverImage.size.width
                self.imageViewHeight.constant = self.view.frame.width * imageRatio
            } else {
                print("Couldn't find cover image for \(path)/cover.jpg")
            }
            
            // Extract brochure image filenames and sort...
            var brochureImageFilenames = filenames.filter({$0.contains("brochure")})
            filenames.removeAll(where: {$0.contains("brochure")})
            brochureImageFilenames.sort(by: {$0 < $1})
            
            // if some brochure images are found...
            if brochureImageFilenames.count > 0 {
                // Generate a scroll view in code and fill it with brochure images, then add it to the stack view
                for filename in brochureImageFilenames {
                    if let image = UIImage(contentsOfFile: "\(path)\(filename)") {
                        brochureImages.append(image)
                    } else {
                        print("Couldn't find image for: \(path)\(filename)")
                    }
                }

                let largestImage = brochureImages.sorted(by: {$0.size.height > $1.size.height}).first!
                let largestAspect = largestImage.size.height / largestImage.size.width
                brochureHeight.constant = self.view.bounds.width * largestAspect
                
                // Add the brochure scrollView
                let brochureTotalWidth: CGFloat = CGFloat(brochureImages.count) * self.view.frame.width
                
                brochureScrollView.isPagingEnabled = true
                brochureScrollView.bounces = false
                brochureScrollView.showsVerticalScrollIndicator = false
                brochureScrollView.showsHorizontalScrollIndicator = false
                brochureScrollView.delegate = self
                brochureScrollView.contentSize = CGSize(width: brochureTotalWidth, height: brochureHeight.constant)
                //brochureHeight.constant = brochureScrollView.contentSize.height
                
                for (index, image) in brochureImages.enumerated() {
                    let aspect = image.size.height / image.size.width
                    let view = UIImageView(image: image)
                    view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width * aspect)
                    view.frame.origin.x = CGFloat((Int(brochureTotalWidth) / brochureImages.count) * (index))
                    view.contentMode = .scaleAspectFit
                    brochureScrollView.addSubview(view)
                }
            } else {
                stackView.arrangedSubviews[0].isHidden = true
                stackView.arrangedSubviews[1].isHidden = true
                //stackViewHeight.constant = miscHeight.constant + 30
            }
            
            // For misc images, first get everything that remains except the text
            filenames.sort(by: {$0 < $1})
            for filename in filenames where !filename.contains(".md") {
                if let image = UIImage(contentsOfFile: "\(path)\(filename)") {
                    miscImages.append(image)
                } else {
                    print("Could not find image for \(path)\(filename)")
                }
            }
            
            filenames.removeAll()
            
            if miscImages.count > 0 {
                print("Misc count: \(miscImages.count)")
                // Set misc images scroll view to only be as tall as it needs to be to show the biggest image
                let largestImage = miscImages.sorted(by: {$0.size.height > $1.size.height}).first!
                let largestAspect = largestImage.size.height / largestImage.size.width
                miscHeight.constant = self.view.bounds.width * largestAspect
                
                let miscTotalWidth: CGFloat = CGFloat(miscImages.count) * self.view.bounds.width
                
                miscScrollView.isPagingEnabled = true
                miscScrollView.bounces = false
                miscScrollView.showsVerticalScrollIndicator = false
                miscScrollView.showsHorizontalScrollIndicator = false
                miscScrollView.delegate = self
                miscScrollView.contentMode = .top
                miscScrollView.contentSize = CGSize(width: miscTotalWidth, height: miscHeight.constant)
                
                for (index, image) in miscImages.enumerated() {
                    let view = UIImageView(image: image)
                    let imageAspect =  image.size.height / image.size.width
                    view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width * imageAspect)
                    view.frame.origin.x = CGFloat((Int(miscTotalWidth) / miscImages.count) * (index))
                    view.contentMode = .scaleAspectFit
                    miscScrollView.addSubview(view)
                }
                print("Misc count subviews: \(miscScrollView.subviews.count)")
            } else {
                // If there are no misc images...
                stackView.arrangedSubviews[2].isHidden = true
                stackView.arrangedSubviews[3].isHidden = true
                //stackViewHeight.constant = brochureHeight.constant + 30
            }
            
            // Size the stackView height to match the content
            setStackViewHeight(scrollToBottom: false, of: nil)
            
            
            //            // If there are both misc and brochure images, size the stackView to accomodate both
            //            if miscImages.count != 0 && brochureImages.count != 0 {
            //                stackViewHeight.constant = miscHeight.constant + brochureHeight.constant + 60
            //            } else if miscImages.count == 0 && brochureImages.count == 0 {
            //                // If there are no images, get rid of the stackView
            //                // Note: Don't remove it from superview as it breaks it for some reason
            //                stackViewHeight.constant = 0
            //            }
            //
            //self.view.layoutIfNeeded()
            
        } else {
            print("Coudn't get imagePath. Ensure there's an entry for this model in Constants.swift")
        }
    }
    
    func setStackViewHeight(scrollToBottom: Bool, of view: UIScrollView?) {
        let prevHeight = stackViewHeight.constant
        stackViewHeight.constant = 0
        if miscImages.count != 0 {
            stackViewHeight.constant += miscHeight.constant + miscLabel.frame.height
        }
        if brochureImages.count != 0 {
            stackViewHeight.constant += brochureHeight.constant + brochureLabel.frame.height
        }
        if brochureImages.count != 0 && miscImages.count != 0 {
            // Add the padding to accound for the miscLabel
            //stackViewHeight.constant += 60
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { (_) in
            if prevHeight < self.stackViewHeight.constant && scrollToBottom == true {
                guard view != nil else {
                    print("View is nil")
                    return
                }
                
                if let origin = view!.superview {
                    // Get the Y position of your child view
                    let childStartPoint = origin.convert(view!.frame.origin, to: self.mainScrollView)
                    // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
                    self.mainScrollView.scrollRectToVisible(CGRect(x:0, y: childStartPoint.y, width: 1, height: self.mainScrollView.frame.height), animated: true)
                }
                
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        timer?.invalidate()
        UIView.animate(withDuration: 0.5) {
            self.ind.alpha = 1
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Adjust the height if necessary to accomodate bigger images
        if scrollView == brochureScrollView {
            let page = Int(scrollView.contentOffset.x / scrollView.contentSize.width * CGFloat(brochureImages.count))
            print("Brochure page: \(page)")
            let image = brochureImages[page]
            let aspect = image.size.height / image.size.width
            let scaledImageHeight = scrollView.frame.width * aspect
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {
                self.brochureHeight.constant = scaledImageHeight
                self.brochureScrollView.contentSize.height = scaledImageHeight
                self.view.layoutIfNeeded()
            }
            setStackViewHeight(scrollToBottom: false, of: brochureScrollView)
        } else if scrollView == miscScrollView {
            let page = Int(scrollView.contentOffset.x / scrollView.contentSize.width * CGFloat(miscImages.count))
            let image = miscImages[page]
            let aspect = image.size.height / image.size.width
            let scaledImageHeight = scrollView.frame.width * aspect
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {
                self.miscHeight.constant = scaledImageHeight
                self.miscScrollView.contentSize.height = scaledImageHeight
                self.view.layoutIfNeeded()
            }
            setStackViewHeight(scrollToBottom: false, of: miscScrollView)
        }
    }
    
    func getModelInfoText() -> String {
        if let path = assetPaths["\(series!) \(specialModelName!)"] {
            do {
                let text = try String(contentsOfFile: "\(path)/\(specialModelName!).md")
                return text
            } catch let error {
                print("Coudn't get string for \(path): \(error)")
                return ""
            }
        } else {
            print("Couldn't get path for text file")
            return ""
        }
    }
    
    func getContentsOfFolder(path: String) -> [String] {
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: path)
            
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
