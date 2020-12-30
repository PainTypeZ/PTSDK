//
//  DecimalExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension Decimal {
    
    /// decimal转字符串
    /// - Parameter scale: 保留小数的位数
    /// - Returns: 字符串
    func string(scale: Int16 = 2) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = Int(scale) // 最小小数位数
        formatter.minimumIntegerDigits = 1 // 最小整位数
        let roundResult = roundToNSDecimal(scale: scale)
        guard let result = formatter.string(from: roundResult) else {
            debugPrint("decimal转换string出错")
            return ""
        }
        return result
    }
    
    /// decimal保留小数处理
    /// - Parameter scale: 保留小数的位数
    /// - Returns: 保留x位小数后的decimal
    func round(scale: Int16 = 2) -> Decimal {
        let decimal = Decimal(roundToNSDecimal(scale: scale).doubleValue)
        return decimal
    }
    
    private func roundToNSDecimal(scale: Int16 = 2) -> NSDecimalNumber {
        let roundBehavior = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain,
                                                   scale: scale,
                                                   raiseOnExactness: false,
                                                   raiseOnOverflow: false,
                                                   raiseOnUnderflow: false,
                                                   raiseOnDivideByZero: false)
        let number = NSDecimalNumber(decimal: self)
        return number.rounding(accordingToBehavior: roundBehavior)
    }
    
    var int: Int {
        let number = NSDecimalNumber(decimal: self).intValue
        return number
    }
    
    var double: Double {
        let number = NSDecimalNumber(decimal: self).doubleValue
        return number
    }
}
