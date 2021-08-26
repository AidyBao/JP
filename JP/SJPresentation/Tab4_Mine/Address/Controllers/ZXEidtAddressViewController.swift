//
//  ZXEidtAddressViewController.swift
//  YDHYK
//
//  Created by 120v on 2017/11/9.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

class ZXEidtAddressViewController: ZXUIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var telText: UITextField!
    @IBOutlet weak var addrText: UITextField!
    @IBOutlet weak var detailAddrView: ZXTextView!
    @IBOutlet weak var deftBtn: UIButton!
    @IBOutlet weak var confirmBtn: ZXUIButton!
    @IBOutlet weak var defaultView: UIView!
    
    var zxCompletion: ZXMyAddrCompletion?
    
    var defaultModel:ZXAddrListModel?
    var isNewAdd: Bool              = false
    var addr: String                = ""
    
    var lastProModel = ZXAddressModel()
    var lastCityModel = ZXCityModel()
    var lastCountyModel = ZXCountyModel()
    var isDefault: Int              = 0
    
    var showAsPresent: Bool  = false
    
    class func show(_ superView: UIViewController, _ defaultModel: ZXAddrListModel?, _ isAdd: Bool, _ zxCompletion: ZXMyAddrCompletion?) {
        let eidtVC = ZXEidtAddressViewController()
        eidtVC.zxCompletion = zxCompletion
        eidtVC.defaultModel = defaultModel
        eidtVC.isNewAdd = isAdd
        superView.navigationController?.pushViewController(eidtVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        if self.isNewAdd{
            self.navigationItem.title = "添加新地址"
        }else{
            self.navigationItem.title = "修改地址"
            self.setDefault()
        }
        
        self.setUIStyle()
        
        self.setSaveButtonStyle()
        
        self.zx_addNavBarButtonItems(imageNames: ["zx_navback"], useOriginalColor: false, at:.left)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(zxTextFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
    
    override func zx_leftBarButtonAction(index: Int) {
        if self.confirmBtn.isEnabled {
            ZXAlertUtils.showAlert(wihtTitle: nil, message: "是否保存修改内容", buttonTexts: ["不保存","保存"]) { (index) in
                if index == 1 {
                    self.addAndModifyAddress(self.isNewAdd)
                }else{
                    if self.showAsPresent {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
        }else{
            if self.showAsPresent {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setUIStyle() {
        
        defaultView.clipsToBounds = true
        deftBtn.isHidden = true
        
        self.nameText.textColor = UIColor.zx_textColorBody
        self.telText.textColor = UIColor.zx_textColorBody
        self.addrText.textColor = UIColor.zx_textColorBody
        self.addrText.minimumFontSize = 8.0
        
        self.deftBtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.confirmBtn.setTitleColor(UIColor.white, for: .normal)
        self.confirmBtn.titleLabel?.font = UIFont.zx_subTitleFont
        self.confirmBtn.backgroundColor = UIColor.zx_subTintColor
        
        self.detailAddrView.placeText = "详细地址"
        self.detailAddrView.delegate = self
        self.detailAddrView.limitTextNum = 64
    }
    
    func setDefault() {
        if let adModel = self.defaultModel {
            self.nameText.text = adModel.username
            
            self.telText.text = adModel.phone
            
            self.addrText.text = "\(adModel.provinceName) \(adModel.cityName) \(adModel.areaName)"
            self.addr = self.addrText.text!
            
            self.detailAddrView.textView.text = adModel.address
            
            if adModel.isDefault == 1 {
                self.deftBtn.isSelected = true
                self.isDefault = 1
            }else{
                self.deftBtn.isSelected = false
                self.isDefault = 0
            }
            
            self.lastProModel.provinceId = adModel.provinceId
            self.lastProModel.name = adModel.provinceName
            
            self.lastCityModel.cityId = adModel.cityId
            self.lastCityModel.name = adModel.cityName
            
            self.lastCountyModel.countyId = adModel.areaId
            self.lastCountyModel.name = adModel.areaName
        }
    }
    
    //MARK: - saveButtonClick
    @objc func saveButAction(_ sender:UIButton) -> Void {
        if self.isNewAdd {
            self.addAndModifyAddress(true)
        }else{
            self.addAndModifyAddress(false)
        }
    }
    
    
    @IBAction func selectedAddAction(_ sender: UIButton) {
        self.view.endEditing(true)
        DispatchQueue.main.async {
            ZXAddressViewController.show(self, self.lastProModel, self.lastCityModel, self.lastCountyModel) { (proModel, cityModel, countyModel) in
                self.lastProModel = proModel
                self.lastCityModel = cityModel
                self.lastCountyModel = countyModel
                
                self.addrText.text = "\(proModel.name) \(cityModel.name) \(countyModel.name)"
                self.addr = "\(proModel.name) \(cityModel.name) \(countyModel.name)"
                
                self.setSaveButtonStyle()
            }
        }
    }
    
    @IBAction func setDefaultAddrAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.isDefault = 1
        }else{
            self.isDefault = 0
        }
        self.setSaveButtonStyle()
    }
    
    @IBAction func comfirmBtnAction(_ sender: UIButton) {
        if (self.telText.text?.zx_mobileValid())! {
            self.addAndModifyAddress(isNewAdd)
        }else{
            ZXHUD.showText(in: self.view, text: "请输入正确的手机号", delay: ZXHUD.DelayTime)
        }
    }
}


//MARK: - ZXTextViewDelegate
extension ZXEidtAddressViewController:ZXTextViewDelegate {
    func getTextNum(textNum: Int) {
        self.setSaveButtonStyle()
    }
}

// MARK: -
extension ZXEidtAddressViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.nameText {
            if range.location + string.count > 16 {
                ZXHUD.showFailure(in: self.view, text: "姓名不能超过16个字", delay: ZX.HUDDelay)
                return false
            }
            
            if  (textField.textInputMode?.primaryLanguage!.isEqual("emoji")) == true || ((textField.textInputMode?.primaryLanguage) == nil){
                return false
            }
        }
        if textField == telText {
            if range.location + string.count > 11 {
                ZXHUD.showFailure(in: self.view, text: "请输入正确的手机号", delay: ZX.HUDDelay)
                return false
            }
        }
        return true
    }
    
    @objc func zxTextFieldDidChange(_ notice: Notification) {
        self.setSaveButtonStyle()
        if let textF = notice.object as? UITextField {
            if textF == self.telText {
                
            }
        }
    }
    
    func setSaveButtonStyle() {
        if self.nameText.text?.count == 0 ||
            self.telText.text?.count == 0 ||
            self.addrText.text?.count == 0 || self.detailAddrView.textView.text.count == 0 {
            self.confirmBtn.isEnabled = false
        }else{
            var defautAddress = ""
            if !self.isNewAdd , let aModel = self.defaultModel {
                defautAddress = "\(aModel.provinceName) \(aModel.cityName) \(aModel.areaName)"
            }
            
            if self.isNewAdd == false,(self.nameText.text?.isEqual(self.defaultModel?.username))!,(self.telText.text?.isEqual(self.defaultModel?.phone))! ,(self.addrText.text?.isEqual(defautAddress))!,(self.detailAddrView.textView.text?.isEqual(self.defaultModel?.address))!,self.isDefault == self.defaultModel?.isDefault {
                self.confirmBtn.isEnabled = false
            }else{
                self.confirmBtn.isEnabled = true
            }
        }
    }
}

//MARK: - HTTP
extension ZXEidtAddressViewController {
    
    //MARK: - 保存
    func addAndModifyAddress(_ isAdd:Bool) {

        ZXHUD.showLoading(in: self.view, text: "", delay: nil)
        ZXAddressViewModels.addAndModifyAddress(url:ZXAPIConst.Shop.edit, keyId:self.defaultModel?.id, name:self.nameText.text!, tel:self.telText.text!, city: self.addrText.text, address:self.detailAddrView.textView.text, isDefault:self.isDefault) { (succ, code, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS {
                    var msg: String = ""
                    if isAdd {
                        msg = "地址添加成功"
                    }else{
                        msg = "地址保存成功"
                    }
                    ZXHUD.showSuccess(in: self.view, text: msg, delay: ZX.HUDDelay)
                    
                    self.zxEidtCallback()
                    
                    if self.showAsPresent {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    if isAdd {
                        ZXHUD.showFailure(in: self.view, text: "添加地址失败", delay: ZX.HUDDelay)
                    }else{
                        ZXHUD.showFailure(in: self.view, text: "保存地址失败", delay: ZX.HUDDelay)
                    }
                }
            }else if code != ZXAPI_LOGIN_INVALID{
                ZXHUD.showFailure(in: self.view, text: errMsg!, delay: ZX.HUDDelay)
            }
        }
    }
    
    //MARK: -回调
    func zxEidtCallback() {
        
        if self.defaultModel == nil {
            self.defaultModel = ZXAddrListModel()
        }
        
        self.defaultModel?.username = self.nameText.text!
        self.defaultModel?.phone = self.telText.text!
        self.defaultModel?.provinceId = self.lastProModel.provinceId
        self.defaultModel?.provinceName = self.lastProModel.name
        self.defaultModel?.cityId = self.lastCityModel.cityId
        self.defaultModel?.cityName = self.lastCityModel.name
        self.defaultModel?.areaId = self.lastCountyModel.countyId
        self.defaultModel?.areaName = self.lastCountyModel.name
        self.defaultModel?.address = self.detailAddrView.textView.text
        self.defaultModel?.isDefault = self.isDefault
        if zxCompletion != nil {
            self.zxCompletion?(self.defaultModel)
        }
    }
    
    //MARK: - 删除
    func deleted() {
        ZXHUD.showLoading(in: self.view, text: "", delay: nil)
        ZXNetwork.asyncRequest(withUrl: ZXAPI.api(address: ZXAPIConst.Shop.delet), params: ["id":(self.defaultModel?.id)!], method: .post) { (succ, code, content, string, errMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if code == ZXAPI_SUCCESS {
                    ZXHUD.showSuccess(in: self.view, text: "删除成功", delay: ZX.HUDDelay)
                    
                    if self.showAsPresent {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: "删除失败", delay: ZX.HUDDelay)
                }
            }else if code != ZXAPI_LOGIN_INVALID{
                ZXHUD.showFailure(in: self.view, text: "删除失败", delay: ZX.HUDDelay)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
