import UIKit
import SystemConfiguration.CaptiveNetwork

// MARK: - UIDevice

public extension UIDevice {
    
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
    
    public static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 获取mac地址
    public static func getMacAddress() -> String! {
        
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
    
    /// 系统信息
    ///
    /// - Parameter typeSpecifier: Type of system info.
    /// - Returns: Return sysyem info.
    fileprivate static func getSysInfo(_ typeSpecifier: Int32) -> Int {
        var name: [Int32] = [CTL_HW, typeSpecifier]
        var size: Int = 2
        sysctl(&name, 2, nil, &size, &name, 0)
        var results: Int = 0
        sysctl(&name, 2, &results, &size, &name, 0)
        
        return results
    }
    
    
    /// 返回当前设备的CPU频率。
    public static var cpuFrequency: Int {
        return self.getSysInfo(HW_CPU_FREQ)
    }
    
    /// 返回当前设备总线的频率。
    public static var busFrequency: Int {
        return self.getSysInfo(HW_TB_FREQ)
    }
    
    /// 返回设备内存大小。
    public static var ramSize: Int {
        return self.getSysInfo(HW_MEMSIZE)
    }
    
    /// Returns device CPUs number.
    public static var cpusNumber: Int {
        return self.getSysInfo(HW_NCPU)
    }
    
    /// 返回设备总内存。
    public static var totalMemory: Int {
        return self.getSysInfo(HW_PHYSMEM)
    }
    
    /// Returns current device non-kernel memory.
    public static var userMemory: Int {
        return self.getSysInfo(HW_USERMEM)
    }
    
    /// 返回当前设备总磁盘空间
    public static func totalDiskSpace() -> NSNumber {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return attributes[.systemSize] as? NSNumber ?? NSNumber(value: 0.0)
        } catch {
            return NSNumber(value: 0.0)
        }
    }
    
    /// 返回当前设备空闲磁盘空间
    public static func freeDiskSpace() -> NSNumber {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return attributes[.systemFreeSize] as? NSNumber ?? NSNumber(value: 0.0)
        } catch {
            return NSNumber(value: 0.0)
        }
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
