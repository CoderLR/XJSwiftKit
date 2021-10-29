//
//  YSDateTool.swift
//  XJSwiftKit
//
//  Created by Mr.Yang on 2021/10/20.
//

import UIKit

// MARK: - 当前时间相关
class YSDateTool {
    
    // MARK: - 今年
    static func currentYear() -> Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day],  from: Date())
        return com.year!
    }
    
    // MARK: - 今月
    static func currentMonth() -> Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day],  from: Date())
        return com.month!
    }
    
    // MARK: - 今日
    static func currentDay() -> Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day],  from: Date())
        return com.day!
    }
    
    // MARK: - 今天星期几
    static func currentWeekDay() -> Int{
        let interval = Int(Date().timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
    }
    
    // MARK: - 本月天数
    static func countOfDaysInCurrentMonth() -> Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day,  in: NSCalendar.Unit.month,  for: Date())
        return (range?.length)!
    }
    
    // MARK: - 当月第一天是星期几
    static func firstWeekDayInCurrentMonth() -> Int {
        //星期和数字一一对应 星期日：7
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(Date().xj.year)+"-"+String(Date().xj.month))
        let calender = Calendar(identifier: Calendar.Identifier.gregorian)
        let comps = (calender as NSCalendar?)?.components(NSCalendar.Unit.weekday,  from: date!)
        var week = comps?.weekday
        if week == 1 {
            week = 8
        }
        return week! - 1
    }
    
    // MARK: - - 获取指定日期各种值
    //根据年月得到某月天数
    static func getCountOfDaysInMonth(year: Int, month: Int) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day,  in: NSCalendar.Unit.month,  for: date!)
        return (range?.length)!
    }
    
    // MARK: - 根据年月得到某月第一天是周几
    static func getfirstWeekDayInMonth(year: Int, month: Int) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let comps = (calendar as NSCalendar?)?.components(NSCalendar.Unit.weekday,  from: date!)
        let week = comps?.weekday
        return week! - 1
    }

    // MARK: - date转日期字符串
    static func dateToDateString(_ date: Date,  dateFormat: String) -> String {
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = dateFormat

        let date = formatter.string(from: date)
        return date
    }

    // MARK: - 日期字符串转date
    static func dateStringToDate(_ dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateStr)
        return date!
    }
    
    // MARK: - 时间字符串转date
    static func timeStringToDate(_ dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd  HH: mm: ss"
        let date = dateFormatter.date(from: dateStr)
        return date!
    }

    // MARK: - 计算天数差
    static func dateDifference(_ dateA: Date,  from dateB: Date) -> Double {
        let interval = dateA.timeIntervalSince(dateB)
        return interval/86400

    }

    // MARK: - 比较时间先后
    static func compareOneDay(oneDay: Date,  withAnotherDay anotherDay: Date) -> Int {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let oneDayStr: String = dateFormatter.string(from: oneDay)
        let anotherDayStr: String = dateFormatter.string(from: anotherDay)
        let dateA = dateFormatter.date(from: oneDayStr)
        let dateB = dateFormatter.date(from: anotherDayStr)
        let result: ComparisonResult = (dateA?.compare(dateB!))!
        //Date1  is in the future
        if(result == ComparisonResult.orderedDescending ) {
            return 1
        }
        //Date1 is in the past
        else if(result == ComparisonResult.orderedAscending) {
            return 2
        }
        //Both dates are the same
        else {
            return 0
        }
    }

    // MARK: - 时间与时间戳之间的转化
    //将时间转换为时间戳
    static func stringToTimeStamp(_ stringTime: String) -> Int {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH: mm: ss"
        dfmatter.locale = Locale.current
        let date = dfmatter.date(from: stringTime)
        let dateStamp: TimeInterval = date!.timeIntervalSince1970
        let dateSt: Int = Int(dateStamp)
        return dateSt
    }
    
    //将时间戳转换为年月日
    static func timeStampToString(_ timeStamp: String) -> String {
        let string = NSString(string: timeStamp)
        let timeSta: TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    //将时间戳转换为具体时间
    static func timeStampToStringDetail(_ timeStamp: String) -> String {
        let string = NSString(string: timeStamp)
        let timeSta: TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日HH: mm: ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    //将时间戳转换为时分秒
    static func timeStampToHHMMSS(_ timeStamp: String) -> String {
        let string = NSString(string: timeStamp)
        let timeSta: TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="HH: mm: ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    //获取系统的当前时间戳
    static func getStamp() -> Int{
        //获取当前时间戳
        let date = Date()
        let timeInterval: Int = Int(date.timeIntervalSince1970)
        return timeInterval
    }
    
    //月份数字转汉字
    static func numberToChina(monthNum: Int) -> String {
        let ChinaArray = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
        let ChinaStr: String = ChinaArray[monthNum - 1]
        return ChinaStr
    }
    
    // MARK: - 数字前补0
    static func add0BeforeNumber(_ number: Int) -> String {
        if number >= 10 {
            return String(number)
        }else{
            return "0" + String(number)
        }
    }

    // MARK: - 将时间显示为（几分钟前，几小时前，几天前）
    static func compareCurrentTime(str: String) -> String {

        let timeDate = self.timeStringToDate(str)
        let currentDate = NSDate()
        let timeInterval = currentDate.timeIntervalSince(timeDate)
        var temp: Double = 0
        var result: String = ""
        if timeInterval/60 < 1 {
            result = "刚刚"
        }else if (timeInterval/60) < 60{
            temp = timeInterval/60
            result = "\(Int(temp))分钟前"
        }else if timeInterval/60/60 < 24 {
            temp = timeInterval/60/60
            result = "\(Int(temp))小时前"
        }else if timeInterval/(24 * 60 * 60) < 30 {
            temp = timeInterval / (24 * 60 * 60)
            result = "\(Int(temp))天前"
        }else if timeInterval/(30 * 24 * 60 * 60)  < 12 {
            temp = timeInterval/(30 * 24 * 60 * 60)
            result = "\(Int(temp))个月前"
        }else{
            temp = timeInterval/(12 * 30 * 24 * 60 * 60)
            result = "\(Int(temp))年前"
        }
        return result
    }
}
