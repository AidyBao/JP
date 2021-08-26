//
//  JXVideoDescriptionViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/24.
//

import UIKit
import AliyunOSSiOS
import IQKeyboardManagerSwift


class JXVideoDescriptionViewController: ZXUIViewController {
    
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var zxTextView: ZXTextView!
    @IBOutlet weak var releaseBtn: UIButton!

    fileprivate var videoInfo: JXAlbumVideo!
    fileprivate var OSSToken: JXOSSToken?
    
    
    var mClient: OSSClient!
    
    static func show(superV: UIViewController, videoInfo: JXAlbumVideo) {
        let vc = JXVideoDescriptionViewController()
        vc.videoInfo = videoInfo
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        title = "填写信息"
        
        //
        self.zxTextView.backgroundColor = UIColor.white
        self.zxTextView.placeText = "添加标题(小于32个字)"
        self.zxTextView.delegate = self
        self.zxTextView.limitTextNum = 32
        
        //
        self.coverImg.layer.cornerRadius = 5
        self.coverImg.layer.masksToBounds = true
        
        //
        self.releaseBtn.backgroundColor = UIColor.zx_tintColor
        self.releaseBtn.setTitleColor(UIColor.blue, for: .normal)
        self.releaseBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.releaseBtn.layer.cornerRadius = self.releaseBtn.frame.height * 0.5
        self.releaseBtn.layer.masksToBounds = true
        self.releaseBtn.layer.borderWidth = 1.0
        self.releaseBtn.layer.borderColor = UIColor.zx_tintColor.cgColor
        self.releaseBtn.setTitle("发布", for: .normal)
        
        //
        if let ass = videoInfo.asset {
            FileManager.ZXVideo.getCoverImage(asset: ass) { result in
                if let reImg = result {
                    self.coverImg.image = reImg
                }
            }
        }

        self.jx_geOssToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    func addOSS() {
        OSSLog.isLogEnable()
        if let mod = self.OSSToken {
            let mProvider = OSSStsTokenCredentialProvider(accessKeyId: mod.accessKeyId, secretKeyId: mod.accessKeySecret, securityToken: mod.securityToken)
            mClient = OSSClient.init(endpoint: "https://\(mod.endpoint)", credentialProvider: mProvider)
        }
    }
    
    
    @IBAction func releaseAction(_ sender: Any) {
        if let info = videoInfo {
            if let text = self.zxTextView.textView.text, !text.isEmpty {
                if let asset = info.avURLAsset {
                    ZXHUD.showLoading(in: ZXRootController.appWindow()!, text: "上传中...,请勿退出程序", delay: 0)
                    FileManager.ZXVideo.startExportVideoWithVideoAsset(videoAsset: asset) { tempPath  in
                        if !tempPath.isEmpty {
                            if let oss = self.OSSToken {
                                self.uploadFile(oss: oss, path: tempPath)
                            }else{
                                ZXHUD.hide(for: ZXRootController.appWindow()!, animated: true)
                                ZXHUD.showFailure(in: self.view, text: "认证失败，返回页面重试", delay: ZXHUD.DelayOne)
                            }
                        }else{
                            ZXHUD.hide(for: ZXRootController.appWindow()!, animated: true)
                            ZXHUD.showFailure(in: self.view, text: "视频导出失败，请重新选择", delay: ZXHUD.DelayOne)
                        }
                    }
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: "请添加视频标题", delay: ZXHUD.DelayOne)
            }
        }else{
            ZXHUD.showFailure(in: self.view, text: "暂无视频信息", delay: ZXHUD.DelayOne)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func jx_geOssToken() {
        ZXHUD.showLoading(in: ZXRootController.appWindow()!, text: "...", delay: 0)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Video.getOssToken), params: ["format":".mp4"], method: .get, detectHeader: true) { succ, code, content, contentstr, msg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: ZXRootController.appWindow()!, animated: true)
            if succ {
                if let data = content["data"] as? Dictionary<String, Any> {
                    let model = JXOSSToken.deserialize(from: data)
                    self.OSSToken = model
                    
                    self.addOSS()
                }else{
                    ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: msg?.description ?? "", delay: ZXHUD.DelayOne)
                }
            }else{
                ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: msg?.description ?? "", delay: ZXHUD.DelayOne)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
    func uploadFile(oss: JXOSSToken, path: String) {
        let request = OSSPutObjectRequest()
        request.bucketName = oss.bucket
        request.objectKey = oss.path
        request.uploadingFileURL = URL(fileURLWithPath:path)
        request.uploadProgress = {(bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) -> Void in
            
        }
        DispatchQueue.global().async {
            let task = self.mClient.putObject(request)
            task.continue({ (t) -> OSSTask<AnyObject>? in
                DispatchQueue.main.async {
                    self.showResult(task: t, path: path)
                }
                return nil
            })
            task.waitUntilFinished()
        }
    }
    
    func showResult(task: OSSTask<AnyObject>?, path: String) -> Void {
        if (task?.error != nil) {
            /*
            let error: NSError = (task?.error)! as NSError
            ZXAlertUtils.showAlert(withTitle: "error", message: error.description)*/
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: ZXRootController.appWindow()!, animated: true)
            ZXHUD.showFailure(in: self.view, text: "视频上传失败", delay: ZXHUD.DelayOne)
        }else{
            /*
            let result = task?.result
            ZXAlertUtils.showAlert(withTitle: "notice", message: result?.description)*/
            
            self.jx_videoSave(path: path)
        }
    }
    
    func jx_videoSave(path: String) {
        var dic: Dictionary<String,Any> = [:]
        if let mod = OSSToken {
            if !mod.path.isEmpty {
                dic["path"] = mod.path
            }
        }
        if let text = self.zxTextView.textView.text, !text.isEmpty {
            dic["title"] = text
        }
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Video.saveMyVideo), params: dic, method: .post, detectHeader: true) { succ, code, dict, jsonStr, zxError in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: ZXRootController.appWindow()!, animated: true)
            if succ {
                ZXHUD.showSuccess(in: ZXRootController.appWindow()!, text: "视频上传成功", delay: ZXHUD.DelayOne)
                if FileManager.default.fileExists(atPath: path) {
                    try? FileManager.default.removeItem(atPath: path)
                }
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: zxError?.description ?? "", delay: ZX.HUDDelay)
            }
        }
    }
}

//MARK: - ZXTextViewDelegate
extension JXVideoDescriptionViewController:ZXTextViewDelegate {
    func getTextNum(textNum: Int) {
        
    }
}


/*
extension JXVideoDescriptionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.desTF {
            if let inputMode = textField.textInputMode, let language = inputMode.primaryLanguage, language.hasPrefix("zh") {
                if let newrange = textField.markedTextRange {
                    let start = textField.offset(from: textField.beginningOfDocument, to: newrange.start)
                    if start > 32 {
                        ZXHUD.showFailure(in: self.view, text: "昵称不能大于32位！", delay: ZX.HUDDelay)
                        return false
                    }
                }else{
                    if let text = textField.text {
                        if text.count + string.count - range.length > 32 {
                            ZXHUD.showFailure(in: self.view, text: "昵称不能大于32位！", delay: ZX.HUDDelay)
                            return false
                        }
                    }
                }
            }else{
                if let text = textField.text {
                    if text.count + string.count - range.length > 32 {
                        ZXHUD.showFailure(in: self.view, text: "昵称不能大于32位！", delay: ZX.HUDDelay)
                        return false
                    }
                }
            }
        }
        return true
    }
}*/
