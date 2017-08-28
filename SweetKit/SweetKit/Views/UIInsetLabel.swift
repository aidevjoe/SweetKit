import UIKit

@IBDesignable public class UIInsetLabel: UILabel {
    
    public var contentInsets = UIEdgeInsets.zero
    
    @IBInspectable
    public var contentInsetsTop: CGFloat {
        set {
            contentInsets.top = newValue
        }
        get {
            return contentInsets.top
        }
    }
    
    @IBInspectable
    public var contentInsetsLeft: CGFloat {
        set {
            contentInsets.left = newValue
        }
        get {
            return contentInsets.left
        }
    }
    
    @IBInspectable
    public var contentInsetsBottom: CGFloat {
        set {
            contentInsets.bottom = newValue
        }
        get {
            return contentInsets.bottom
        }
    }
    
    @IBInspectable
    public var contentInsetsRight: CGFloat {
        set {
            contentInsets.right = newValue
        }
        get {
            return contentInsets.right
        }
    }
    
    convenience public init(insets: UIEdgeInsets) {
        self.init()
        self.contentInsets = insets;
    }
    
    convenience public init(frame: CGRect, insets: UIEdgeInsets) {
        self.init(frame:frame)
        self.contentInsets = insets
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, contentInsets), limitedToNumberOfLines: numberOfLines)
    }
    
    
    override open var intrinsicContentSize : CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, contentInsets))
    }
}
