//
//  IntExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension Int {
    // 用于支持 string.MD5()
    var hexedString: String {
        return NSString(format:"%02x", self) as String
    }
    // 00:10
    var timeCountString: String {
        let timeInterval: TimeInterval = Double(self)
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        let text = date.timeCountString
        return text
    }
    
    func zeroAtFrontString(scale: Int = 2) -> String {
        let formatStr = "%0\(scale)d"
        let result = String(format: formatStr, self)
        return result
    }
    
    var string: String {
        return "\(self)"
    }
    
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
