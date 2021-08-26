//
//  ZXUtils.swift
//  YDHYK
//
//  Created by screson on 2017/11/2.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXUtils: NSObject {
    static func jsonString(obj: Any) -> String? {
        if (!JSONSerialization.isValidJSONObject(obj)) {
            return nil
        }
        if let data = try? JSONSerialization.data(withJSONObject: obj, options: []) {
            var jsonString = String(data:data, encoding: String.Encoding.utf8)
            jsonString = jsonString?.replacingOccurrences(of: "\\\"", with: "\\\\\"", options: .regularExpression, range: nil)
            return jsonString
        }
        return nil
    }
}
