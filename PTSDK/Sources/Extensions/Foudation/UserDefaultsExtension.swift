//
//  UserDefaultsExtension.swift
//  PTTools
//
//  Created by PainTypeZ on 2020/12/22.
//

import Foundation
public extension UserDefaults {
    /// 清除偏好设置某Key的value
    static func removeValue(for key: String) {
        standard.removeObject(forKey: key)
    }
    /// 添加偏好设置某Key和value
    static func setValue(_ value: Any, for key: String) {
        standard.set(value, forKey: key)
    }
    /// 获取偏好设置的string
    static func string(for key: String) -> String {
        standard.string(forKey: key) ?? ""
    }
    /// 获取偏好设置的bool
    static func bool(for key: String) -> Bool {
        standard.bool(forKey: key)
    }
    /// 存入偏好设置model
    static func setModel<T: Codable>(_ model: T, key: String) -> Bool {
        do {
            try standard.set(JSONEncoder().encode(model), forKey: key)
            return true
        } catch let error {
            debugPrint(error)
            return false
        }
    }
    /// 取出偏好设置model
    static func getModel<T: Codable>(from key: String) -> T? {
        guard let data = standard.value(forKey: key) as? Data else {
            return nil
        }
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
}
