import Foundation

public struct GCDHelper {
    
    public static let mainQueue: DispatchQueue = {
        return DispatchQueue.main
    }()
    
    public static let backgroundQueue: DispatchQueue = {
        return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
    }()
    
    public static func delay(_ delay: Double, block: @escaping () -> Void) {
        GCDHelper.mainQueue.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
    }
    
    public static func runOnMainThread(_ block: @escaping () -> Void) {
        GCDHelper.mainQueue.async(execute: block)
    }
    
    public static func runOnBackgroundThread(_ block: @escaping () -> Void) {
        GCDHelper.backgroundQueue.async(execute: block)
    }
    
    public static func synced(_ lock: AnyObject, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
}
