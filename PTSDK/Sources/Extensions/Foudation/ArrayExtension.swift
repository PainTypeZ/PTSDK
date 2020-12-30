//
//  ArrayExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/29.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension Array {
    /// 查重，传入判断条件 { $0.name == "123" }
    func filterCheck(_ filter: (Element) -> Bool) -> Bool {
        var result = false
        for value in self {
            result = filter(value)
            if result == true {
                break
            }
        }
        return result
    }
    /// 去重, 传入判断条件，例如{ $0.name }
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({ filter($0) }).contains(key) {
                result.append(value)
            }
        }
        return result
    }
    /// 转json字符串
    var jsonString: String {
        var result:String = ""
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)

            if let json = String(data: jsonData, encoding: .utf8) {
                result = json
            }
        } catch let error {
            debugPrint(error)
            result = ""
        }
        return result
    }
}

public extension Array where Element: Codable {
    /// codable协议下转jsonString
    var jsonStringFromCodable: String {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let json = String(data: jsonData, encoding: .utf8) ?? ""
            return json
        } catch let error {
            debugPrint(error)
            return ""
        }
    }
}
