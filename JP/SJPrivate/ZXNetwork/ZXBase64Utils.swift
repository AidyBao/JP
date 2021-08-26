//
//  ZXBase64Utils.swift
//  URLEncode
//
//  Created by JuanFelix on 2017/6/23.
//  Copyright © 2017年 screson. All rights reserved.
//

import Foundation

struct ZX_Base64Keys {
    static let standard =   "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    //static let custom   =   "OBHIJKLdwxbTUV01p347DEFyjlm*o2RNAPQ]izk56C89ScvefGMXYZaqrstughnW"
    static let custom   =   "OBHIJKLdwxbTUV01p347DEFyjlm-o2RNAPQ~izk56C89ScvefGMXYZaqrstughnW"
}

extension String {
    func zx_base64Encode(isCustom: Bool = true) -> String {
        var keys = ZX_Base64Keys.standard
        if isCustom {
            keys = ZX_Base64Keys.custom
        }
        let mString = self
        if let data = mString.data(using: String.Encoding.utf8) {
            let strLen = mString.lengthOfBytes(using: String.Encoding.utf8)
            let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: strLen)
            data.copyBytes(to: bytes, count: strLen)
            var mod = 0
            var prev:UInt8 = 0
            var base64String = ""
            let startIndex = keys.startIndex
            for i in 0..<strLen {
                mod = i % 3
                if mod == 0 {
                    let index = keys.index(startIndex, offsetBy: Int((bytes[i] >> 2) & 0x3F))
                    base64String.append(keys[index])
                } else if mod == 1 {
                    let index = keys.index(startIndex, offsetBy: Int((prev << 4 | (bytes[i] >> 4 & 0x0F)) & 0x3F))
                    base64String.append(keys[index])
                } else {
                    let index = keys.index(startIndex, offsetBy: Int(((bytes[i] >> 6 & 0x03) | prev << 2) & 0x3F))
                    base64String.append(keys[index])
                    let index2 = keys.index(startIndex, offsetBy: Int(bytes[i] & 0x3F))
                    base64String.append(keys[index2])
                }
                prev = bytes[i]
            }
            if mod == 0 {
                let index = keys.index(startIndex, offsetBy: Int(prev << 4 & 0x3C))
                base64String.append(keys[index])
                base64String.append("==")
            } else if mod == 1 {
                let index = keys.index(startIndex, offsetBy: Int(prev << 2 & 0x3F))
                base64String.append(keys[index])
                base64String.append("=")
            }
            bytes.deinitialize(count: strLen)
            bytes.deallocate()
            if base64String.count > 0 {
                return base64String
            }
        }
        return self
    }
    
    func zx_base64Decode(isCustom: Bool = true) -> String {
        var keys = ZX_Base64Keys.standard
        if isCustom {
            keys = ZX_Base64Keys.custom
        }
        let mString = self
        var resultString = ""
        for c in mString {
            let startIndex = keys.startIndex
            if let idx = keys.index(of: c) {
                let pos = keys.distance(from: startIndex, to: idx)
                resultString.append(String.decToBin(pos))
            } else {
                resultString.append("000000")
            }
        }
        
        while resultString[resultString.index(resultString.endIndex, offsetBy: -8)..<resultString.endIndex] == "00000000" {
            resultString = String(resultString[resultString.startIndex..<resultString.index(resultString.endIndex, offsetBy: -8)])
        }
        
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: resultString.count / 8)
        for i in 0..<resultString.count / 8 {
            let sIndex = resultString.index(startIndex, offsetBy: i * 8)
            let eIndex = resultString.index(sIndex, offsetBy: 8)
            bytes[i] = UInt8(String.binTodec(number: String(resultString[sIndex..<eIndex])))
        }
        let data = Data(bytes: bytes, count: resultString.count / 8)
        
        bytes.deinitialize(count: resultString.count / 8)
        bytes.deallocate()
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
        }
        return self
    }
    
    fileprivate static func decToBin(_ number:Int,bit:Int = 6) -> String {
        var str = String(number,radix:2)
        let dt = bit - str.count
        if dt > 0 {
            for _ in 0..<dt {
                str = "0" + str
            }
        }
        return str
    }
    
    fileprivate static func binTodec(number num: String) -> Int {
        var sum: Int = 0
        for c in num.enumerated() {
            sum = sum * 2 + Int(String(c.element))!
        }
        return sum
    }
}

