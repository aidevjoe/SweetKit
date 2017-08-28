import Foundation

extension Dictionary {
    
    /// 字典转JSON字符串
    func toJSONString() -> String {
        
        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let strJson = String(data: data!, encoding: .utf8)
        
        return strJson!
    }
}
