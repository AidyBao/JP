//
//  UIImage+ZX.swift
//  rbstore
//
//  Created by screson on 2017/7/26.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import Kingfisher

internal func radians(_ degrees: CGFloat) -> CGFloat {
    return degrees / 180 * .pi
}

extension UIImage {
    
    static func zx_clearMemoryCache() {
        let cache = KingfisherManager.shared.cache
        cache.clearMemoryCache()
        
        URLCache.shared.removeAllCachedResponses()
    }
    
    static func zx_clearDiskCache(completion: (() -> Void)? ) {
        let cache = KingfisherManager.shared.cache
        cache.cleanExpiredDiskCache()
        cache.clearDiskCache {
            completion?()
        }
    }
    
    static func zx_base64StrToQRImage(base64Str: String) -> UIImage? {
        var image: UIImage?
        if !base64Str.isEmpty {
            if let base64Data = Data(base64Encoded: base64Str, options: Data.Base64DecodingOptions(rawValue: 0)){
                image = UIImage(data: base64Data)
            }
        }
        return image
    }
    
    static func zx_QRCodeImage(qrCodeStr: String) -> UIImage? {
        if !qrCodeStr.isEmpty {
            // 创建二维码滤镜
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            // 恢复滤镜默认设置
            filter?.setDefaults()
            
            // 设置滤镜输入数据
            let data = qrCodeStr.data(using: String.Encoding.utf8)
            filter?.setValue(data, forKey: "inputMessage")
            
            // 设置二维码的纠错率
            filter?.setValue("M", forKey: "inputCorrectionLevel")
            
            // 从二维码滤镜里面, 获取结果图片
            var image = filter?.outputImage
            
            // 生成一个高清图片
            let transform = CGAffineTransform.init(scaleX: 20, y: 20)
            image = image?.transformed(by: transform)
                    
            // 图片处理
            let resultImage = UIImage(ciImage: image!)
            return resultImage

        }
        return nil
    }
    
    
    ///View转Image
    static func zx_getViewScreenshot(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }

    struct Default {
        static let empty    = #imageLiteral(resourceName: "zx_empty_default")     //
    }
    
    func crop(rect: CGRect) -> UIImage {
        
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: radians(90)).translatedBy(x: 0, y: -size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: radians(-90)).translatedBy(x: -size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: radians(-180)).translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = CGAffineTransform.identity
        }
        
        rectTransform = rectTransform.scaledBy(x: scale, y: scale)
        if let cropped = cgImage?.cropping(to: rect.applying(rectTransform)) {
            return UIImage(cgImage: cropped, scale: scale, orientation: imageOrientation).fixOrientation()
        }
        
        return self
    }
    
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    //MARK: - 将颜色转换为图片
    static func zx_getImageWithColor(color:UIColor)->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
