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
            let timestamp = Date().description(dateSeparator: "-", usFormat: true, nanosecond: true)
            let logMessage = "\(timestamp) \(filenameWithoutExtension):\(line) \(function): \(_message)"
            print(logMessage, terminator: "")
            
            self.detailedLog += logMessage
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
    public static func saveLog(in path: String = FileManager.log,
                               filename: String = Date().YYYYMMDDDateString.appendingPathExtension("log")!) {
        if detailedLog.isEmpty { return }
        let fullPath = path.appendingPathComponent(filename)
        var logs = detailedLog
        if FileManager.default.fileExists(atPath: fullPath) {
            logs = try! String(contentsOfFile: fullPath, encoding: .utf8)
            logs = logs + detailedLog
            _ = FileManager.save(content: logs, savePath: path.appendingPathComponent(filename))
            return
        }
        FileManager.create(at: fullPath)
        _ = FileManager.save(content: logs, savePath: fullPath)
    }
}
