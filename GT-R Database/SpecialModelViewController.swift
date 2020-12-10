//
//  SpecialModelViewController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 21/11/20.
//

import UIKit
import CocoaMarkdown

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

    var series: String! // R32,R33,R34
    var specialModelName: String! // M-Spec Nür (special chars included, this is display text)
    var brochureImages: [UIImage] = []
    var miscImages: [UIImage] = []
    let ind = UIPageControl()
    var timer: Timer? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
     - Implement CocoaMarkdown
     - Add as many textviews as substrings we have and render markdown to them
     - Search for and split strings on any <<image tags>>
     - Add images to carousels
     */
    
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

        if let text = getModelInfoText() {
            textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            let parsed = CMDocument(string: text, options: .hardBreaks)
            
            let attr = CMTextAttributes()
            attr.addFontAttributes([.family : "NissanOpti", .size : 16], forElementWithKinds: .header1)
            attr.addFontAttributes([.family : "NissanOpti", .size : 14], forElementWithKinds: .header2)
            attr.addFontAttributes([.family : "NissanOpti", .size : 12], forElementWithKinds: .header3)
            attr.addFontAttributes([.family : "Futura", .size : 16, .face : "Bold"], forElementWithKinds: .header4)
            attr.addFontAttributes([.family : "NissanOpti", .size : 14], forElementWithKinds: .header5)
            
            attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .inlineCode)
            attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .text)
            attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .unorderedList)
            attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .unorderedSublist)
            
            attr.addParagraphStyleAttributes([.alignment : NSTextAlignment.right.rawValue], forElementWithKinds: .inlineCode)
            attr.addParagraphStyleAttributes([.firstLineHeadExtraIndent : 0, .headExtraIndent : 20], forElementWithKinds: .unorderedList)
            attr.addParagraphStyleAttributes([.firstLineHeadExtraIndent : 20, .headExtraIndent : 20], forElementWithKinds: .header5)

            //attr.addFontAttributes([.family : "NissanOpti", .size : 14], forElementWithKinds: .header1)

            let renderer = CMAttributedStringRenderer(document: parsed, attributes: attr)
        
            textView.attributedText = renderer!.render()
            
            //textViewHeight.constant = 600
            
            let bDoc = CMDocument(string: "##### Brochure", options: .hardBreaks)
            let bRend = CMAttributedStringRenderer(document: bDoc, attributes: attr)
        
            brochureLabel.attributedText = bRend?.render()
            
            let mDoc = CMDocument(string: "##### Miscellaneous Images", options: .hardBreaks)
            let mRend = CMAttributedStringRenderer(document: mDoc, attributes: attr)
            
            miscLabel.attributedText = mRend?.render()
        }
        
    }
    
    func populateImages() {
        if let path = imagePaths["\(series!) \(specialModelName!)"] {
            var filenames = getContentsOfFolder(path: path)
            print(miscScrollView.subviews)
            // Then populate image views with images
            
            if let coverImage = UIImage(contentsOfFile: "\(path)/cover.jpg") {
                filenames.removeAll(where: {$0 == "cover.jpg"})
                imageView.image = coverImage
                let imageRatio: CGFloat = coverImage.size.height / coverImage.size.width
                self.imageViewHeight.constant = self.view.frame.width * imageRatio
            } else {
                print("Couldn't find cover image for \(path)/cover.jpg")
            }
            
            let brochureImageFilenames = filenames.filter({$0.contains("brochure")})
            filenames.removeAll(where: {$0.contains("brochure")})
            
            print("Found \(brochureImages.count) brochure images")
            print("Found \(filenames.filter({$0.contains(".jpg")}).count) miscellaneous images")
            
            // Generate a scroll view in code and fill it with brochure images, then add it to the stack view
            
            for filename in brochureImageFilenames {
                let image = UIImage(contentsOfFile: "\(path)\(filename)")
                brochureImages.append(image!)
            }
            
            print("Added \(brochureImages.count) images")
            
            // Add the brochure scrollView
            
            let brochureTotalWidth: CGFloat = CGFloat(brochureImages.count) * self.view.frame.width
            print("total width: \(brochureTotalWidth)")

            //brochureScrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width)
            //brochureScrollView.backgroundColor = .systemTeal
            brochureScrollView.isPagingEnabled = true
            brochureScrollView.bounces = false
            brochureScrollView.showsVerticalScrollIndicator = false
            brochureScrollView.showsHorizontalScrollIndicator = false
            brochureScrollView.delegate = self
            
            print(brochureScrollView.frame.height)

            brochureScrollView.contentSize = CGSize(width: brochureTotalWidth, height: self.view.bounds.width)
            brochureHeight.constant = brochureScrollView.contentSize.height
            
            for (index, image) in brochureImages.enumerated() {
                let aspect = image.size.height / image.size.width
                let view = UIImageView(image: image)
                view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width * aspect)
                view.frame.origin.x = CGFloat((Int(brochureTotalWidth) / brochureImages.count) * (index))
                view.contentMode = .scaleAspectFit
                brochureScrollView.addSubview(view)
            }

            print(filenames)
            for filename in filenames where !filename.contains(".txt") {
                let image = UIImage(contentsOfFile: "\(path)\(filename)")
                miscImages.append(image!)
            }
            
            // Set misc images scroll view to only be as tall as it needs to be to show the biggest image
            let largestImage = miscImages.sorted(by: {$0.size.height > $1.size.height}).first!
            let largestAspect = largestImage.size.height / largestImage.size.width
            miscHeight.constant = self.view.bounds.width * largestAspect
            
            let miscTotalWidth: CGFloat = CGFloat(miscImages.count) * self.view.bounds.width
            
            //miscScrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: miscHeight.constant)
            miscScrollView.isPagingEnabled = true
            miscScrollView.bounces = false
            miscScrollView.showsVerticalScrollIndicator = false
            miscScrollView.showsHorizontalScrollIndicator = false
            miscScrollView.delegate = self
            //miscScrollView.backgroundColor = .purple
            miscScrollView.contentMode = .top
            
            miscScrollView.contentSize = CGSize(width: miscTotalWidth, height: miscHeight.constant)
            
            //miscHeight.constant = miscScrollView.contentSize.height

            print("stack view contains \(stackView.arrangedSubviews.count) arranged subs")
            
            for (index, image) in miscImages.enumerated() {
                let view = UIImageView(image: image)
                let imageAspect =  image.size.height / image.size.width
                view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.width * imageAspect)
                view.frame.origin.x = CGFloat((Int(miscTotalWidth) / miscImages.count) * (index))
                view.contentMode = .scaleAspectFit
                miscScrollView.addSubview(view)
            }
            
            if brochureImages.count == 0 {
                print("No brochure images")
                //brochureHeight.constant = 0
                stackView.arrangedSubviews[0].isHidden = true
                stackView.arrangedSubviews[1].isHidden = true
//                stackView.removeArrangedSubview(stackView.arrangedSubviews[0])
//                stackView.removeArrangedSubview(stackView.arrangedSubviews[1])
                stackViewHeight.constant = miscHeight.constant + 30
            }
            
            if miscImages.count == 0 {
                print("No misc images")
                //miscHeight.constant = 0
                stackView.arrangedSubviews[2].isHidden = true
                stackView.arrangedSubviews[3].isHidden = true 
//                stackView.removeArrangedSubview(stackView.arrangedSubviews[2])
//                stackView.removeArrangedSubview(stackView.arrangedSubviews[3])
                stackViewHeight.constant = brochureHeight.constant + 30
            }
            
            if miscImages.count != 0 && brochureImages.count != 0 {
                stackViewHeight.constant = miscHeight.constant + brochureHeight.constant + 60
            }
            
            self.view.layoutIfNeeded()
            
        } else {
            print("Coudn't get imagePath. Ensure there's an entry for this model in Constants.swift")
        }
    }
    
    override func viewDidLayoutSubviews() {
        populateImages()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        timer?.invalidate()
        UIView.animate(withDuration: 0.5) {
            self.ind.alpha = 1
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // calcualate the page
        let page = Int(scrollView.contentOffset.x / scrollView.contentSize.width * CGFloat(ind.numberOfPages))
        print("Page: \(page)")
        self.ind.currentPage = page
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (timer) in
            UIView.animate(withDuration: 0.5) {
                self.ind.alpha = 0
            }
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
    
    deinit {
        print("Deinit")
    }
}
