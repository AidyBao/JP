//
//  UIImage+Tag.swift
//  AGG
//
//  Created by screson on 2019/4/9.
//  Copyright © 2019 screson. All rights reserved.
//

import Foundation

func *(lhs: CGSize, scale: CGFloat) -> CGSize {
    return CGSize(width: lhs.width * scale, height: lhs.height * scale)
}

func *(lhs: CGPoint, scale: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x * scale, y: lhs.y * scale)
}

extension UIImage {
    
    func addShareTag() -> UIImage {
        var image = self
        image = image.addBGView(at: CGRect(x: 0, y: size.height - 70, width: size.width, height: 70))
        if let logo = UIImage(named: "zx_app_log.png"), let qrCode = UIImage(named: "zx_app_qrcode.png") {
            image = image.addImage(logo, at: CGRect(x: 0, y: size.height - 75, width: 240, height: 75))
            image = image.addImage(qrCode, at: CGRect(x: size.width - 110, y: size.height - 75, width: 110, height: 75))
        }
        /*
        image = image.addText("玩转扑金，红包不停",
                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13 * UIScreen.main.scale, weight: .medium),
                                     NSAttributedString.Key.foregroundColor: UIColor.darkText],
                        at: CGPoint(x: 80, y: size.height - 55))
        image = image.addText("共享广告收益平台",
                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13 * UIScreen.main.scale, weight: .medium),
                                     NSAttributedString.Key.foregroundColor: UIColor.gray],
                        at: CGPoint(x: 80, y: size.height - 35))
         */
        return image
    }
    
    func addBGView(at rect: CGRect,
                   color: UIColor = .white,
                   scale: CGFloat = UIScreen.main.scale) -> UIImage {
        
        let bgView = UIView()
        bgView.bounds = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        bgView.backgroundColor = color
        UIGraphicsBeginImageContextWithOptions(rect.size, true, scale)
        if let context = UIGraphicsGetCurrentContext() {
            bgView.layer.render(in: context)
        }
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        if let bgImage = bgImage {
            UIGraphicsBeginImageContext(self.size)
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            var temp = rect
            if temp.origin.x > (size.width / 2) {
                temp.origin.x = size.width - (size.width - temp.origin.x) * scale
            }
            if temp.origin.y > (size.height / 2) {
                temp.origin.y = size.height - (size.height - temp.origin.y) * scale
            }
            temp.size = temp.size * scale
            
            bgImage.draw(in: temp)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return image
            }
        }
        UIGraphicsEndImageContext()
        return self
    }
    
    func addText(_ text: String,
                 attributes: [NSAttributedString.Key: Any],
                 at position: CGPoint,
                 scale: CGFloat = UIScreen.main.scale) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        var temp = position
        if temp.x > (size.width / 2) {
            temp.x = size.width - (size.width - temp.x) * scale
        } else {
            temp.x = temp.x * scale
        }
        
        if temp.y > (size.height / 2) {
            temp.y = size.height - (size.height - temp.y) * scale
        } else {
            temp.y = temp.y * scale
        }
        
        (text as NSString).draw(at: temp, withAttributes: attributes)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        }
        UIGraphicsEndImageContext()
        return self
    }
    
    func addImage(_ image: UIImage,
                  at rect: CGRect,
                  scale: CGFloat = UIScreen.main.scale) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        var temp = rect
        if temp.origin.x > (size.width / 2) {
            temp.origin.x = size.width - (size.width - temp.origin.x) * scale
        } else {
            temp.origin.x = temp.origin.x * scale
        }
        if temp.origin.y > (size.height / 2) {
            temp.origin.y = size.height - (size.height - temp.origin.y) * scale
        } else {
            temp.origin.y = temp.origin.y * scale
        }
        
        temp.size = temp.size * scale
        
        image.draw(in: temp)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        }
        UIGraphicsEndImageContext()
        return self
    }
}



