//
//  JXPersonalViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/2.
//

import UIKit

struct JXPersonalBtnTag {
    static let NameTag  = 52001
    static let TelTag   = 52002
    static let PassTag  = 52003
    static let ZFBTag   = 52005
    static let JYPassTag = 52006
}

class JXPersonalViewController: ZXUIViewController {
    
    override var zx_preferredNavgitaionBarHidden: Bool {
        return true
    }
    @IBOutlet weak var modifyBtn: UIButton!
    
    @IBOutlet weak var bigcontentview: UIView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var bgimgv: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var iconImg: ZXUIImageView!
    @IBOutlet weak var sexImg: UIImageView!
    @IBOutlet weak var levelImg: UIImageView!
    @IBOutlet weak var nikenameLb: UILabel!
    @IBOutlet weak var idLb: UILabel!
    @IBOutlet weak var personalLb: UILabel!
    @IBOutlet weak var nameT: UILabel!
    @IBOutlet weak var nameV: UILabel!
    @IBOutlet weak var telT: UILabel!
    @IBOutlet weak var telV: UILabel!
    @IBOutlet weak var passT: UILabel!
    @IBOutlet weak var passV: UILabel!
    
    @IBOutlet weak var zfbView: ZXUIView!
    @IBOutlet weak var zfbT: UILabel!
    @IBOutlet weak var zfbV: UILabel!
    @IBOutlet weak var jyView: ZXUIView!
    @IBOutlet weak var jypassT: UILabel!
    @IBOutlet weak var jypassV: UILabel!
    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var verView: ZXUIView!
    @IBOutlet weak var verT: UILabel!
    @IBOutlet weak var verV: UILabel!
    @IBOutlet weak var timeT: UILabel!
    @IBOutlet weak var timeV: UILabel!
    @IBOutlet weak var navH: NSLayoutConstraint!
    @IBOutlet weak var infoViewH: NSLayoutConstraint!
    
    fileprivate var timer:Timer?   = nil
    
    var memberModel: ZXUserModel?  = nil
    fileprivate var downCount:Int64 = 0
    
    @IBOutlet weak var frozenLB: UILabel!
    static func show(superV: UIViewController){
        let vc = JXPersonalViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var logoutBtn: ZXUIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if UIDevice.zx_isX() {
            navH.constant = 44
        }else{
            navH.constant = 20
        }

        self.setUI()
        
        addRefresh()
        
        self.jx_requestForUserInfo()
    }
    
    private func addRefresh() ->Void{
        self.scrollView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.scrollView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForHeader))
    }
    
    @objc private func refreshForHeader() -> Void{
        self.scrollView.mj_footer?.resetNoMoreData()
        self.jx_requestForUserInfo()

    }
    
    @IBAction func headerImgAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.choosePhotos()
        }
    }
    
    
    @IBAction func cameback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func logout(_ sender: Any) {
        ZXAlertUtils.showAlert(wihtTitle: "提示", message: "确认退出登录？", buttonTexts: ["取消","确定"] , action: { (index) in
            if index == 1 {
                DispatchQueue.main.async(execute: {
                    ZXUser.user.logout()
                    //3.清空tabBar
                    ZXRootController.reload()
                    //4.跳转
                    ZXRouter.changeRootViewController(ZXRootController.zx_tabbarVC())
                })
            }
        })
    }
    
    @IBAction func personalAction(_ sender: UIButton) {
        switch sender.tag {
        case JXPersonalBtnTag.NameTag:
            JXCertificationViewController.show(superV: self)
        case JXPersonalBtnTag.TelTag:
            break
        case JXPersonalBtnTag.PassTag:
            JXModifyLoginPassWordViewController.show(superView: self)
        case JXPersonalBtnTag.ZFBTag:
            JXAlipayAccountViewController.show(superView: self)
        case JXPersonalBtnTag.JYPassTag:
            JXSetringJYPassWordViewController.show(superView: self, callback: {})
        default:
            break
        }
    }
    
    @IBAction func modifyName(_ sender: Any) {
        JXModifyNameViewController.show(superV: self) {
            self.nikenameLb.text = ZXUser.user.nickName
            self.nameV.text = ZXUser.user.nickName
        }
    }
    
    
    @IBAction func verAction(_ sender: Any) {
        JXCertificationViewController.show(superV: self)
    }
    
    
    func loadUI() {
        if let model = self.memberModel {
            self.iconImg.kf.setImage(with: URL(string: model.headUrl))
            if model.nickName.isEmpty {
                self.nikenameLb.text = "未设置昵称"
            }else{
                self.nikenameLb.text = model.nickName
            }
            
            self.idLb.text = model.mobileNo
            if model.sex == 0 {
                self.sexImg.image = UIImage(named: "jx_sex")
            }else{
                self.sexImg.image = UIImage(named: "jx_sex")
            }
            
            switch model.memberLevel {
            case 1:
                self.levelImg.image = UIImage(named: "SJ_Level_1")
            case 2:
                self.levelImg.image = UIImage(named: "SJ_Level_2")
            case 3:
                self.levelImg.image = UIImage(named: "SJ_Level_3")
            case 4:
                self.levelImg.image = UIImage(named: "SJ_Level_4")
            case 5:
                self.levelImg.image = UIImage(named: "SJ_Level_5")
            default:
                break
            }
            
            if model.name.isEmpty {
                self.nameV.text = "未设置"
            }else{
                self.nameV.text = model.name
            }
            
            self.telV.text = model.mobileNo.zx_telSecury()
            self.passV.text = "******"
            
            if !model.alipayNo.isEmpty {
                self.zfbV.text = "\(ZXUser.user.alipayNo)"
            }else{
                self.zfbV.text = "未设置"
            }
            if !model.alipayNo.isEmpty {
                self.jypassV.text = "******"
            }else{
                self.jypassV.text = "未设置"
            }
            
            if model.isFaceAuth == 2 {
                self.verV.text = "已实名认证"
                self.verV.isHidden = false
            }else{
                self.verV.isHidden = true
            }
            
            self.timeV.text = model.createTime.subs(to: 10)
            
            if model.isFrozen {
                self.frozenLB.isHidden = false
                self.downCount = model.frozenRelieveTime/1000
                self.addTimer()
            }
        }
    }


    func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDowNaction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        timer?.fireDate = Date()
    }

    @objc func countDowNaction() {
        downCount -= 1
        if downCount <= 0 {
            downCount = 0
            self.reset()
        } else {
            self.frozenLB.text = "限制交易时间:" + String.zx_time64ToString(time: downCount)
        }
    }

    func reset() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        self.frozenLB.text = ""
    }
    
    func jx_requestForUserInfo() {
        ZXLoginManager.jx_getUserInfo(urlString: ZXAPIConst.User.userInfo) { (succ, code, model, errMs) in
            self.scrollView.mj_header?.endRefreshing()
            self.scrollView.mj_footer?.endRefreshing()
            if succ {
                self.memberModel = model
                self.loadUI()
            }else{
                ZXHUD.showFailure(in: self.view, text: errMs ?? "", delay: ZXHUD.DelayTime)
            }
        } zxFailed: { (code, errMsg) in
            self.scrollView.mj_header?.endRefreshing()
            self.scrollView.mj_footer?.endRefreshing()
            if code != ZXAPI_LOGIN_INVALID {
                ZXHUD.showFailure(in: self.view, text: errMsg, delay: ZXHUD.DelayTime)
            }
        }
    }
    
    func jx_updateHeaderImg(img:UIImage) {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        JXUserManager.jx_uploadImage(image: img) { (succ, content, jsonStr, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
             if succ {
                if let obj = content as? Dictionary<String,Any> {
                    if let data = obj["data"] as? String, !data.isEmpty {
                        self.requestForFilePath(filePath: data)
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: errMsg ?? "上传失败", delay: ZX.HUDDelay)
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: errMsg ?? "上传失败", delay: ZX.HUDDelay)
            }
        }
    }
    
    func requestForFilePath(filePath:String) -> Void {
        ZXLoginManager.jx_commUpdateMemberInfo(url: ZXAPIConst.User.updateMember, headUrl: filePath, name: "") { (succ, code, nil, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                //更新本界面头像
                DispatchQueue.main.async {
                    ZXUser.user.headUrl = filePath
                    self.memberModel?.headUrl = filePath
                    self.loadUI()
                }
                
                ZXHUD.showSuccess(in: self.view, text: "头像更新成功", delay: ZX.HUDDelay)
            }else{
                ZXHUD.showFailure(in: self.view, text: msg ?? "头像更新失败", delay: ZX.HUDDelay)
            }
        }
    }
}


extension JXPersonalViewController {
    func setUI() {
        
        if !ZXToken.token.isLogin {
            zfbView.isHidden = true
            jyView.isHidden = true
            verView.isHidden = true
            infoViewH.constant = 230
        }else{
            zfbView.isHidden = false
            jyView.isHidden = false
            verView.isHidden = false
            infoViewH.constant = 290
        }
        
        self.bigcontentview.backgroundColor = UIColor.zx_lightGray
        self.bgimgv.backgroundColor = UIColor.zx_lightGray
        self.bgview.backgroundColor = UIColor.zx_lightGray
        
        self.titleLb.textColor = UIColor.zx_navBarTitleColor
        self.titleLb.font = UIFont.boldSystemFont(ofSize: ZXNavBarConfig.titleFontSize)
        
        self.modifyBtn.titleLabel?.font = UIFont.zx_supMarkFont
        self.modifyBtn.setTitleColor(UIColor.zx_colorWithHexString("#56A4FD"), for: .normal)
        self.modifyBtn.backgroundColor = UIColor.clear
        self.modifyBtn.layer.cornerRadius = self.modifyBtn.frame.height * 0.5
        self.modifyBtn.layer.masksToBounds = true
        
        self.frozenLB.isHidden = true
        self.frozenLB.textColor = UIColor.red
        self.frozenLB.font = UIFont.zx_supMarkFont
        self.frozenLB.text = ""
        
        self.nikenameLb.textColor = UIColor.zx_textColorBody
        self.nikenameLb.font = UIFont.boldSystemFont(ofSize: 16)
        self.nikenameLb.text = ""
        self.idLb.textColor = UIColor.zx_textColorBody
        self.idLb.font = UIFont.zx_bodyFont
        self.idLb.text = ""
        self.personalLb.textColor = UIColor.zx_textColorTitle
        self.personalLb.font = UIFont.zx_bodyFont
        
        self.nameT.textColor = UIColor.zx_colorWithHexString("#56A4FD")
        self.nameT.font = UIFont.zx_bodyFont(13)
        
        self.telT.textColor = UIColor.zx_colorWithHexString("#56A4FD")
        self.telT.font = UIFont.zx_bodyFont(13)
        
        self.passT.textColor = UIColor.zx_colorWithHexString("#56A4FD")
        self.passT.font = UIFont.zx_bodyFont(13)
      
        self.zfbT.textColor = UIColor.zx_colorWithHexString("#56A4FD")
        self.zfbT.font = UIFont.zx_bodyFont(13)
        
        self.jypassT.textColor = UIColor.zx_colorWithHexString("#56A4FD")
        self.jypassT.font = UIFont.zx_bodyFont(13)
        
        self.nameV.textColor = UIColor.zx_textColorBody
        self.nameV.font = UIFont.zx_bodyFont(13)
        self.nameV.text = ""
        
        self.telV.textColor = UIColor.zx_textColorBody
        self.telV.font = UIFont.zx_bodyFont(13)
        self.telV.text = ""
        
        self.passV.textColor = UIColor.zx_textColorBody
        self.passV.font = UIFont.zx_bodyFont(13)
        self.passV.text = ""
        
        self.zfbV.textColor = UIColor.zx_textColorBody
        self.zfbV.font = UIFont.zx_bodyFont(13)
        self.zfbV.text = ""
        self.jypassV.textColor = UIColor.zx_textColorBody
        self.jypassV.font = UIFont.zx_bodyFont(13)
        self.jypassV.text = ""
        self.verT.textColor = UIColor.zx_textColorBody
        self.verT.font = UIFont.zx_bodyFont
        self.verV.textColor = UIColor.zx_textColorBody
        self.verV.font = UIFont.zx_bodyFont(13)
        self.timeT.textColor = UIColor.zx_textColorBody
        self.timeT.font = UIFont.zx_bodyFont
        self.timeV.textColor = UIColor.zx_tintColor
        self.timeV.font = UIFont.zx_bodyFont
        
    }
}
