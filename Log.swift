import Foundation

fileprivate enum ThemeColor {
    case light, dark
}
fileprivate let themeColor: ThemeColor = .dark


enum LogLevel: Int, CustomStringConvertible, Comparable {
    case verbose
    case debug
    case error
    case info
    
    var description: String {
        switch self {
        case .verbose: return ""
        case .debug:   return " 🔵 "
        case .error:   return " 🔴 "
        case .info:    return themeColor == .light ? " ⚫️ " : " ⚪️ "
        }
    }
    
    public static func <(lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public static func <=(lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue <= rhs.rawValue
    }
    
    public static func >(lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue > rhs.rawValue
    }
    
    public static func >=(lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue >= rhs.rawValue
    }
}


class Log {
    
    enum Group: String {
        case `default`, test
        
        var defaultLogLevel: LogLevel {
            switch self {
            case .test:  return .verbose
            default:     return .verbose
            }
        }
    }
    
    fileprivate init() {}
    
    fileprivate static func timestamp() -> String {
        let date = Date()
        let format = DateFormatter()
        format.locale = .current
        format.dateFormat = "HH:mm:ss.SSS"
        return format.string(from: date)
    }
    
    static func verbose(_ closure: String, group: Group = .default) {
        if group.defaultLogLevel > .verbose { return }
        print("\(self.timestamp())\(group == .default ? "" : " [\(group)]")\(LogLevel.verbose): \(closure)")
    }
    
    static func debug(_ closure: String, group: Group = .default) {
        if group.defaultLogLevel > .debug { return }
        print("\(self.timestamp())\(group == .default ? ":" : " [\(group)]:")\(LogLevel.debug)\(closure)")
    }
    
    static func error(_ closure: String, group: Group = .default) {
        if group.defaultLogLevel > .error { return }
        print("\(self.timestamp())\(group == .default ? ":" : " [\(group)]:")\(LogLevel.error)\(closure)")
    }
    
    static func info(_ closure: String, group: Group = .default) {
        if group.defaultLogLevel > .info { return }
        print("\(self.timestamp())\(group == .default ? ":" : " [\(group)]:")\(LogLevel.info)\(closure)")
    }
}
