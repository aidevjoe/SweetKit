import UIKit

public extension String {
    
    /// 转换成 Int
    public func toUInt() -> UInt? {
        return UInt(self)
    }
    
    /// 转换成 Int， 如果转换失败，返回默认值
    public func toUIntWithDefault(defaultValue: UInt) -> UInt {
        return UInt(self) ?? defaultValue
    }
    
    /// 转换成 Float
    public var float: Float? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.floatValue
    }
    
    /// 转换成 Float
    public var cgfloat: CGFloat? {
        return CGFloat(NumberFormatter().number(from: self) ?? 0 )
    }
    
    /// 转换成 Double
    public var double: Double? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.doubleValue
    }
    
    /// 转换成 Data
    public var data: Data? {
        return self.data(using: .utf8)
    }
    
    public func addToPasteboard() {
        UIPasteboard.general.string = self
    }
    
    /// Base64 编码
    public var base64encoded: String {
        guard let data: Data = self.data(using: .utf8) else {
            return ""
        }
        return data.base64EncodedString()
    }
    
    /// Base64 解码
    public var base64decoded: String {
        guard let data = Data(base64Encoded: String(self), options: .ignoreUnknownCharacters),
            let dataString = String(data: data, encoding: .utf8) else {
            return ""
        }
        return String(describing: dataString)
    }
    
    /// URL 编码
    public var urlEncoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
    }
    
    /// 获取字符串长度
    public var length : Int {
        return characters.count
    }
    
    /// 由换行符分隔的字符串数组。
    ///
    ///		"Hello\ntest".lines -> ["Hello", "test"]
    ///
    public var lines: [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    
    /// 从字符串中获得的Bool值
    ///
    ///		"1".bool -> true
    ///		"False".bool -> false
    ///		"Hello".bool = nil
    ///
    public var bool: Bool? {
        let selfLowercased = trimmed.lowercased()
        if selfLowercased == "true" || selfLowercased == "1" {
            return true
        } else if selfLowercased == "false" || selfLowercased == "0" {
            return false
        }
        return nil
    }
    
    public func hash() -> Int {
        let sum =  self.characters
            .map { String($0).unicodeScalars.first?.value }
            .flatMap { $0 }
            .reduce(0, +)
        return Int(sum)
    }
    
    public func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    ///  从 yyyy-MM-dd 格式的字符串对象
    ///
    ///		"2007-06-29".date -> Optional(Date)
    ///
    public var date: Date? {
        let selfLowercased = trimmed.lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
    
    /// 从 yyyy-MM-dd HH:mm:ss 格式的字符串对象
    ///
    ///		"2007-06-29 14:23:09".dateTime -> Optional(Date)
    ///
    public var dateTime: Date? {
        let selfLowercased = trimmed.lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: selfLowercased)
    }
    
    /// 返回给定字符的索引
    ///
    /// - Parameter character: character
    /// - Returns: 返回给定字符的索引，如果未找到，则返回1
    public func index(of character: Character) -> Int {
        if let index = self.characters.index(of: character) {
            return self.characters.distance(from: self.startIndex, to: index)
        }
        return -1
    }
    
    /// 创建一个给定范围的子串
    public func substring(with range: CountableClosedRange<Int>) -> String {
        return self.substring(with: Range(uncheckedBounds: (lower: range.lowerBound, upper: range.upperBound + 1)))
    }
    
    /// 根据给定的索引获取字符
    ///
    /// - Parameter index:  index.
    /// - Returns: 在给定的索引中返回字符，从0开始
    public func character(at index: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: index)]
    }
    
    /// 返回一个新的字符串，该字符串包含从字符串开始到给定索引结束的字符串。
    public func substring(from index: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: index))
    }

    /// 从给定的字符创建一个子字符串
    ///
    /// - Parameter character: character.
    /// - Returns: 从字符返回子字符串
    public func substring(from character: Character) -> String {
        let index: Int = self.index(of: character)
        guard index > -1 else {
            return ""
        }
        return substring(from: index + 1)
    }
    
    /// 返回一个新字符串，该字符串包含给定索引上的字符串，但不包括给定索引中的字符串。
    public func substring(to index: Int) -> String {
        guard index <= self.length else {
            return ""
        }
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: index))
    }
    
    /// 创建一个指定范围的子字符串
    public func substring(with range: Range<Int>) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.characters.index(self.startIndex, offsetBy: range.upperBound)
        
        return self.substring(with: start..<end)
    }
    
    /// 从给定范围返回字符串
    ///
    /// Example: print("BFKit"[1...3]) the result is "FKi".
    public subscript(range: Range<Int>) -> String {
        return substring(with: range)
    }
    
    /// 剪切空格和换行字符
    public mutating func trim() {
        self = trimmed
    }
    
    /// 剪切空格和换行字符，返回一个新字符串。
    public var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 删除两个或多个重复的空格
    public func removeExtraSpaces() -> String {
        let squashed = replacingOccurrences(of: "[ ]+", with: " ", options: .regularExpression, range: nil)
        return squashed.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// 将给定索引中的字符作为字符串返回
    public subscript(index: Int) -> String {
        return String(self[index])
    }
    
    /// 返回给定字符的索引，如果未找到，则返回-1。
    ///
    /// - Parameter character: Returns the index of the given character, -1 if not found.
    public subscript(character: Character) -> Int {
        return self.index(of: character)
    }
    
    /// 根据给定的索引获取字符
    public subscript(index: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: index)]
    }
    
    /// 如果是回文，则返回true，否则是false。
    public func isPalindrome() -> Bool {
        let selfString = self.lowercased().replacingOccurrences(of: " ", with: "")
        let otherString = String(selfString.characters.reversed())
        return selfString == otherString
    }

    /// 计算符号的个数
    public func countSymbols() -> Int {
        var countSymbol = 0
        for i in 0 ..< self.length {
            guard let character = UnicodeScalar((NSString(string: self)).character(at: i)) else {
                return 0
            }
            let isSymbol = CharacterSet(charactersIn: "`~!?@#$€£¥§%^&*()_+-={}[]:\";.,<>'•\\|/").contains(character)
            if isSymbol {
                countSymbol += 1
            }
        }
        
        return countSymbol
    }
    
    /// 计算符号的个数
    public func countNumbers() -> Int {
        var countNumber = 0
        for i in 0 ..< self.length {
            guard let character = UnicodeScalar((NSString(string: self)).character(at: i)) else {
                return 0
            }
            let isNumber = CharacterSet(charactersIn: "0123456789").contains(character)
            if isNumber {
                countNumber += 1
            }
        }
        
        return countNumber
    }

    /// 返回第一个大写字母字符的字符串.
    public func uppercasedFirst() -> String {
        return String(self.characters.prefix(1)).uppercased() + String(self.characters.dropFirst())
    }
    
    /// 返回第一个小写字母字符的字符串
    public func lowercasedFirst() -> String {
        return String(self.characters.prefix(1)).lowercased() + String(self.characters.dropFirst())
    }
    
    /// 返回指定字符串的出现次数 区分大小写或不区分
    public func occurrences(of string: String, caseSensitive: Bool = true) -> Int {
        var string = string
        if !caseSensitive {
            string = string.lowercased()
        }
        return self.lowercased().components(separatedBy: string).count - 1
    }
    
    /// 检查是否具有给定字符串 区分大小写或不区分
    public func range(of string: String, caseSensitive: Bool = true) -> Bool {
        return caseSensitive ? (self.range(of: string) != nil) : (self.lowercased().range(of: string.lowercased()) != nil)
    }
    
    /// 返回是否有给定的子字符串 区分大小写或不区分
    public func has(_ string: String, caseSensitive: Bool = true) -> Bool {
        return self.range(of: string, caseSensitive: caseSensitive)
    }
    
    /// 返回颠倒字符串
    ///
    /// - parameter preserveFormat: If set to true preserve the String format.
    ///                             The default value is false.
    ///                             **Example:**
    ///                                 "Let's try this function?" ->
    ///                                 "?noitcnuf siht yrt S'tel"
    public func reversed(preserveFormat: Bool = false) -> String {
        guard !self.characters.isEmpty else {
            return ""
        }
        
        var reversed = String(self.removeExtraSpaces().characters.reversed())
        
        if !preserveFormat {
            return reversed
        }
        
        let words = reversed.components(separatedBy: " ").filter { $0 != "" }
        
        reversed.removeAll()
        for word in words {
            if let char = word.unicodeScalars.last {
                if CharacterSet.uppercaseLetters.contains(char) {
                    reversed += word.lowercased().uppercasedFirst()
                } else {
                    reversed += word.lowercased()
                }
            } else {
                reversed += word.lowercased()
            }
            
            if word != words[words.count - 1] {
                reversed += " "
            }
        }
        
        return reversed
    }
    
    /// Converts self to an UUID APNS valid (No "<>" or "-" or spaces).
    ///
    /// - Returns: Converts self to an UUID APNS valid (No "<>" or "-" or spaces).
    public func readableUUID() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }
    
    public static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return (0..<length).reduce("") {
            let randomIndex = arc4random_uniform(UInt32(base.characters.count))
            let randomCharacter = "\(base[base.index(base.startIndex, offsetBy: IndexDistance(randomIndex))])"
            return $0.0 + randomCharacter
        }
    }
    
}


extension String {
    
    public var nsString: NSString {
        return NSString(string: self)
    }
    
    /// Appends a path component to the string.
    public func appendingPathComponent(_ path: String) -> String {
        let string = NSString(string: self)
        
        return string.appendingPathComponent(path)
    }
    
    /// Appends a path extension to the string.
    public func appendingPathExtension(_ ext: String) -> String? {
        let nsSt = NSString(string: self)
        
        return nsSt.appendingPathExtension(ext)
    }
    
    /// Returns an array of path components.
    public var pathComponents: [String] {
        return NSString(string: self).pathComponents
    }
    
    /// Delete the path extension.
    public var deletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }
    
    /// Returns the last path component.
    public var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }
    
    /// Returns the path extension.
    public var pathExtension: String {
        return NSString(string: self).pathExtension
    }
    
    /// Delete the last path component.
    public var deletingLastPathComponent: String {
        return NSString(string: self).deletingLastPathComponent
    }
}

extension String {
    /// 字符串大小
    public func toSize(size: CGSize, fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGSize {
        let font = UIFont.systemFont(ofSize: fontSize)
        var size = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes:[NSFontAttributeName : font], context: nil).size
        if maximumNumberOfLines > 0 {
            size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
        }
        return size
    }
    
    /// 字符串宽度
    public func toWidth(fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        return toSize(size: size, fontSize: fontSize, maximumNumberOfLines: maximumNumberOfLines).width
    }
    
    /// 字符串高度
    public func toHeight(width: CGFloat, fontSize: CGFloat, maximumNumberOfLines: Int = 0) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        return toSize(size: size, fontSize: fontSize, maximumNumberOfLines: maximumNumberOfLines).height
    }

    /// 计算字符串的高度，并限制宽度
    public func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font],
            context: nil)
        return boundingBox.height
    }
    
    /// 下划线
    public func underline() -> NSAttributedString {
        let underlineString = NSAttributedString(string: self, attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
        return underlineString
    }
    
    // 斜体
    public func italic() -> NSAttributedString {
        let italicString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
        return italicString
    }
    
    /// 设置指定文字颜色
    public func makeSubstringColor(_ text: String, color: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        
        let range = (self as NSString).range(of: text)
        if range.location != NSNotFound {
            attributedText.setAttributes([NSForegroundColorAttributeName: color], range: range)
        }
        
        return attributedText
    }
}
