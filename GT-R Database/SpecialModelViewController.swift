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
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    
    var series: String! // R32,R33,R34
    var specialModelName: String! // M-Spec Nür (special chars included, this is display text)
    var images: [UIImage] = []
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
        populateImages()
        
        if let text = getModelInfoText() {
            textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            let parsed = CMDocument(string: text, options: .hardBreaks)
            
            let attr = CMTextAttributes()
            attr.addFontAttributes([.family : "NissanOpti", .size : 16], forElementWithKinds: .header1)
            attr.addFontAttributes([.family : "NissanOpti", .size : 14], forElementWithKinds: .header2)
            attr.addFontAttributes([.family : "NissanOpti", .size : 12], forElementWithKinds: .header3)
            attr.addFontAttributes([.family : "Futura", .size : 16, .face : "Bold"], forElementWithKinds: .header4)
            
            attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .inlineCode)
            attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .text)
            attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .unorderedList)
            attr.addFontAttributes([.family : "Futura", .size : 12], forElementWithKinds: .unorderedSublist)
            
            attr.addParagraphStyleAttributes([.alignment : NSTextAlignment.right.rawValue], forElementWithKinds: .inlineCode)
            attr.addParagraphStyleAttributes([.firstLineHeadExtraIndent : 0, .headExtraIndent : 20], forElementWithKinds: .unorderedList)
            //attr.addFontAttributes([.family : "NissanOpti", .size : 14], forElementWithKinds: .header1)

            let renderer = CMAttributedStringRenderer(document: parsed, attributes: attr)
        
            textView.attributedText = renderer!.render()
            
            textViewHeight.constant = 600
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
            filenames.removeAll(where: {$0.contains("brochure")})
            
            print("Found \(brochureImages.count) brochure images")
            print("Found \(filenames.filter({$0.contains(".jpg")}).count) miscellaneous images")
            
            // Generate a scroll view in code and fill it with brochure images, then add it to the stack view
            
            
            
            for filename in brochureImages {
                let image = UIImage(contentsOfFile: "\(path)\(filename)")
                images.append(image!)
            }
            
            print("Added \(images.count) images")
            
            var totalWidth: CGFloat = CGFloat(images.count) * self.view.frame.width
            
            
            print("total width: \(totalWidth)")
            
            let scrollView = UIScrollView()
            // Set the scrollView's frame to be the size of the screen
            scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.backgroundColor = .systemTeal
            scrollView.isPagingEnabled = true
            scrollView.bounces = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            
            
            self.view.addSubview(ind)
            ind.numberOfPages = images.count
            ind.alpha = 0
            ind.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: 50)
            ind.center.x = scrollView.bounds.width / 2
            ind.center.y = scrollView.bounds.maxY - 20
            ind.layer.zPosition = 300
            let aspect = images.first!.size.height / images.first!.size.width
            print("Aspect: \(aspect)")
            scrollView.contentSize = CGSize(width: totalWidth, height: self.view.frame.width * aspect)
            
            stackViewHeight.constant = self.view.frame.width * aspect
            stackView.insertArrangedSubview(scrollView, at: 0)
            
            print("stack view contains \(stackView.arrangedSubviews.count) arranges subs")
            
            for (index, image) in images.enumerated() {
                let view = UIImageView(image: image)
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width * aspect)
                view.frame.origin.x = CGFloat((Int(totalWidth) / images.count) * (index))
                view.contentMode = .scaleAspectFit
                scrollView.addSubview(view)
            }
            
            self.view.layoutIfNeeded()
            
        } else {
            print("Coudn't get imagePath")
        }
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
