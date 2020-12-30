//
//  CGFloatExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension CGFloat {
    var string: String {
        let doubleSelf = Double(self)
        return String(doubleSelf)
    }
    // 00:10
    var timeCountString: String {
        let timeInterval:TimeInterval = Double(self)
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        let text = date.timeCountString
        return text
    }
    var int: Int {
        return Int(self)
    }
}
