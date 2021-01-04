//
//  DataExtension.swift
//  PTSDK
//
//  Created by PainTypeZ on 2020/12/28.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CommonCrypto
// MARK: - Data Extension
public extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
    func string(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
}
// MARK: - NSData Extension
public extension NSData {
    /// 用于支持 string.MD5()
    var hexedString: String {
        var string = String()
        let unsafePointer = bytes.assumingMemoryBound(to: UInt8.self)
        for pointer in UnsafeBufferPointer<UInt8>(start:unsafePointer, count: length) {
            string += Int(pointer).hexedString
        }
        return string
    }
    /// 用于支持 string.MD5()
    var MD5: NSData {
        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
        let unsafePointer = result.mutableBytes.assumingMemoryBound(to: UInt8.self)
        CC_MD5(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(unsafePointer))
        return NSData(data: result as Data)
    }
}
