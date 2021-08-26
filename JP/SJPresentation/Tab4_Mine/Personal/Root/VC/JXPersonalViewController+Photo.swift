//
//  JXPersonalViewController+Photo.swift
//  gold
//
//  Created by SJXC on 2021/5/10.
//

import Foundation

//MARK: -
extension JXPersonalViewController {
    
    //MARK: - 修改头像
    func choosePhotos() -> Void {
        ZXAlertUtils.showActionSheet(withTitle: "温馨提示", message: nil, buttonTexts: ["拍照","从手机相册选择"], cancelText: "取消") { (index) in
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
        imgPickerVC.sourceType = UIImagePickerController.SourceType.photoLibrary
        imgPickerVC.delegate = self
        imgPickerVC.modalPresentationStyle = .fullScreen
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
        imgPickerVC.sourceType = UIImagePickerController.SourceType.camera
        imgPickerVC.delegate = self
        imgPickerVC.modalPresentationStyle = .fullScreen
        self.present(imgPickerVC, animated: true, completion: nil)
    }
}

//MARK: - UITableView
extension JXPersonalViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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


extension JXPersonalViewController: ZXImageCropperDelegate {
    func imageCropperDidCancel(_ cropperViewController: ZXImageCropperViewController) {
        cropperViewController.dismiss(animated: true, completion: nil)
    }
    
    func imageCropper(_ cropperViewController: ZXImageCropperViewController, didFinished editImg: UIImage) {
        //2.上传服务器
        self.jx_updateHeaderImg(img: editImg)
        
        cropperViewController.dismiss(animated: true, completion: nil)
    }
}
