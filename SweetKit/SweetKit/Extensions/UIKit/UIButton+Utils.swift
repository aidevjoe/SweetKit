import UIKit

extension UIButton {
    
    public convenience init(title: String, titleColor: UIColor = .white) {
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
    
    var normalTitle: String {
        get {
            return self.title(for: .normal) ?? ""
        }
        set {
            self.setTitle(newValue, for: .normal)
        }
    }
    
    var normalTitleColor: UIColor {
        get {
            return self.titleColor(for: .normal) ?? .white
        }
        set {
            self.setTitleColor(newValue, for: .normal)
        }
    }
    
    var normalImage: UIImage? {
        get {
            return self.image(for: .normal)
        }
        set {
            self.setImage(newValue, for: .normal)
        }
    }
    
    var fontSize: CGFloat {
        get {
            return self.titleLabel?.font.pointSize ?? 17
        }
        set {
            self.titleLabel?.font = UIFont.systemFont(ofSize: newValue)
        }
    }
    
    @IBInspectable public var underline:Bool {
        set {
            if newValue {
                let attrs = [
                    NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
                ]
                self.titleLabel?.attributedText = NSMutableAttributedString(string: self.titleLabel!.text!, attributes: attrs)
            }
        }
        get {
            let range = NSMakeRange(0, self.titleLabel!.text!.length)
            var underlined:Bool = false
            
            self.titleLabel?.attributedText?.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributes, range, stop) in
                if attributes[NSUnderlineStyleAttributeName] != nil {
                    underlined = Bool(attributes[NSUnderlineStyleAttributeName] as! NSNumber)
                }
            }
            return underlined
        }
    }
    
    public func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        let rectangle = CGRect(size: CGSize(1))
        UIGraphicsBeginImageContext(rectangle.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rectangle)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        setBackgroundImage(image!, for: state)
    }
    
    /// 按钮图片在上文字在下 垂直对齐
    ///
    /// - Parameter spacing: 图片和文字之间的间距
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = imageView?.image?.size,
            let text = currentTitle,
            let font = titleLabel?.font
            else { return }
        titleLabel?.textAlignment = .center
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let titleSize = NSString(string: text).size(attributes: [NSFontAttributeName: font])
        imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}
