import UIKit

class HeaderView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var gtrLogo: UIImageView!
    @IBOutlet private weak var torqueGTLogo: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    var delegate: HeaderDelegate! {
        didSet {
            configureViews()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func configureViews() {
        let hiddenElements = delegate.headerShouldHideOptionalElements()
        
//        torqueGTLogo.isHidden = !hiddenElements.contains(.ShareButton)
        shareButton.isHidden = hiddenElements.contains(.ShareButton)
        titleLabel.isHidden = hiddenElements.contains(.Title)
        backButton.isHidden = hiddenElements.contains(.BackButton)
        
        if hiddenElements.contains(.BackButton) && hiddenElements.contains(.ShareButton) {
            // Either make the remaining buttons larger or shrink the height of the header
        }
    }
    
    func setTitle(to title: String) {
        titleLabel.text = title 
    }
    
    @IBAction func tappedGTR(_ sender: Any) {
        delegate.handleGTRButton()
    }
    
    @IBAction func tappedTorqueGT(_ sender: Any) {
        delegate.handleTorqueGTButton()
    }
    
    @IBAction func tappedShare(_ sender: Any) {
        delegate.handleShareButton()
    }
    
    @IBAction func tappedBack(_ sender: Any) {
        delegate.handleBackButton()
    }
}

enum HeaderElement {
    case Title
    case ShareButton
    case BackButton
}
