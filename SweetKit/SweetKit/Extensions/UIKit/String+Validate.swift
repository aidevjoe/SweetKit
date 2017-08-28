import Foundation

extension String {

    /// 是否是邮箱
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        //        let emailRegex = "^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\\.[a-zA-Z0-9_-]{2,3}){1,2})$"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return testPredicate.evaluate(with: self)
    }
    
    
    /// 是否是1开头的手机号码
    func isPhoneNumber() -> Bool {
        let regex = "^1\\d{10}$"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return testPredicate.evaluate(with: self)
    }
    
    
    /// 正则匹配手机号
    func checkMobile() -> Bool {
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         * 联通号段: 130,131,132,155,156,185,186,145,176,1709
         * 电信号段: 133,153,180,181,189,177,1700
         */
        let MOBIL = "^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)"
        /**
         * 中国移动：China Mobile
         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         */
        let CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        /**
         * 中国联通：China Unicom
         * 130,131,132,155,156,185,186,145,176,1709
         */
        let CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        /**
         * 中国电信：China Telecom
         * 133,153,180,181,189,177,1700
         */
        let CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", MOBIL)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@", CM)
        let regextestcu = NSPredicate(format: "SELF MATCHES %@", CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@", CT)
        if regextestmobile.evaluate(with: self) || regextestcm.evaluate(with: self) || regextestcu.evaluate(with: self) || regextestct.evaluate(with: self) {
            return true
        }
        return false
    }
    
    /// 是不是身份证
    func isIdentityCard() -> Bool {
        let regex: String = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let testPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return testPredicate.evaluate(with: self)
    }
    
    /// 正则匹配用户密码6-18位数字和字母组合
    func checkPassword() -> Bool {
        let pattern = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// 正则匹配URL
    func checkURL() -> Bool {
        let pattern = "^[0-9A-Za-z]{1,50}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// 正则匹配用户姓名,20位的中文或英文
    func checkUserName() -> Bool {
        let pattern = "^[a-zA-Z\\u4E00-\\u9FA5]{1,20}"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// 验证是否是数字
    func isNumber() -> Bool {
        let cs: CharacterSet = CharacterSet(charactersIn: "0123456789")
        
        let specialrang: NSRange = (self as NSString).rangeOfCharacter(from: cs)
        
        return specialrang.location != NSNotFound
    }
    
    /// 验证是否包含 "特殊字符"
    func isSpecialCharacter() -> Bool {
        let character = CharacterSet(charactersIn: "@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/" +
            "")
        
        let specialrang: NSRange = (self as NSString).rangeOfCharacter(from: character)
        
        return specialrang.location != NSNotFound
    }

    func containerWD() -> Bool {
        let regex = "^\\w+:\\d+:\\w+;$"
        let testPredicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return testPredicate.evaluate(with: self)
    }
}
