//
//  ZXDateUtils.swift
//  ZXStructs
//
//  Created by JuanFelix on 2017/4/7.
//  Copyright © 2017年 screson. All rights reserved.
//

import Foundation

enum ZXHWeekType: Int {
    //case Saturday   =   0
    case Sunday     =   1
    case Monday     =   2
    case Tuesday    =   3
    case Wednesday  =   4
    case Thurday    =   5
    case Friday     =   6
    case Saturday   =   7
    
    func strEN() -> String {
        switch self {
        case .Saturday:
            return "SAT"
        case .Sunday:
            return "SUN"
        case .Monday:
            return "MON"
        case .Tuesday:
            return "TUE"
        case .Wednesday:
            return "WED"
        case .Thurday:
            return "THU"
        case .Friday:
            return "FRI"
        }
    }
    
    func strCN() -> String {
        switch self {
        case .Saturday:
            return "周六"
        case .Sunday:
            return "周日"
        case .Monday:
            return "周一"
        case .Tuesday:
            return "周二"
        case .Wednesday:
            return "周三"
        case .Thurday:
            return "周四"
        case .Friday:
            return "周五"
        }
    }
}

class ZXDateUtils: NSObject {
    static func zx_serialNumber() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = ZXDateUtils.CHNZONE()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        return formatter.string(from: Date())
    }
    
    static func CHNZONE() -> TimeZone {
        //return  NSTimeZone(name: "Asia/Beijing")
        return NSTimeZone(forSecondsFromGMT: +28800) as TimeZone
    }
    
    static func beijingDate() -> Date {
        let timezone = self.CHNZONE()
        let date = Date()
        let interval = timezone.secondsFromGMT(for: date)
        return date.addingTimeInterval(TimeInterval(interval))
    }
    
    struct current {
        /// current Date&Time
        /// Beijing
        /// - Parameters:
        ///   - chineseFormat: xxxx年xx月xx日 or xxxx-xx-xx
        ///   - timeWithSecond: 时间是否需要秒数
        /// - Returns: return value description
        static func dateAndTime(_ chineseFormat:Bool,timeWithSecond:Bool) -> String{
            let formatter = DateFormatter()
            formatter.timeZone = ZXDateUtils.CHNZONE()
            if chineseFormat {
                if timeWithSecond {
                    formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                }else{
                    formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
                }
            }else {
                if timeWithSecond {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                }else{
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
            }
            return formatter.string(from: Date())
        }
        
        /// currentDate
        /// Beijing
        /// - Parameter chineseFormat: xxxx年xx月xx日 or xxxx-xx-xx
        /// - Returns: return value description
        static func date(_ chineseFormat:Bool) -> String{
            let formatter = DateFormatter()
            formatter.timeZone = ZXDateUtils.CHNZONE()
            if chineseFormat {
                formatter.dateFormat = "yyyy年MM月dd日"
            }else {
                formatter.dateFormat = "yyyy-MM-dd"
            }
            return formatter.string(from: Date())
        }
        
        /// currentTime
        /// Beijing
        /// - Parameter timeWithSecond: 时间是否需要秒数
        /// - Returns: return value description
        static func time(_ timeWithSecond:Bool) -> String{
            let formatter = DateFormatter()
            formatter.timeZone = ZXDateUtils.CHNZONE()
            if timeWithSecond {
                formatter.dateFormat = "HH:mm:ss"
            }else{
                formatter.dateFormat = "HH:mm"
            }
            return formatter.string(from: Date())
        }
        
        /// Current MilliSecond
        ///获取当前 秒级 时间戳 - 10位
        /// - Returns: return value description
        static func timeStamp() -> Int {
            return Int(Date().timeIntervalSince1970)
        }
        
        /// Current MilliSecond
        ///获取当前 毫秒级 时间戳 - 13位
        /// - Returns: return value description
        static func millisecond() -> Int64 {
            return Int64(Date().timeIntervalSince1970 * 1000)
        }
        
        static func string(format : String = "MM/dd") -> String {
            let formatter = DateFormatter()
            formatter.timeZone = ZXDateUtils.CHNZONE()
            formatter.dateFormat = format
            return formatter.string(from: Date())
        }
        
        static func day(splitPrefeix0: Bool = false) -> String {
            let str = self.string(format: "MM/dd")
            let day = str.split(separator: "/")
            let m = Int(day.first!) ?? 0
            let d = Int(day.last!) ?? 0
            return String.init(format: "%d/%d", m, d)
        }
        
        static func weekType() -> ZXHWeekType? {
            let calendar = NSCalendar.current
            let dateComp = calendar.component(Calendar.Component.weekday, from: Date())
            return ZXHWeekType.init(rawValue: dateComp)
        }
       
    }
    
    struct millisecond {
        static func dateformat(_ millisecond:Int64,format:String?) -> String {
            let formatter = DateFormatter()
            formatter.timeZone = ZXDateUtils.CHNZONE()
            if let format = format {
                formatter.dateFormat = format
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            }
            return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(millisecond / 1000)))
        }
        
        static func dateformat(_ millisecond:TimeInterval,format:String?) -> String {
            let formatter = DateFormatter()
            formatter.timeZone = ZXDateUtils.CHNZONE()
            if let format = format {
                formatter.dateFormat = format
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            }
            let date =  Date(timeIntervalSince1970: millisecond)
            return formatter.string(from: date)
        }
        
        /// Date&Time from Millisecond
        /// Beijing
        /// - Parameters:
        ///   - millisecond: millisecond description
        ///   - chineseFormat: chineseFormat description
        ///   - timeWithSecond: timeWithSecond description
        /// - Returns: return value description
        static func datetime(_ millisecond:Int64,chineseFormat:Bool,timeWithSecond:Bool) -> String {
            let formatter = DateFormatter()
            formatter.timeZone = ZXDateUtils.CHNZONE()
            if chineseFormat {
                if timeWithSecond {
                    formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                }else{
                    formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
                }
            }else {
                if timeWithSecond {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                }else{
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
            }
            return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(millisecond / 1000)))
        }
        
        /// Date from millisecond
        /// Beijing
        /// - Parameters:
        ///   - millisecond: millisecond description
        ///   - chineseFormat: chineseFormat description
        /// - Returns: return value description
        static func date(_ millisecond:Int64,chinese:Bool) -> String {
            if chinese {
                return ZXDateUtils.millisecond.dateformat(millisecond,format: "yyyy年MM月dd日")
            } else {
                return ZXDateUtils.millisecond.dateformat(millisecond,format: "yyyy-MM-dd")
            }
        }
        
        /// Time from millisecond
        /// Beijing
        /// - Parameters:
        ///   - millisecond: millisecond description
        ///   - timeWithSecond: timeWithSecond description
        /// - Returns: return value description
        static func time(_ millisecond:Int64,withSecond:Bool) -> String {
            let formatter = DateFormatter()
            formatter.timeZone = ZXDateUtils.CHNZONE()
            if withSecond {
                formatter.dateFormat = "HH:mm:ss"
            }else{
                formatter.dateFormat = "HH:mm"
            }
            return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(millisecond / 1000)))
        }
        
        /// Millisecond from date
        ///
        /// - Parameters:
        ///   - date: date description
        ///   - dateFormat: dateFormat description
        /// - Returns: return value description
        static func fromDate(_ date:String,dateFormat:String!) -> Int64 {
            let formatter = DateFormatter()
            formatter.timeZone = ZXDateUtils.CHNZONE()
            formatter.dateFormat = dateFormat
            if let date = formatter.date(from: date){
                return Int64(date.timeIntervalSince1970 * 1000)
            }
            return 0
        }
    }
    
    
    /// Delta MillSeonds to Time
    ///
    /// - Parameters:
    ///   - dt: delta
    ///   - char: split char
    /// - Returns: CountDownTime
    static func dtMillSecondsToTime(_ dt: Int64, split char: String? = nil, countDownMinutes: Int = 3) -> String {
        let ss = dt / 1000
        let hours = ss / 3600
        let minutes = (ss % 3600) / 60
        let seconds = ss % 60
        var str = ""
        if let char = char {
            if hours > 0 {
                str.append(String.init(format: "%d\(char)", hours))
            }
            if minutes > 0 {
                str.append(String.init(format: "%d\(char)", minutes))
            } else {
                if hours > 0 {
                    str.append("0\(char)")
                }
            }
            if ss <= countDownMinutes * 60 {
                str.append(String.init(format: "%d", seconds))
            }
        } else {
            if hours > 0 {
                str.append(String.init(format: "%d时", hours))
            }
            if minutes > 0 {
                str.append(String.init(format: "%d分", minutes))
            } else {
                if hours > 0 {
                    str.append("0分")
                }
            }
            if ss < countDownMinutes * 60 {
                str.append(String.init(format: "%d秒", seconds))
            }
        }
        return str
    }
    
    
    static func dateFromString(_ date:String,format:String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = self.CHNZONE() as TimeZone?
        formatter.dateFormat = format
        return formatter.date(from: date)
    }
}

extension Date {
    func zx_DateString(_ seperator:String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: +28800) as TimeZone
        formatter.dateFormat = "yyyy\(seperator)MM\(seperator)dd"
        return formatter.string(from: self)
    }
    
    func zx_DateTimeString(_ seperator:String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: +28800) as TimeZone
        formatter.dateFormat = "yyyy\(seperator)MM\(seperator)dd HH:mm:ss"
        return formatter.string(from: self)
    }

}
