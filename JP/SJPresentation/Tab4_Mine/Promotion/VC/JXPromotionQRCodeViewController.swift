//
//  JXPromotionQRCodeViewController.swift
//  gold
//
//  Created by SJXC on 2021/8/18.
//

import UIKit

class JXPromotionQRCodeViewController: ZXUIViewController {
    
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var statusH: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleview: UIView!
    @IBOutlet weak var qrCodeImgV: UIImageView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var markLB: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    static func show(superV: UIViewController) {
        let vc = JXPromotionQRCodeViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        
        self.view.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
        
        self.bgView.backgroundColor = .white
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
        
        self.titleview.backgroundColor = .zx_tintColor
        self.titleview.layer.cornerRadius = 10
        self.titleview.layer.masksToBounds = true
        
        self.lb1.textColor = UIColor.zx_textColorBody
        self.lb1.font = UIFont.zx_bodyFont
        
        self.markLB.textColor = UIColor.zx_textColorMark
        self.markLB.font = UIFont.zx_markFont
        
        self.saveBtn.setTitleColor(UIColor.white, for: .normal)
        self.saveBtn.titleLabel?.font = UIFont.zx_bodyFont
        
        if let img = UIImage.zx_QRCodeImage(qrCodeStr: ZXAPIConst.Html.registerH5 + "activeCode=\(ZXUser.user.mobileNo)") {
            self.qrCodeImgV.image = img
        }
        
        self.lb1.text = "推广码" + ZXUser.user.mobileNo
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func save(_ sender: Any) {
        if let img = UIImage.zx_getViewScreenshot(view: self.view) {
            HImagePickerUtils.photoAuthorized { (succ, status) in
                if succ || status == .notDetermined {
                    UIImageWriteToSavedPhotosAlbum(img, self, #selector(self.saveError(_:didFinishSavingWithError:contextInfo:)), nil)
                }else{
                    ZXHUD.showFailure(in: self.view, text: "相册授权失败", delay: ZX.HUDDelay)
                }
            }
        }else{
            ZXHUD.showFailure(in: self.view, text: "图片保存失败", delay: ZX.HUDDelay)
        }
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if (error == nil) {
            ZXHUD.showSuccess(in: self.view, text: "图片保存成功", delay: ZX.HUDDelay)
        }else{
            ZXHUD.showFailure(in: self.view, text: "图片保存失败", delay: ZX.HUDDelay)
        }
    }
}
