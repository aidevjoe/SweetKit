import UIKit

extension String {
    
    /// 转换成 Int
    func toUInt() -> UInt? {
        return UInt(self)
    }
    
    /// 转换成 Int， 如果转换失败，返回默认值
    func toUIntWithDefault(defaultValue: UInt) -> UInt {
        return UInt(self) ?? defaultValue
    }
    
    /// 转换成 Float
    var float: Float? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.floatValue
    }
    
    /// 转换成 Float
    var cgfloat: CGFloat? {
        return CGFloat(NumberFormatter().number(from: self) ?? 0 )
    }
    
    /// 转换成 Double
    var double: Double? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.doubleValue
    }
    
    /// 获取字符串长度
    var length : Int {
        return characters.count
    }
    
    func hash() -> Int {
        let sum =  self.characters
            .map { String($0).unicodeScalars.first?.value }
            .flatMap { $0 }
            .reduce(0, +)
        return Int(sum)
    }
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// 截取字符串
    ///
    /// - Parameter r: [0..>n]
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.characters.index(self.startIndex, offsetBy: r.upperBound)
            
            return self[Range(startIndex..<endIndex)]
        }
    }
    
    /// 剪切空格和换行字符
    public mutating func trim() {
        self = self.trimmed()
    }
    
    /// 剪切空格和换行字符，返回一个新字符串。
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 字符串大小
    func toSize(size: CGSize, fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGSize {
        let font = UIFont.systemFont(ofSize: fontSize)
        var size = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes:[NSFontAttributeName : font], context: nil).size
        if maximumNumberOfLines > 0 {
            size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
        }
        return size
    }
    
    /// 字符串宽度
    func toWidth(fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        return toSize(size: size, fontSize: fontSize, maximumNumberOfLines: maximumNumberOfLines).width
    }
    
    /**
     Calculate the height of string, and limit the width
     
     - parameter width: width
     - parameter font:  font
     
     - returns: height value
     */
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font],
            context: nil)
        return boundingBox.height
    }
    
    /// 字符串高度
    func toHeight(width: CGFloat, fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return toSize(size: size, fontSize: fontSize, maximumNumberOfLines: maximumNumberOfLines).height
    }
    
    
    /// 设置指定文字颜色
    func makeSubstringColor(_ text: String, color: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        
        let range = (self as NSString).range(of: text)
        if range.location != NSNotFound {
            attributedText.setAttributes([NSForegroundColorAttributeName: color], range: range)
        }
        
        return attributedText
    }
}
