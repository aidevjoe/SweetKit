import Foundation

extension Date {
    // 获取今天日期
    static func today() -> String {
        let dataFormatter : DateFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd"
        let now : Date = Date()
        return dataFormatter.string(from: now)
    }
    
    // 判断是否是今天
    static func isToday (dateString : String) -> Bool {
        //        let date : String = NSDate.formattDay(dateString)
        return dateString == self.today()
    }
    
    // 判断是否是昨天
    static func isLastDay (dateString : String) -> Bool {
        let todayTimestamp = self.getTimestamp(dateString: today())
        let lastdayTimestamp = self.getTimestamp(dateString: dateString)
        return lastdayTimestamp == todayTimestamp-(24*60*60)
    }
    
    // yyyy-MM-dd格式 转 MM月dd日
    static func formattDay (dataString : String) -> String {
        if dataString.length <= 0 {
            return "errorDate"
        }
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: Date = dateFormatter.date(from: dataString)!
        
        
        // 转换成xx月xx日格式
        let newDateFormatter : DateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "MM月dd日"
        return newDateFormatter.string(from: date)
    }
    
    static func formattYYYYMMDDHHMMSS(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    
    // 根据日期获取时间戳
    static func getTimestamp (dateString : String) -> TimeInterval {
        if dateString.length <= 0 {
            return 0
        }
        let newDateStirng = dateString.appending(" 00:00:00")
        
        let formatter : DateFormatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.dateStyle = DateFormatter.Style.short
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Beijing")
        
        let dateNow = formatter.date(from: newDateStirng)
        
        return (dateNow?.timeIntervalSince1970)!
    }
    
    //时间戳转化时间
    static func timeStampToString(timeStamp:String) -> String {
        
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let formatter = DateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Beijing")
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return formatter.string(from: date as Date)
    }
    
    // 获取星期
    static func weekWithDateString (dateString : String) -> String{
        let timestamp = Date.getTimestamp(dateString: dateString)
        let day = Int(timestamp/86400)
        let array : Array = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"];
        return array[(day-3)%7]
        //        return "星期\((day-3)%7))"
    }
    
    static func currentDayzero() -> Date {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
        var components = calendar.dateComponents(unitFlags, from: Date())
        components.timeZone = TimeZone.current
        components.hour = 0
        components.minute = 0
        components.second = 0
        if let date = calendar.date(from: components) {
            return date
        }
        return Date()
    }
    
    var YYYYMMDDDateString : String {
        let dateFormatter: DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var HHMMDateString : String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
