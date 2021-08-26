//
//  ZXHScreenShotTool.swift
//  ShareScreenShot
//
//  Created by screson on 2019/3/1.
//  Copyright © 2019 screson. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ZXHScreenShotTool {
    static var noticeOn = true
    static let share = ZXHScreenShotTool()
    static let ZXHSpecialPageScreenShotNotice   =   "ZXHSpecialPageScreenShotNotice"
    private init() {
    }
    
    fileprivate var shotView: UIView?
    fileprivate var timer: Timer?
    fileprivate var timeNum = 4
    fileprivate var image: UIImage?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        NotificationCenter.default.addObserver(self, selector: #selector(userGlobalDidTakeScreenshot(_:)), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userSpecialPageDidTakeScreenshot(_:)), name: ZXHScreenShotTool.ZXHSpecialPageScreenShotNotice.zx_noticeName(), object: nil)
    }
    
    @objc func userSpecialPageDidTakeScreenshot(_ notification: Notification) {
        if UIApplication.shared.statusBarOrientation == .landscapeLeft ||
            UIApplication.shared.statusBarOrientation == .landscapeRight {
            return
        }
        clear()
        guard let image = notification.object as? UIImage else {
            return
        }
        
        self.image = image
        let window = UIApplication.shared.windows[0]
        
        shotView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width - 120, y: 110, width: 110, height: 160))
        shotView?.backgroundColor = UIColor.black
        shotView?.layer.cornerRadius = 5
        let imgPhoto = UIImageView(image: image)
        imgPhoto.contentMode = .scaleAspectFit
        imgPhoto.frame = CGRect(x: 5, y: 5, width: 100, height: shotView!.frame.size.height - 35)
        shotView?.addSubview(imgPhoto)
        
        let label = UILabel(frame: CGRect(x: 0, y: shotView!.frame.size.height - 35, width: shotView!.frame.size.width, height: 35))
        label.text = "分享截图"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        shotView?.addSubview(label)
        
        window.addSubview(shotView!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        shotView?.addGestureRecognizer(tap)
        
        timeNum = 4
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self](timer) in
            if let strongSelf = self {
                if strongSelf.timeNum <= 0 {
                    strongSelf.timer?.invalidate()
                    strongSelf.timer = nil
                    strongSelf.shotView?.removeFromSuperview()
                }
                strongSelf.timeNum -= 1
            }
        })
        RunLoop.main.add(timer!, forMode: .default)
    }

    
    @objc func userGlobalDidTakeScreenshot(_ notification: Notification) {
        if !ZXHScreenShotTool.noticeOn {
            return
        }
        if UIApplication.shared.statusBarOrientation == .landscapeLeft ||
            UIApplication.shared.statusBarOrientation == .landscapeRight {
            return
        }
        clear()
        guard let image = ZXHScreenShotTool.imageWithScreenshot() else {
            return
        }
        
        self.image = image
        let window = UIApplication.shared.windows[0]
        
        shotView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width - 120, y: 110, width: 110, height: 160))
        shotView?.backgroundColor = UIColor.black
        shotView?.layer.cornerRadius = 5
        let imgPhoto = UIImageView(image: image)
        imgPhoto.contentMode = .scaleAspectFit
        imgPhoto.frame = CGRect(x: 5, y: 5, width: 100, height: shotView!.frame.size.height - 35)
        shotView?.addSubview(imgPhoto)
        
        let label = UILabel(frame: CGRect(x: 0, y: shotView!.frame.size.height - 35, width: shotView!.frame.size.width, height: 35))
        label.text = "分享截图"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        shotView?.addSubview(label)
        
        window.addSubview(shotView!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        shotView?.addGestureRecognizer(tap)
        
        timeNum = 4
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self](timer) in
            if let strongSelf = self {
                if strongSelf.timeNum <= 0 {
                    strongSelf.timer?.invalidate()
                    strongSelf.timer = nil
                    strongSelf.shotView?.removeFromSuperview()
                }
                strongSelf.timeNum -= 1
            }
        })
        RunLoop.main.add(timer!, forMode: .default)
    }
    
    @objc fileprivate func tapAction() {
        if let image = image {
            
        }
        clear()
    }
    
    static func imageWithScreenshot() -> UIImage? {
        guard let data = dataWithScreenshotInPNGFormat() else {
            return nil
        }
        return UIImage(data: data)
    }
    
    static func dataWithScreenshotInPNGFormat() -> Data? {
        var imageSize = CGSize.zero
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation.isPortrait {
            imageSize = UIScreen.main.bounds.size
        } else {
            imageSize = CGSize(width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
        }
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        for window in UIApplication.shared.windows {
            context.saveGState()
            context.translateBy(x: window.center.x, y: window.center.y)
            context.concatenate(window.transform)
            context.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
            if orientation == .landscapeLeft {
                context.rotate(by: CGFloat.pi / 2)
                context.translateBy(x: 0, y: -imageSize.width)
            } else if orientation == .landscapeRight {
                context.rotate(by: -CGFloat.pi / 2)
                context.translateBy(x: -imageSize.height, y: 0)
            } else if orientation == .portraitUpsideDown {
                context.rotate(by: CGFloat.pi)
                context.translateBy(x: -imageSize.width, y: -imageSize.height)
            }
            
            if window.responds(to: #selector(window.drawHierarchy(in:afterScreenUpdates:))) {
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            } else {
                window.layer.render(in: context)
            }
            context.restoreGState()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.pngData()
    }
    
    fileprivate func clear() {
        self.timer?.invalidate()
        self.timer = nil
        self.shotView?.removeFromSuperview()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        clear()
    }
    
    static func dataWithScreenshotInPNGFormat(view: UIView) -> Data? {
        var imageSize = CGSize.zero
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation.isPortrait {
            imageSize = UIScreen.main.bounds.size
        } else {
            imageSize = CGSize(width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
        }
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.saveGState()
        context.translateBy(x: view.center.x, y: view.center.y)
        context.concatenate(view.transform)
        context.translateBy(x: -view.bounds.size.width * view.layer.anchorPoint.x, y: -view.bounds.size.height * view.layer.anchorPoint.y)
        if orientation == .landscapeLeft {
            context.rotate(by: CGFloat.pi / 2)
            context.translateBy(x: 0, y: -imageSize.width)
        } else if orientation == .landscapeRight {
            context.rotate(by: -CGFloat.pi / 2)
            context.translateBy(x: -imageSize.height, y: 0)
        } else if orientation == .portraitUpsideDown {
            context.rotate(by: CGFloat.pi)
            context.translateBy(x: -imageSize.width, y: -imageSize.height)
        }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        context.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.pngData()
    }
    
    static func zx_lastAsset(zxSuccess:((_ image: UIImage) -> Void)?) {
        let options = PHFetchOptions()
        let assetsFetchResults = PHAsset.fetchAssets(with: options)
        if assetsFetchResults.count > 0 {
            if let phasset = assetsFetchResults.lastObject {
                let imageManager = PHCachingImageManager()
                imageManager.requestImage(for: phasset, targetSize: UIScreen.main.bounds.size, contentMode: .aspectFill, options: nil) { (rImage, info) in
                    if let rImg = rImage {
                        zxSuccess?(rImg)
                    }
                }
            }
        }
    }
}
