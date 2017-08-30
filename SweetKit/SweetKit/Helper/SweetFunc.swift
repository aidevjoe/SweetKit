import Foundation

// MARK: - Global functions

/// 角度到弧度转换
public func degreesToRadians(_ degrees: Float) -> Float {
    return Float(Double(degrees) * Double.pi / 180)
}

/// 弧度到角度转换
public func radiansToDegrees(_ radians: Float) -> Float {
    return Float(Double(radians) * 180 / Double.pi)
}

/// 仅在调试模式下执行一个块
///
/// (http://stackoverflow.com/questions/26890537/disabling-nslog-for-production-in-swift-project/26891797#26891797).

public func debug(_ block: () -> Void) {
    #if DEBUG
        block()
    #endif
}

public func release(_ block: () -> Void) {
    #if !DEBUG
        block()
    #endif
}

public var isDebug: Bool {
    #if DEBUG
        return true
    #else
        return false
    #endif
}
