//
//  JXAddCallbackViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit
import Kingfisher
import IQKeyboardManagerSwift

typealias JXAddCallback = () -> Void

class JXAddCallbackViewController: ZXUIViewController {
    
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var v4: UIView!
    @IBOutlet weak var v5: UIView!
    @IBOutlet weak var v6: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!
    
    @IBOutlet weak var TV1: UIView!
    @IBOutlet weak var TV2: UIView!
    @IBOutlet weak var TV3: UIView!
    
    @IBOutlet weak var typeCLV: UICollectionView!
    @IBOutlet weak var imageCLV: UICollectionView!
    @IBOutlet weak var bgview: UIView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var telTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var textView: ZXTextView!
    var zxcallbake: JXAddCallback? = nil
    
    var folderChecked = false
    var proDetailStr    = ""
    var nameStr         = ""
    var telStr          = ""
    var idStr           = ""
    var typeModel: JXProblemTypeModel? = nil
    var imageCounts     = 0
    var maxCount        = 3
    
    
    static func show(superV: UIViewController, callback: JXAddCallback?) {
        let vc = JXAddCallbackViewController()
        vc.zxcallbake = callback
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "在线客服"
        self.setUI()
    }

    func textInputCheck() -> Bool {
        if let name = self.nameTF.text {
            if name.isEmpty {
                ZXHUD.showFailure(in: self.view, text: "姓名不能为空", delay: ZX.HUDDelay)
                return false
            }else{
                nameStr = name
            }
        }else{
            return false
        }
        
        if let tel = self.telTF.text {
            if tel.isEmpty {
                ZXHUD.showFailure(in: self.view, text: "手机号不能为空", delay: ZX.HUDDelay)
                return false
            }else{
                telStr = tel
            }
        }else{
            return false
        }
        
        if let ids = self.idTF.text {
            if ids.isEmpty {
                ZXHUD.showFailure(in: self.view, text: "生份证号码不能为空", delay: ZX.HUDDelay)
                return false
            }else{
                idStr = ids
            }
        }else{
            return false
        }
        
        if self.typeModel == nil {
            ZXHUD.showFailure(in: self.view, text: "请选择问题类型", delay: ZX.HUDDelay)
            return false
        }
        
        if let decs = self.textView.textView.text, !decs.isEmpty {
            proDetailStr = decs
        }else{
            ZXHUD.showFailure(in: self.view, text: "请填写文字描述", delay: ZX.HUDDelay)
            return false
        }
        
        if probImgs.count == 0 {
            ZXHUD.showFailure(in: self.view, text: "请上传反馈图片", delay: ZX.HUDDelay)
            return false
        }

        return true
    }

    
    @IBAction func commit(_ sender: UIButton) {
        if !self.textInputCheck() {
            return
        }
        var dicP: Dictionary<String, Any> = [:]
        dicP["memberName"] = self.nameStr
        dicP["phoneNumber"] = self.telStr
        dicP["idCard"] = self.idStr
        if let mod = self.typeModel {
            dicP["problemType"] = mod.problemStatus
        }
        
        dicP["problemDesc"] = self.proDetailStr
        if self.probImgs.count > 0 {
            let imgstr = self.probImgs.joined(separator: ",")
            dicP["imgUrls"] = imgstr
        }
        ZXHUD.showLoading(in: ZXRootController.appWindow()!, text: "正在上传文件...", delay: 0)
        JXCallbackManager.jx_addProblem(dic: dicP) { (succ, code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: ZXRootController.appWindow()!, animated: true)
            if succ {
                ZXAlertUtils.showAlert(wihtTitle: "提交成功", message: "客户将介入处理，请保持手机畅通。", buttonText: "我知道了") {
                    self.zxcallbake?()
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: "上传失败", delay: ZX.HUDDelay)
            }
        }
    }

    
    //Mark: Lazy
    lazy var imagePicker:HImagePickerUtils = {
        let picker = HImagePickerUtils()
        return picker
    }()
    
    lazy var probImgs: Array<String> = {
        return Array()
    }()
    
    lazy var probTypeList: Array<JXProblemTypeModel> = {
        var list:Array<JXProblemTypeModel> = []
        for i in 0..<4 {
            let model = JXProblemTypeModel()
            switch i {
            case 0:
                model.typeTitle = "解冻"
                model.typeDetail = "提供身份证正反面"
                model.problemStatus = 0
                list.append(model)
            case 1:
                model.typeTitle = "解绑"
                model.typeDetail = "提供身份证正反面"
                model.problemStatus = 1
                list.append(model)
            case 2:
                model.typeTitle = "商品售后"
                model.typeDetail = "提供订单号截图"
                model.problemStatus = 2
                list.append(model)
            case 3:
                model.typeTitle = "其他问题"
                model.typeDetail = "根据需要补充相关信息"
                model.problemStatus = 3
                list.append(model)
            default:
                break
            }
        }
        return list
    }()
    
    deinit {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

//MARK: - ZXTextViewDelegate
extension JXAddCallbackViewController:ZXTextViewDelegate {
    func getTextNum(textNum: Int) {
        
    }
}

extension JXAddCallbackViewController {
    //MArk: - 上传服务器
    func jx_uploadImage(img:UIImage) ->Void {
        ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        JXUserManager.jx_uploadImage(image: img) { (succ, content, jsonStr, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if let obj = content as? Dictionary<String,Any> {
                    if let data = obj["data"] as? String, !data.isEmpty {
                        self.probImgs.append(data)
                        self.imageCLV.reloadData()
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: errMsg ?? "上传失败", delay: ZX.HUDDelay)
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: errMsg ?? "上传失败", delay: ZX.HUDDelay)
            }
        }
    }
}

extension JXAddCallbackViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.idTF {
            let cs = CharacterSet.init(charactersIn: "0123456789X").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            if range.location + string.count > 18 {
                ZXHUD.showFailure(in: self.view, text: "请输入正确的身份证号码！", delay: ZX.HUDDelay)
                return false
            }
        }
        
        if textField == self.telTF {
            let cs = CharacterSet.init(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            if range.location + string.count > 11 {
                ZXHUD.showFailure(in: self.view, text: "手机号不能大于11位！", delay: ZX.HUDDelay)
                return false
            }
            let str = textField.text ?? ""
            let str2 = (str as NSString).replacingCharacters(in: range, with: string)
            if str2.count == 1 && str2 != "1" {
                return false
            }
        }
        
        if textField == self.nameTF {
            if range.location + string.count > 32 {
                ZXHUD.showFailure(in: self.view, text: "姓名不能大于32个字符！", delay: ZX.HUDDelay)
                return false
            }
        }
        return true
    }
}

extension JXAddCallbackViewController {
    @objc func tap1() {
        self.view.endEditing(true)
    }
    
    @objc func tap4(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self.v4)

    }
    
    func setUI(){
        
        let gest1 = UITapGestureRecognizer.init(target: self, action: #selector(tap1))
        self.v1.addGestureRecognizer(gest1)
        
        let gest2 = UITapGestureRecognizer.init(target: self, action: #selector(tap1))
        self.v2.addGestureRecognizer(gest2)
        
        let gest3 = UITapGestureRecognizer.init(target: self, action: #selector(tap1))
        self.v3.addGestureRecognizer(gest3)
        
        let gest4 = UITapGestureRecognizer.init(target: self, action: #selector(tap1))
        self.v5.addGestureRecognizer(gest4)
        
        let gest5 = UITapGestureRecognizer.init(target: self, action: #selector(tap1))
        self.v6.addGestureRecognizer(gest5)
        
        
        self.bgview.backgroundColor = UIColor.zx_lightGray
        self.typeCLV.backgroundColor = UIColor.zx_lightGray
        self.imageCLV.backgroundColor = UIColor.zx_lightGray
        
        self.TV1.backgroundColor = UIColor.white
        self.TV1.layer.cornerRadius = 5
        self.TV1.layer.masksToBounds = true
        
        self.TV2.backgroundColor = UIColor.white
        self.TV2.layer.cornerRadius = 5
        self.TV2.layer.masksToBounds = true
        
        self.TV3.backgroundColor = UIColor.white
        self.TV3.layer.cornerRadius = 5
        self.TV3.layer.masksToBounds = true
        
        self.typeCLV.register(UINib(nibName:JXProblemTypeCell.NibName,bundle:nil), forCellWithReuseIdentifier: JXProblemTypeCell.reuseIdentifier)
        self.imageCLV.register(UINib(nibName:JXProblemSelectImgCell.NibName,bundle:nil), forCellWithReuseIdentifier: JXProblemSelectImgCell.reuseIdentifier)
        
        self.commitBtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.commitBtn.titleLabel?.font = UIFont.zx_subTitleFont
        self.commitBtn.backgroundColor = UIColor.zx_tintColor
        self.commitBtn.layer.cornerRadius = 22
        self.commitBtn.layer.masksToBounds = true
        
        self.textView.backgroundColor = UIColor.white
        self.textView.layer.cornerRadius = 10
        self.textView.layer.masksToBounds = true
        self.textView.placeText = "请用文字描述一下您所遇到的问题..."
        self.textView.delegate = self
        self.textView.limitTextNum = 64
        
        self.nameTF.font = UIFont.zx_bodyFont
        self.telTF.font = UIFont.zx_bodyFont
        self.idTF.font = UIFont.zx_bodyFont
        self.lb1.font = UIFont.zx_bodyFont
        self.lb1.textColor = UIColor.zx_textColorTitle
        self.lb2.font = UIFont.zx_bodyFont
        self.lb2.textColor = UIColor.zx_textColorTitle
        self.lb3.font = UIFont.zx_bodyFont
        self.lb3.textColor = UIColor.zx_textColorTitle
        self.lb4.font = UIFont.zx_bodyFont
        self.lb4.textColor = UIColor.zx_textColorTitle
        self.lb5.font = UIFont.zx_bodyFont
        self.lb5.textColor = UIColor.zx_textColorTitle
        self.lb6.font = UIFont.zx_bodyFont
        self.lb6.textColor = UIColor.zx_textColorTitle
        
        
    }
}
