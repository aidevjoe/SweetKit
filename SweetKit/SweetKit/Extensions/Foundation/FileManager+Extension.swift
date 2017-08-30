import Foundation

public extension FileManager {
    /// 存文件到沙盒
    ///
    /// - Parameters:
    ///   - data: 数据源
    ///   - savePath: 保存位置
    /// - Returns: 删除或者保存错误
    public class func save(_ data: Data, savePath: String) -> Error? {
        if FileManager.default.fileExists(atPath: savePath) {
            do {
                try FileManager.default.removeItem(atPath: savePath)
            } catch let error  {
                return error
            }
        }
        do {
            try data.write(to: URL(fileURLWithPath: savePath))
        } catch let error {
            return error
        }
        return nil
    }
    
    
    public class func save(content: String, savePath: String) -> Error? {
        if FileManager.default.fileExists(atPath: savePath) {
            do {
                try FileManager.default.removeItem(atPath: savePath)
            } catch let error  {
                return error
            }
        }
        do {
            try content.write(to: URL(fileURLWithPath: savePath), atomically: true, encoding: .utf8)
        } catch let error {
            return error
        }
        return nil
    }
    
    
    /// 在沙盒创建文件夹
    ///
    /// - Parameter path: 文件夹地址
    /// - Returns: 创建错误
    @discardableResult
    public class func create(at path: String) -> Error? {
        if (!FileManager.default.fileExists(atPath: path)) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("error:\(error)")
                return error
            }
        }
        return nil
    }
    
    /// 在沙盒中删除文件
    ///
    /// - Parameter path: 需要删除的文件地址
    /// - Returns: 删除错误
    @discardableResult
    public class func delete(at path: String) -> Error? {
        if (FileManager.default.fileExists(atPath: path)) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch let error {
                return error
            }
            return nil
        }
        return NSError(domain: "File does not exist", code: -1, userInfo: nil) as Error
    }
    
    public class func rename(oldFileName: String, newFileName: String) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: oldFileName, toPath: newFileName)
            return true
        } catch {
            print("error:\(error)")
            return false
        }
    }
    
    public class func copy(oldFileName: String, newFileName: String) -> Bool {
        do {
            try FileManager.default.copyItem(atPath: oldFileName, toPath: newFileName)
            return true
        } catch {
            return false
        }
    }
    
    public class var document: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        }
    }
    
    public class var library: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
        }
    }
    
    public class var temp: String {
        get {
            return NSTemporaryDirectory()
        }
    }
    
    public class var caches: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        }
    }
    
    public class var log: String {
        get {
            return document.appendingPathComponent("Logs")
        }
    }
}
