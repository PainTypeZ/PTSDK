//
//  DictionaryExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension Dictionary {
    /// json字符串
    var jsonString: String {
        var result:String = ""
        do {
            // 如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            if let json = String(data: jsonData, encoding: .utf8) {
                result = json
            }
            debugPrint(result)
        } catch let error {
            debugPrint(error)
            debugPrint("字典转JSON字符串失败")
            result = ""
        }
        return result
    }
    /// 拼接字典
    mutating func append(_ dict: Dictionary) {
        dict.forEach {
            let (key, value) = ($0, $1)
            updateValue(value, forKey: key)
        }
    }
}
