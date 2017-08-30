import Foundation

// MARK: - Global functions

public struct SKLog {
    // MARK: - Variables
    
    /// Activate or not SKLog.
    public static var active: Bool = isDebug
    
    /// The log string.
    public static var logged: String = ""
    /// The detailed log string.
    public static var detailedLog: String = ""
    
    private enum LogType {
        case warning, error, debug, info
        
        var level: String {
            switch self {
            case .error: return "❌ ERROR"
            case .warning: return "⚠️ WARNING"
            case .info: return "💙 INFO"
            case .debug: return "💚 DEBUG"
            }
        }
    }
    
    // MARK: - Functions
    
    private static func log(_ items: [Any], filename: String = #file, function: StaticString = #function, line: Int = #line, type: LogType) {
        if self.active {
            var _message = type.level + " " + message(from: items)
            if _message.hasSuffix("\n") == false {
                _message += "\n"
            }
            
            self.logged += _message
            
            let filenameWithoutExtension = filename.lastPathComponent.deletingPathExtension
            let log = "\(filenameWithoutExtension):\(line) \(function): \(_message)"
            let timestamp = Date().description(dateSeparator: "-", usFormat: true, nanosecond: true)
            print("\(timestamp) \(filenameWithoutExtension):\(line) \(function): \(_message)", terminator: "")
            
            self.detailedLog += log
        }
    }
    
    public static func warning(_ items: Any..., filename: String = #file, function: StaticString = #function, line: Int = #line) {
        self.log(items, filename: filename, function: function, line: line, type: .warning)
    }
    
    public static func error(_ items: Any..., filename: String = #file, function: StaticString = #function, line: Int = #line) {
        self.log(items, filename: filename, function: function, line: line, type: .error)
    }
    
    public static func debug(_ items: Any..., filename: String = #file, function: StaticString = #function, line: Int = #line) {
        self.log(items, filename: filename, function: function, line: line, type: .debug)
    }
    
    public static func info(_ items: Any..., filename: String = #file, function: StaticString = #function, line: Int = #line) {
        self.log(items, filename: filename, function: function, line: line, type: .info)
    }
    
    private static func message(from items: [Any]) -> String {
        return items
            .map { String(describing: $0) }
            .joined(separator: " ")
    }
    
    /// Clear the log string.
    public static func clear() {
        logged = ""
        detailedLog = ""
    }
    
    /// Save the Log in a file.
    ///
    /// - Parameters:
    ///   - path: Save path.
    ///   - filename: Log filename.
    public static func saveLog(in path: String = FileManager.caches,
                               filename: String = Date().description.appendingPathExtension(".log")!) {
        _ = FileManager.save(content: detailedLog, savePath: path.appendingPathComponent(filename))
    }
}
