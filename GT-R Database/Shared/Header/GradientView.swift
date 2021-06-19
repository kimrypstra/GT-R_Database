import Foundation
import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [Colour.Banner.top, Colour.Banner.bottom]
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [Colour.Banner.top, Colour.Banner.bottom]
    }
}
