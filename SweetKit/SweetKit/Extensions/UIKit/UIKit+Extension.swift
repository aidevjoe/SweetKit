import UIKit
import CoreGraphics
import SystemConfiguration.CaptiveNetwork


// MARK: - CGRect
extension CGRect {
    
    public init(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }
    
    public init(x: CGFloat = 0, y: CGFloat = 0, size: CGSize) {
        self.init(origin: CGPoint(x: x, y: y), size: size)
    }
    
    public init(origin: CGPoint, width: CGFloat = 0, height: CGFloat = 0) {
        self.init(origin: origin, size: CGSize(width: width, height: height))
    }
}

extension UIEdgeInsets {
    
    public init(_ top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}


// MARK: - CGSize
extension CGSize {
    
    public init(_ both: CGFloat) {
        self.init(width: both, height: both)
    }
    
    public init(width: CGFloat) {
        self.init(width: width, height: 0)
    }
    
    public init(height: CGFloat) {
        self.init(width: 0, height: height)
    }
    
    /**
     Aspect fit size
     
     - parameter boundingSize: boundingSize
     
     - returns: CGSize
     */
    func aspectFit(_ boundingSize: CGSize) -> CGSize {
        let minRatio = min(boundingSize.width / width, boundingSize.height / height)
        return CGSize(width: width * minRatio, height: height*minRatio)
    }
    
    /**
     Pixel size
     
     - returns: CGSize
     */
    func toPixel() -> CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: self.width * scale, height: self.height * scale)
    }
}

// MARK: Float、Interger

public extension IntegerLiteralType {
    public var f: CGFloat {
        return CGFloat(self)
    }
}

public extension FloatLiteralType {
    public var f: CGFloat {
        return CGFloat(self)
    }
}


extension CGFloat {
    
    public var half: CGFloat {
        return self * 0.5
    }
    
    public var double: CGFloat {
        return self * 2
    }
    
    public static var max = CGFloat.greatestFiniteMagnitude
    
    public static var min = CGFloat.leastNormalMagnitude

}

// MARK: - Int
extension Int {
    public var boolValue: Bool {
        return self > 0
    }
}

extension Bool {
    public var reverse: Bool {
        return !self
    }
    
    public var intValue: Int {
        return self ? 1 : 0
    }
}




// MARK: - UserDefaults
extension UserDefaults {
    static func save(at value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func get(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    static func remove(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
}



// MARK: - UIApplication
public extension UIApplication {
    
    /// App版本
    public class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    /// App构建版本
    public class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    public class var iconFilePath: String {
        let iconFilename = Bundle.main.object(forInfoDictionaryKey: "CFBundleIconFile")
        let iconBasename = (iconFilename as! NSString).deletingPathExtension
        let iconExtension = (iconFilename as! NSString).pathExtension
        return Bundle.main.path(forResource: iconBasename, ofType: iconExtension)!
    }
    
    public class func iconImage() -> UIImage? {
        guard let image = UIImage(contentsOfFile:self.iconFilePath) else {
            return nil
        }
        return image
    }
    
    public class func versionDescription() -> String {
        let version = appVersion()
        #if DEBUG
            return "Debug - \(version)"
        #else
            return "Release - \(version)"
        #endif
    }
    
    public class func appBundleName() -> String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
}


// MARK: - UIDevice

extension UIDevice {
    
    /// MARK: - 获取设备型号
    public static func phoneModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone 5SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    /// 判断是不是模拟器
    public static var isSimulator: Bool {
        return UIDevice.phoneModel() == "Simulator"
    }
    
    public static var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 获取mac地址
    static func getMacAddress() -> String! {
        
        if let cfa: NSArray = CNCopySupportedInterfaces() {
            for x in cfa {
                if let dic = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                    let mac = dic["BSSID"]
                    return mac as! String!
                }
            }
        }
        return nil
    }
    
    /// 返回当前屏幕的一个像素的点大小
    public class var onePixel: CGFloat {
        return CGFloat(1.0) / UIScreen.main.scale
    }
    
    
    /// 将浮动值返回到当前屏幕的最近像素
    static public func roundFloatToPixel(_ value: CGFloat) -> CGFloat {
        return round(value * UIScreen.main.scale) / UIScreen.main.scale
    }
}






// MARK: - UUID
extension UUID {
    static var string: String {
        get {
            return Foundation.UUID().uuidString.replacingOccurrences(of: "-", with: "")
        }
    }
}

extension UIBezierPath {
    static func midpoint(p0: CGPoint, p1: CGPoint) -> CGPoint {
        return CGPoint(x: (p0.x + p1.x) / 2.0, y: (p0.y + p1.y) / 2.0)
    }
}



// MARK: - UITapGestureRecognizer
extension UITapGestureRecognizer {
    
    
    /// UILabel 添加链接点击响应
    ///
    /// - Parameters:
    ///   - label: 需要响应事件的label
    ///   - targetRange: 需要响应点击文字的Range
    /// step 1. policyPromptLabel.addGestureRecognizer(pan)
    /// step 2  let range1 = (text as NSString).range(of: subStr1)
    ///         let range2 = (text as NSString).range(of: subStr2)
    /// step 3  gesture.didTapAttributedTextInLabel(policyPromptLabel, targetRange: range1)
    ///         gesture.didTapAttributedTextInLabel(policyPromptLabel, targetRange: range2)
    func didTapAttributedTextInLabel(_ label: UILabel, targetRange: NSRange) -> Bool {
        //Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        //Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        //Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        //Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
