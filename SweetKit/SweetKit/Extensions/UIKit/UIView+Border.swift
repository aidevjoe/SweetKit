import UIKit

public class Border {
    enum Position: Int {
        case Top = 1130001
        case Bottom = 1130002
        case Left = 1130003
        case Right = 1130004
    }
    
    let size: CGFloat
    let color: UIColor
    let offset: UIEdgeInsets
    public init(size: CGFloat = 0.5, color: UIColor = UIColor.hex(0xE5E5E5), offset: UIEdgeInsets = .zero) {
        self.size = size
        self.color = color
        self.offset = offset
    }
    
    fileprivate func horizontal(position: Position) -> String {
        switch position {
        case .Top, .Bottom:
            return "H:|-(\(offset.left))-[v]-(\(offset.right))-|"
        case .Left:
            return "H:|-(\(offset.left))-[v(\(size))]"
        case .Right:
            return "H:[v(\(size))]-(\(offset.right))-|"
        }
    }
    fileprivate func vertical(position: Position) -> String {
        switch position {
        case .Top:
            return "V:|-(\(offset.top))-[v(\(size))]"
        case .Bottom:
            return "V:[v(\(size))]-(\(offset.bottom))-|"
        case .Left, .Right:
            return "V:|-(\(offset.top))-[v]-(\(offset.bottom))-|"
        }
    }
}

private var borderTopAssociationKey: UInt8 = 0
private var borderBottomAssociationKey: UInt8 = 0
private var borderLeftAssociationKey: UInt8 = 0
private var borderRightAssociationKey: UInt8 = 0

public extension UIView {
    public var borderTop: Border? {
        set {
            objc_setAssociatedObject(self, &borderTopAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setBorderUtility(newValue, position: .Top)
        }
        get {
            return objc_getAssociatedObject(self, &borderTopAssociationKey) as? Border
        }
    }
    public var borderBottom: Border? {
        set {
            objc_setAssociatedObject(self, &borderBottomAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setBorderUtility(newValue, position: .Bottom)
        }
        get {
            return objc_getAssociatedObject(self, &borderBottomAssociationKey) as? Border
        }
    }
    public var borderLeft: Border? {
        set {
            objc_setAssociatedObject(self, &borderLeftAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setBorderUtility(newValue, position: .Left)
        }
        get {
            return objc_getAssociatedObject(self, &borderLeftAssociationKey) as? Border
        }
    }
    public var borderRight: Border? {
        set {
            objc_setAssociatedObject(self, &borderRightAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setBorderUtility(newValue, position: .Right)
        }
        get {
            return objc_getAssociatedObject(self, &borderRightAssociationKey) as? Border
        }
    }
    private func setBorderUtility(_ newValue: Border?, position: Border.Position) {
        let BorderTag = position.rawValue
        
        let v = self.viewWithTag(BorderTag)
        if let border = newValue {
            if v != nil {
                v?.removeFromSuperview()
            }
            let v = UIView()
            v.tag = BorderTag
            v.backgroundColor = border.color
            addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: border.horizontal(position: position), options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: border.vertical(position: position), options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
        } else {
            if v != nil {
                v?.removeFromSuperview()
            }
        }
    }
}
