//
//  UIImage+Cropper.swift
//  rbstore
//
//  Created by 120v on 2017/8/25.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageByScalingToMaxSize(sourceImage image: UIImage) -> UIImage {
        if image.size.width < ZXBOUNDS_WIDTH {
            return image
        }
        
        var btWidth: CGFloat = 0.0
        var btHeight: CGFloat = 0.0
        if image.size.width > image.size.height {
            btWidth = image.size.width * (ZXBOUNDS_WIDTH / image.size.height)
            btHeight = ZXBOUNDS_WIDTH
        }else{
            btWidth = ZXBOUNDS_WIDTH
            btHeight = image.size.height * (ZXBOUNDS_WIDTH / image.size.width)
        }
        
        let targetSize: CGSize = CGSize.init(width: btWidth, height: btHeight)
        
        return self.imageByScalingAndCroppingForSourceImage(sourceImage: image, targetSize: targetSize)
    }
    
    class func imageByScalingAndCroppingForSourceImage(sourceImage image: UIImage, targetSize size: CGSize) -> UIImage {
        
        var newImage: UIImage = UIImage.init()
        let imageSize: CGSize = image.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = size.width
        let targetHeight: CGFloat = size.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = targetWidth
        var scaledHeight: CGFloat = targetHeight
        var thumbnailPoint: CGPoint = CGPoint.init(x: 0.0, y: 0.0)
        if imageSize.width != size.width || imageSize.height != size.height {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat = targetHeight / height
            
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            }else{
                scaleFactor = heightFactor
            }
            
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight)*0.5
            }else if(widthFactor < heightFactor){
                thumbnailPoint.x = (targetHeight - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(size)
        var thumbnailRect: CGRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        image.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    

}
