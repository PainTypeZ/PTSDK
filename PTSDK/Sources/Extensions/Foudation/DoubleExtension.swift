//
//  DoubleExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension Double {
    // 00:10
    var timeCountString: String {
        let timeInterval:TimeInterval = self
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        let text = date.timeCountString
        return text
    }
    /// double转string，保留x位小数
    /// - Parameter scale: 保留小数的位数
    /// - Returns: 字符串
    func string(scale: Int = 2) -> String {
        let formatStr = "%.\(scale)f"
        let result = String(format: formatStr, self)
        return result
    }
    /// double转string，小数点前使用x位0占位
    /// - Parameter scale: 小数点左侧占位0的个数
    /// - Returns: 字符串
    func zeroAtFrontString(scale: Int = 2) -> String {
        let formatStr = "%0\(scale).f"
        let result = String(format: formatStr, self)
        return result
    }
    
    var int: Int {
        return Int(self)
    }
    
    var decimal: Decimal {
        return Decimal(self)
    }
}
