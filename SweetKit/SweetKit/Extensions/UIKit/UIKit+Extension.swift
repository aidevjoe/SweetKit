import UIKit
import CoreGraphics

extension URL {
    /// 将 query 转换为字典
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}



// MARK: - CGRect
public extension CGRect {
    
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

public extension UIEdgeInsets {
    
    public init(_ top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}


// MARK: - CGSize
public extension CGSize {
    
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
    public func aspectFit(_ boundingSize: CGSize) -> CGSize {
        let minRatio = min(boundingSize.width / width, boundingSize.height / height)
        return CGSize(width: width * minRatio, height: height*minRatio)
    }
    
    /**
     Pixel size
     
     - returns: CGSize
     */
    public func toPixel() -> CGSize {
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


public extension CGFloat {
    
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
public extension Int {
    public var boolValue: Bool {
        return self > 0
    }
}

public extension Bool {
    public var reverse: Bool {
        return !self
    }
    
    public var intValue: Int {
        return self ? 1 : 0
    }
}

// MARK: - UserDefaults
public extension UserDefaults {
    public static func save(at value: Any?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public static func get(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    public static func remove(forKey key: String) {
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
    
    public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }
}






// MARK: - UUID
public extension UUID {
    public static var string: String {
        get {
            return Foundation.UUID().uuidString.replacingOccurrences(of: "-", with: "")
        }
    }
}

public extension UIBezierPath {
    public static func midpoint(p0: CGPoint, p1: CGPoint) -> CGPoint {
        return CGPoint(x: (p0.x + p1.x) / 2.0, y: (p0.y + p1.y) / 2.0)
    }
}



// MARK: - UITapGestureRecognizer
public extension UITapGestureRecognizer {
    
    
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
    public func didTapAttributedTextInLabel(_ label: UILabel, targetRange: NSRange) -> Bool {
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
