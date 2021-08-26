//
//  HImagePickerUtils.swift
//  YDHYK
//
//  Created by screson on 2017/11/10.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import MobileCoreServices
import Photos

enum HStatus{
    case success, canceled, cameraDisable, photoLibDisable, notImage
    case notDetermined
    case restricted
    case denied
    case authorized
    
    func description() -> String {
        switch self {
        case .success:
            return "成功"
        case .canceled:
            return "取消选择"
        case .cameraDisable:
            return "该设备不支持拍照"
        case .photoLibDisable:
            return "该设备不支持资源选择"
        case .notImage:
            return "获取的不是图片"
        case .notDetermined:
            return "未作出授权选择"
        case .restricted:
            return "该功能被禁用"
        case .denied:
            return "阻止了相册/相机访问权限"
        case .authorized:
            return "已授权"
        }
    }
}

enum HChooseType{
    case takePhoto, choosePhoto
    func description() -> String {
        switch self {
        case .takePhoto:
            return "相机"
        case .choosePhoto:
            return "相册"
        }
    }
}

typealias HCompletion = (UIImage?,HStatus) -> Void

/// HImagePickerUtils
class HImagePickerUtils: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private var pickPhotoEnd: HCompletion?
    
    func takePhoto(presentFrom rootVC:UIViewController,completion:HCompletion?) {
        self.pickPhotoEnd = completion
        if HImagePickerUtils.isCameraAvailable() && HImagePickerUtils.doesCameraSupportTakingPhotos(){
            HImagePickerUtils.cameraAuthorized { (authorized, status) in
                if authorized || status == .notDetermined {
                    let controller = UIImagePickerController()
                    controller.view.backgroundColor = UIColor.white
                    controller.sourceType = UIImagePickerController.SourceType.camera
                    controller.mediaTypes = [kUTTypeImage as String]
                    controller.allowsEditing = false
                    controller.delegate = self
                    
                    if #available(iOS 8.0, *) {
                        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    }
                    rootVC.present(controller, animated: true, completion: nil)
                }else {
                    self.pickPhotoEnd?(nil,status)
                }
            }
        }else{
            self.pickPhotoEnd?(nil,HStatus.cameraDisable)
        }
    }
    
    func choosePhoto(presentFrom rootVC:UIViewController,completion:HCompletion?){
        self.pickPhotoEnd = completion
        if HImagePickerUtils.isPhotoLibraryAvailable(){
            HImagePickerUtils.photoAuthorized({ (authorized, status) in
                if authorized || status == .notDetermined {
                    let controller = UIImagePickerController()
                    controller.view.backgroundColor = UIColor.white
                    controller.sourceType = UIImagePickerController.SourceType.photoLibrary
                    var mediaTypes = [String]()
                    if HImagePickerUtils.canUserPickPhotosFromPhotoLibrary(){
                        mediaTypes.append(kUTTypeImage as String)
                    }
                    controller.allowsEditing = false
                    controller.mediaTypes = mediaTypes
                    if #available(iOS 8.0, *) {
                        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    }
                    controller.delegate = self
                    rootVC.present(controller, animated: true, completion: nil)
                }else {
                    self.pickPhotoEnd?(nil,status)
                }
            })
        }else{
            self.pickPhotoEnd?(nil,HStatus.photoLibDisable)
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            var theImage : UIImage!
            if picker.allowsEditing{
                theImage = (info[UIImagePickerController.InfoKey.editedImage] as! UIImage)
            }else{
                theImage = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
                theImage = theImage.fixOrientation()
            }
            self.pickPhotoEnd?(theImage,HStatus.success)
        }else{
            self.pickPhotoEnd?(nil,HStatus.notImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.pickPhotoEnd?(nil,HStatus.canceled)
        }
    }
    
    //MARK: 用户是否授权
    static func cameraAuthorized(_ completion:((Bool,HStatus) -> Void)?){
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            completion?(true,.authorized)
        case .notDetermined:
            completion?(false,.notDetermined)
        case .restricted:
            completion?(false,.restricted)
        case .denied:
            completion?(false,.denied)
        default:
            break
        }
    }
    
    static func photoAuthorized(_ completion:((Bool,HStatus) -> Void)?){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion?(true,.authorized)
        case .notDetermined:
            completion?(false,.notDetermined)
        case .restricted:
            completion?(false,.restricted)
        case .denied:
            completion?(false,.denied)
        default:
            break
        }
    }
    
    //MARK: 相机功能是否可用
    static func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    }
    
    //MARK: 前置摄像头是否可用
    static func isFrontCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front)
    }
    
    //MARK: 后置摄像头是否可用
    static func isRearCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear)
    }
    
    //MARK: 判断是否支持某种多媒体类型：拍照，视频
    static func cameraSupportsMedia(paramMediaType:NSString, sourceType:UIImagePickerController.SourceType) -> Bool {
        var result = false
        if paramMediaType.length == 0 {
            return false
        }
        let availableMediaTypes = NSArray(array: UIImagePickerController.availableMediaTypes(for: sourceType)!)
        availableMediaTypes.enumerateObjects({ (obj : Any, idx: Int, stop:UnsafeMutablePointer<ObjCBool>) in
            let type = obj as! NSString
            if type.isEqual(to: paramMediaType as String) {
                result = true
                stop[0] = true
            }
            
            
        })
        return result
    }
    
    //MARK: 检查摄像头是否支持录像
    static func doesCameraSupportShootingVides() -> Bool{
        return self.cameraSupportsMedia(paramMediaType: kUTTypeMovie, sourceType: UIImagePickerController.SourceType.camera)
    }
    //MARK: 检查摄像头是否支持拍照
    static func doesCameraSupportTakingPhotos() -> Bool{
        return self.cameraSupportsMedia(paramMediaType: kUTTypeImage, sourceType: UIImagePickerController.SourceType.camera)
    }
    
    //MARK: 相册是否可用
    static func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
    }
    
    //MARK: 是否可在相册中选择视频
    static func canUserPickVideosFromPhotoLibrary() -> Bool {
        return self.cameraSupportsMedia(paramMediaType: kUTTypeMovie, sourceType: UIImagePickerController.SourceType.photoLibrary)
    }
    
    //MARK: 是否可在相册中选择图片
    static func canUserPickPhotosFromPhotoLibrary() -> Bool {
        return self.cameraSupportsMedia(paramMediaType: kUTTypeImage, sourceType: UIImagePickerController.SourceType.photoLibrary)
    }
    
    static func showTips(at rootVC:UIViewController!,type:HChooseType) {
        if #available(iOS 8.0, *) {
            let alertVC = UIAlertController(title: nil, message: "您阻止了\(type.description())访问权限", preferredStyle: UIAlertController.Style.alert)
            let openIt = UIAlertAction(title: "马上打开", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction) -> Void in
                if let url = URL(string: UIApplication.openSettingsURLString){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(url)
                    }
                }
                
            })
            alertVC.addAction(openIt)
            rootVC.present(alertVC, animated: true, completion: nil)
        }else{
            let alertVC = UIAlertController(title: "提示", message: "请在 '系统设置|隐私|\(type.description())' 中开启相机访问权限", preferredStyle: UIAlertController.Style.alert)
            rootVC.present(alertVC, animated: true, completion: nil)
        }
    }
}

