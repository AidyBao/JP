//
//  JXAddCallbackViewController+Photo.swift
//  gold
//
//  Created by SJXC on 2021/4/7.
//

import Foundation
import UIKit

extension JXAddCallbackViewController {
    
    //MARK: - 修改头像
    func addImage() -> Void {
        ZXAlertUtils.showActionSheet(withTitle: nil, message: nil, buttonTexts: ["拍照","从手机相册选择"], cancelText: "取消") { (index) in
            switch index {
            case 0://拍照
                self.chooseImageFromCamera()
                break
            case 1://相册
                self.chooseImageFromAlbum()
                break
            default:
                break
            }
        }
    }
    
    //MARK: -手机相册
    func chooseImageFromAlbum() ->Void {
        self.isEditing = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) == false {
            ZXAlertUtils.showAlert(wihtTitle: "提示", message: "相册不可用", buttonText: "知道了", action: nil)
            return
        }
        
        let imgPickerVC = UIImagePickerController.init()
        imgPickerVC.modalPresentationStyle = .fullScreen
        imgPickerVC.sourceType = UIImagePickerController.SourceType.photoLibrary
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    
    //MARK: -拍照
    func chooseImageFromCamera() ->Void {
        self.isEditing = false
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) == false {
            ZXAlertUtils.showAlert(wihtTitle: "提示", message: "相机不可用", buttonText: "知道了", action: nil)
            return
        }
        let imgPickerVC = UIImagePickerController.init()
        imgPickerVC.modalPresentationStyle = .fullScreen
        imgPickerVC.sourceType = UIImagePickerController.SourceType.camera
        imgPickerVC.delegate = self
        self.present(imgPickerVC, animated: true, completion: nil)
    }
}

//MARK: - 图片选择
extension JXAddCallbackViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let portraitImage: UIImage = info[.originalImage] as! UIImage
            let resultImage = UIImage.imageByScalingToMaxSize(sourceImage: portraitImage)
            
            let cropperVC: ZXImageCropperViewController = ZXImageCropperViewController.init(originalImage: resultImage, cropFrame: CGRect.init(x: 0, y: 100, width: ZXBOUNDS_WIDTH, height: ZXBOUNDS_WIDTH), limitScaleRatio: 3.0)
            cropperVC.delegate = self
            self.present(cropperVC, animated: true, completion: nil)
        }
    }
}


extension JXAddCallbackViewController: ZXImageCropperDelegate {
    func imageCropperDidCancel(_ cropperViewController: ZXImageCropperViewController) {
        cropperViewController.dismiss(animated: true, completion: nil)
    }
    
    func imageCropper(_ cropperViewController: ZXImageCropperViewController, didFinished editImg: UIImage) {
        self.jx_uploadImage(img: editImg)
        
        cropperViewController.dismiss(animated: true, completion: nil)
    }
}



