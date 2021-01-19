//
//  StringExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension String {
    /**
     从xxx分割后的前半部分
     
     - parameter separation: 分割字符串
     */
    @available(*, deprecated, message: "Please use prefix(_ separation: String) -> String instead")
    func getPrefix(_ separation: String) -> String {
        guard let dotIndex = range(of: separation) else {
            return ""
        }
        let prefix = String(self.prefix(upTo: dotIndex.lowerBound))
        let result = prefix.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return result
    }
    /**
     从xxx分割后的后半部分
     
     - parameter separation: 分割字符串
     */
    @available(*, deprecated, message: "Please use suffix(_ separation: String) -> String instead")
    func getSuffix(_ separation: String) -> String {
        guard let dotIndex = range(of: separation) else {
            return "0"
        }
        let suffix = String(self.suffix(from: dotIndex.upperBound))
        let result = suffix.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return result
    }
    /**
     从xxx分割后的前半部分
     
     - parameter separation: 分割字符串
     */
    func prefix(_ separation: String) -> String {
        guard let dotIndex = range(of: separation) else {
            return ""
        }
        let prefix = String(self.prefix(upTo: dotIndex.lowerBound))
        let result = prefix.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return result
    }
    /**
     从xxx分割后的后半部分
     
     - parameter separation: 分割字符串
     */
    func suffix(_ separation: String) -> String {
        guard let dotIndex = range(of: separation) else {
            return "0"
        }
        let suffix = String(self.suffix(from: dotIndex.upperBound))
        let result = suffix.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return result
    }
    /**
     文字宽度
     
     - parameter font: 字体
     - parameter height: 字高
     - parameter width: 字宽
     */
    func width(font: UIFont, height: CGFloat, width: CGFloat? = nil) -> CGFloat {
        let attributrs:[NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        var maxWidth: CGFloat
        if let width = width {
            maxWidth = width
        } else {
            maxWidth = CGFloat(MAXFLOAT)
        }
        let size = NSString(string: self).boundingRect(with: CGSize(width: maxWidth, height: height),
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: attributrs,
                                                       context: nil).size
        return size.width
    }
    /**
     文字高度
     
     - parameter font: 字体
     - parameter height: 字高
     - parameter width: 字宽
     */
    func height(font: UIFont, width: CGFloat, height: CGFloat? = nil) -> CGFloat {
        let attributrs:[NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        var maxHeight: CGFloat
        if let height = height {
            maxHeight = height
        } else {
            maxHeight = CGFloat(MAXFLOAT)
        }
        let size = NSString(string: self).boundingRect(with: CGSize(width: width, height: maxHeight),
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: attributrs,
                                                       context: nil).size
        return size.height
    }
    // Convert To Int/Double/CGFloat/Float
    var int: Int {
        guard let result = Int(self) else {
            return 0
        }
        return result
    }
    var double: Double {
        guard let result = Double(self) else {
            return 0.0
        }
        return result
    }
    
    var cgFloat: CGFloat {
        let doubleResult = double
        return CGFloat(doubleResult)
    }
    var float: Float {
        guard let result = Float(self) else {
            return 0.0
        }
        return result
    }
    // 截取经纬度字符串，返回一个数组
    func subCoordinateString() -> [String] {
        let array:[String.SubSequence] = split(separator: ";")
        var resultArray:[String] = []
        for subString in array {
            let newString = String(subString)
            resultArray.append(newString)
        }
        return resultArray
    }
    // 截取经纬度: xxx.xxxxx,xx.xxxxx
    // 获取经度（逗号前）
    func subLongitude() -> String {
        guard let dotIndex = self.range(of: ",") else {
            return "0"
        }
        let longitude = String(self.prefix(upTo: dotIndex.lowerBound))
        let longitudeFix = longitude.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return longitudeFix
    }
    // 获取纬度（逗号后）
    func subLatitude() -> String {
        guard let dotIndex = self.range(of: ",") else {
            return "0"
        }
        let latitude = String(self.suffix(from: dotIndex.upperBound))
        let latitudeFix = latitude.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return latitudeFix
    }
    // 截取地址
    func subAddress(suffixString:String) -> String {
        guard let index = self.range(of: suffixString) else {
            return "数据错误"
        }
        let address = String(self.suffix(from: index.upperBound))
        let addressFix = address.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return addressFix
    }
    // 获取起点城市“—”前
    func subStartCity() -> String {
        guard let dotIndex = self.range(of: "—") else {
            return "数据错误"
        }
        let startCity = String(self.prefix(upTo: dotIndex.lowerBound))
        let startCityFix = startCity.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return startCityFix
    }
    // 获取终点城市“—”后
    func subEndCity() -> String {
        guard let dotIndex = self.range(of: "—") else {
            return "数据错误"
        }
        let endCity = String(self.suffix(from: dotIndex.upperBound))
        let endCityFix = endCity.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return endCityFix
    }
    // String To MD5
    func MD5(isUppercased: Bool = false) -> String {
        let data = (self as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        var result: String
        if isUppercased {
            result = data.MD5.hexedString.uppercased()
        } else {
            result = data.MD5.hexedString
        }
        return result
    }
    // N位数字验证码
    func validateVerificationCode(length: Int) -> Bool {
        let code = "[0-9]{\(length)}"
        let regexCode = NSPredicate(format: "SELF MATCHES %@", code)
        if regexCode.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }
    // 8～16位并且包含至少一个字母的密码验证
    func validatePassword() -> Bool {
        var isPass = true
        let passwordC = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$"
        let regexPasswordC = NSPredicate(format: "SELF MATCHES %@", passwordC)
        if regexPasswordC.evaluate(with: self) != true {
            isPass = false
        }
        return isPass
    }
    // validate mobilePhoneNumber
    func isPhoneNumber() -> Bool {
        guard !isEmpty else {
            return false
        }
        //        let mobile = "^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}$"
        let mobile = "^(10|11|12|13|14|15|16|17|18|19)\\d{9}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }
    // 获取手机号后四位  *1234
    func subBlockPhone() -> String {
        if self.count > 5 {
            let subString = self.suffix(4)
            return String("*" + subString)
        } else {
            return "无效的手机号"
        }
    }
    // replace mobilePhoneNumber middle numbers like 123****1234;替换手机号中间四位
    func blockMiddlePhoneNumber() -> String {
        if self.count > 7 {
            let start = self.index(startIndex, offsetBy: 3)
            let end = self.index(startIndex, offsetBy: 6)
            let result = self.replacingCharacters(in: start...end, with: "****")
            return result
        } else {
            return "无效的手机号"
        }
    }
    // 获取“yyyy-MM-dd hh:mm:ss”中的日期
    func subDate() -> String {
        guard let index = self.range(of: " "), count > 3 else {
            return "数据错误"
        }
        let date = String(self.prefix(upTo: index.lowerBound))
        let dateFix = date.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return dateFix
    }
    // 截取时间字符串的小时
    func subHour() -> String {
        guard let index = self.range(of: ":"), count > 3 else {
            return "数据错误"
        }
        let hour = String(self.prefix(upTo: index.lowerBound))
        let hourFix = hour.trimmingCharacters(in: .whitespacesAndNewlines)// 处理首尾空格
        return hourFix
    }
    // 截取C#时间字符串的天
    func subDayOfCSharpDateString() -> String {
        guard let index = self.firstIndex(of: "T") else {
            return "数据错误"
        }
        let indexR = self.index(index, offsetBy: -2)
        return String(self[indexR..<index])
    }
    // 转换C#时间为“yyyy-MM-dd hh:mm:ss”
    func transCSharpDateToLocalDateString() -> String {
        guard let tIndex = firstIndex(of: "T") else {
            return "数据错误"
        }
        let str = replacingCharacters(in: tIndex...tIndex, with: " ")
        guard let dotIndex = str.firstIndex(of: ".") else {
            return str
        }
        let result = str[startIndex..<dotIndex]
        return String(result)
    }
    // 转换为Decimal
    var decimal: Decimal {
        guard let result = Decimal(string: self) else {
            return 0
        }
        return result
    }
    
    // 验证手机号合法性
    var verifyPhoneNumber: String? {
        return isPhoneNumber() == true ? self : nil
    }
    // 验证密码合法性
    var verifyPassword: String? {
        return validatePassword() == true ? self : nil
    }
    // 验证短信验证码合法性
    func verifySMSCode(length: Int) -> String? {
        return validateVerificationCode(length: length) == true ? self :nil
    }
    
    // JSON字符串转字典
    var dictionary: [String: Any] {
        var dict: [String: Any]
        if let data = data(using: String.Encoding.utf8) {
            do {
                let options = JSONSerialization.ReadingOptions.init(rawValue: 0)
                let object = try JSONSerialization.jsonObject(with: data, options: options)
                if let dictObject = object as? [String: Any] {
                    dict = dictObject
                } else {
                    debugPrint("JSON字符串转字典失败")
                    dict = [:]
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                dict = [:]
            }
        } else {
            debugPrint("JSON字符串转字典时data格式化失败")
            dict = [:]
        }
        return dict
    }
}
