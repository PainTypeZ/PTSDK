//
//  DateExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

/// 星期x枚举
public enum WeekDay: Int {
    case Sunday = 1
    case Monday
    case Tuesday
    case WednesDay
    case Thursday
    case Friday
    case SaturyDay
    /// 获取中文名
    var chsName: String {
        switch self {
        case .Sunday:
            return "星期日"
        case .Monday:
            return "星期一"
        case .Tuesday:
            return "星期二"
        case .WednesDay:
            return "星期三"
        case .Thursday:
            return "星期四"
        case .Friday:
            return "星期五"
        case .SaturyDay:
            return "星期六"
        }
    }
}
// MARK: - Date Extension
public extension Date {
    /// 历史时间
    var historyString: String {
        let dateFormatter = DateFormatter()
        var dateString = ""
        //判断时间节点
        if isToday
        {
            let components = deltaWithNow
            //今天内一个小时以上 显示"xx小时之前"
            if abs(components.hour ?? 0) >= 1 {
                dateString = "\(abs(components.hour!))" + "小时前"
            }
            else if abs(components.minute ?? 0) >= 1 {
                //一个小时以内 显示"xx分钟之前"
                dateString = "\(abs(components.minute!))" + "分钟前"
            }
            else {
                //一分钟以内 显示"刚刚"
                dateString = "刚刚"
            }
        } else {
            //昨天 显示"昨天 mm:ss"
            if isYestoday {
                dateFormatter.dateFormat = "HH:mm"
                dateString = "昨天" + " " + dateFormatter.string(from: self)
            }
            //今年但是不是昨天 显示 MM-dd
            if !isYestoday {
                dateFormatter.dateFormat = "MM-dd HH:mm"
                dateString = dateFormatter.string(from: self)
            }
            //今年以前 yyyy-MM-dd
            if !isThisYear {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                dateString = dateFormatter.string(from: self)
            }
        }
        return dateString
    }
    /// 判断是否是today
    var isToday: Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day)
    }
    /// 判断是否昨天
    var isYestoday: Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        if selfCmps.day == nil || nowComps.day == nil {
            return false
        }
        let count = nowComps.day! - selfCmps.day!
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (count == 1)
    }
    /// 判断是否今年
    var isThisYear: Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: self)
        let result = nowCmps.year == selfCmps.year
        return result
    }
    /// 获取与当前时间的差距
    var deltaWithNow: DateComponents{
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.hour,.minute,.second], from: self, to: Date())
        return cmps
    }
    
    /// Date To catDate
    var catDateString: String {
        var result:String
        if isToday {
            result = "今天 " + timeString
        } else {
            result = DateFormatter.catDatetime.string(from: self)
        }
        return result
    }
    /// 当天起点
    var dayStart: Date {
        let calendar: Calendar = Calendar.current
        let componentsSet: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second ]
        var components = calendar.dateComponents(componentsSet, from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        if let date = calendar.date(from: components) {
            return date
        } else {
            return self
        }
    }
    /// 当天终点
    var dayEnd: Date {
        let calendar: Calendar = Calendar.current
        let componentsSet: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second ]
        var components = calendar.dateComponents(componentsSet, from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        if let date = calendar.date(from: components) {
            return date
        } else {
            return self
        }
    }
    
    /// 当天起点
    var dayStartString: String {
        return dayStart.string
    }
    /// 当天终点
    var dayEndString: String {
        return dayEnd.string
    }
    /// Date To String: 02
    var dayString: String {
        return DateFormatter.dd.string(from: self)
    }
    /// Date To String: 1970-01-01 13:20:33
    var string: String {
        return DateFormatter.yyyyMMddHHmmss.string(from: self)
    }
    /// Date To String: 13:20
    var timeString: String {
        return DateFormatter.HHmm.string(from: self)
    }
    /// Date To String: 1970-01-01
    var dateString: String {
        return DateFormatter.yyyymmdd.string(from: self)
    }
    /// Date To String: 1970年01月01日
    var dateStringKanji: String {
        return DateFormatter.yyyymmddKanji.string(from: self)
    }
    /// Date to String: 00:01
    var timeCountString: String {
        return DateFormatter.mmss.string(from: self)
    }
    /// Date to String: 1970年01月01日 星期一
    var dateStringKanjiWithWeekDay: String {
        return DateFormatter.yyyymmddKanjiWithEEEE.string(from: self)
    }
    /// Date ot String: 1970年01月01日 星期一 上午
    var dateStringKanjiWithWeekDayAAA: String {
        return DateFormatter.yyyymmddKanjiWithEEEEaaa.string(from: self)
    }
    /// 星期x
    var weekday: String {
        guard let calendar = NSCalendar.init(calendarIdentifier: .gregorian) else {
            return ""
        }
        let timeZone = NSTimeZone.init(name: "Asia/Shanghai")
        calendar.timeZone = timeZone! as TimeZone
        let calendarUnit = NSCalendar.Unit.weekday
        let theComponents = calendar.components(calendarUnit, from: self)
        guard let weekday = theComponents.weekday else {
            return ""
        }
        return WeekDay(rawValue: weekday)?.chsName ?? ""
    }
    /// 上午下午
    var halfDay: String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "aaa"
        dateFormat.amSymbol = "上午好，"
        dateFormat.pmSymbol = "下午好，"
        return dateFormat.string(from: self)
    }
}

// MARK: - DateFormatter Extension
public extension DateFormatter{
    static var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "zh-CN")
        return formatter
    }
    
    static var mmss: DateFormatter {
        dateFormatter.dateFormat = "mm:ss"
        return dateFormatter
    }
    
    static var yyyymmddNoLine: DateFormatter {
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter
    }
    
    static var yyyyMMddHHmmssNoLine : DateFormatter {
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter
    }
    
    static var yyyymmdd: DateFormatter {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    static var yyyymmddKanji: DateFormatter {
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter
    }
    
    static var yyyymmddKanjiWithEEEE: DateFormatter {
        dateFormatter.dateFormat = "yyyy年MM月dd日 EEEE"
        return dateFormatter
    }
    
    static var yyyymmddKanjiWithEEEEaaa: DateFormatter {
        dateFormatter.dateFormat = "yyyy年MM月dd日 EEEE aaa"
        return dateFormatter
    }
    
    static var yyyymmddWithSlash: DateFormatter {
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }
    static var yyyymmddHHmmssWithSlash: DateFormatter {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        return dateFormatter
    }
    
    static var HHmmss: DateFormatter {
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
    
    static var dd: DateFormatter {
        dateFormatter.dateFormat = "dd"
        return dateFormatter
    }
    
    static var HHmm: DateFormatter {
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    static var yyyyMMddHHmmss: DateFormatter {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
    
    static var yyyymmddHHmmKanji: DateFormatter {
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return dateFormatter
    }
    
    static var yyyymmddHHmmssKanji: DateFormatter {
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dateFormatter
    }
    
    static var newsDatetime : DateFormatter {
        dateFormatter.dateFormat = "MM/dd(EEE) HH:mm"
        return dateFormatter
    }
    static var catDatetime: DateFormatter {
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter
    }
    static var catMonthTime: DateFormatter {
        dateFormatter.dateFormat = "MM月dd日HH:mm"
        return dateFormatter
    }
    static var catYearMonth: DateFormatter {
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter
    }
    static var catYearMonthCN: DateFormatter {
        dateFormatter.dateFormat = "yyyy年MM月"
        return dateFormatter
    }
}
