import UIKit

public extension UILabel {
    
    /// Create an UILabel with the given parameters.
    public convenience init(frame: CGRect = .zero,
                            text: String = "",
                            fontSize: CGFloat = 17,
                            color: UIColor, lines: Int = 1,
                            shadowColor: UIColor = UIColor.clear) {
        self.init(frame: frame)
        self.text = text
        self.textColor = color
        self.numberOfLines = lines
        self.shadowColor = shadowColor
    }
    
    @IBInspectable
    public var underline: Bool {
        get {
            return self.underline
        }
        set {
            guard let text: String = self.text else {
                return
            }
            let textAttributes =  NSMutableAttributedString(string: text)
            if newValue {
                textAttributes.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.characters.count))
            } else {
                textAttributes.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleNone.rawValue, range: NSMakeRange(0, text.characters.count))
            }
            self.attributedText = textAttributes
        }
    }
    
    /// 设置指定文字[]大小
    public func makeSubstringsBold(text: [String], size: CGFloat) {
        text.forEach { self.makeSubstringBold($0, size: size) }
    }
    
    /// 设置指定文字大小
    public func makeSubstringBold(_ boldText: String, size: CGFloat) {
        let attributedText = self.attributedText!.mutableCopy() as! NSMutableAttributedString
        
        let range = ((self.text ?? "") as NSString).range(of: boldText)
        if range.location != NSNotFound {
            attributedText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: size)], range: range)
        }
        
        self.attributedText = attributedText
    }
    
    public func makeSubstringWeight(_ text: String) {
        let attributedText = self.attributedText!.mutableCopy() as! NSMutableAttributedString
        let range = ((self.text ?? "") as NSString).range(of: text)
        if range.location != NSNotFound {
            attributedText.setAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: font.pointSize)], range: range)
        }
        self.attributedText = attributedText
    }
    
    /// 设置指定文字颜色
    public func makeSubstringColor(_ text: String, color: UIColor) {
        let attributedText = self.attributedText!.mutableCopy() as! NSMutableAttributedString
        
        let range = ((self.text ?? "") as NSString).range(of: text)
        if range.location != NSNotFound {
            attributedText.setAttributes([NSForegroundColorAttributeName: color], range: range)
        }
        
        self.attributedText = attributedText
    }
    
    /// 使指定文字添加删除线
    public func strikethrough(text: String) {
        self.attributedText = NSAttributedString(string: text, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
    }
    
    /// 设置行高
    public func setLineHeight(_ lineHeight: Int) {
        let displayText = text ?? ""
        let attributedString = self.attributedText!.mutableCopy() as! NSMutableAttributedString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(lineHeight)
        paragraphStyle.alignment = textAlignment
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, displayText.characters.count))
        
        attributedText = attributedString
    }
    
    public func makeTransparent() {
        isOpaque = false
        backgroundColor = .clear
    }
    
    /**
     The content size of UILabel
     
     - returns: CGSize
     */
    public func contentSize() -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = self.lineBreakMode
        paragraphStyle.alignment = self.textAlignment
        let attributes: [String : AnyObject] = [NSFontAttributeName: self.font, NSParagraphStyleAttributeName: paragraphStyle]
        let contentSize: CGSize = self.text!.boundingRect(
            with: self.frame.size,
            options: ([.usesLineFragmentOrigin, .usesFontLeading]),
            attributes: attributes,
            context: nil
            ).size
        return contentSize
    }
    
    /**
     Set UILabel's frame with the string, and limit the width.
     
     - parameter string: text
     - parameter width:  your limit width
     */
    public func setFrameWithString(_ string: String, width: CGFloat) {
        self.numberOfLines = 0
        let attributes: [String : AnyObject] = [
            NSFontAttributeName: self.font,
            ]
        let resultSize: CGSize = string.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
            ).size
        let resultHeight: CGFloat = resultSize.height
        let resultWidth: CGFloat = resultSize.width
        var frame: CGRect = self.frame
        frame.size.height = resultHeight
        frame.size.width = resultWidth
        self.frame = frame
    }
}
