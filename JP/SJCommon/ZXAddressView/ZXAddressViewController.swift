//
//  ZXAddressViewController.swift
//  rbstore
//
//  Created by 120v on 2017/8/22.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

typealias ZXAddressCompletion = (_ proModel:ZXAddressModel,_ cityModel:ZXCityModel,_ countyModel:ZXCountyModel) -> Void

class ZXAddressViewController: ZXBPushRootViewController {
    
    override var zx_dismissTapOutSideView: UIView? {return contentView}
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleLB: UILabel!
    
    var provinceArray: Array<ZXAddressModel> = [] //省
    var cityArray: Array<ZXCityModel> = []  //市
    var countyArray: Array<ZXCountyModel> = [] //区（县）
    
    var deftProvModel: ZXAddressModel? //默认选中省份
    var deftCityModel: ZXCityModel?     //默认选中市
    var deftCountyModel: ZXCountyModel?  //默认选中区县
    
    var zxCompletion: ZXAddressCompletion?
    var proIndex:NSInteger      = 0//选择省份的索引
    var cityIndex:NSInteger     = 0//选择城市的索引
    var countyIndex:NSInteger    = 0//选择区（县）的索引
    
    
    class func show(_ superView: UIViewController, _ deftProvModel:ZXAddressModel?, _ deftCityModel:ZXCityModel?, _ deftCountyModel:ZXCountyModel?,  _ zxCompeletion:ZXAddressCompletion?) -> Void {
        let addrVC = ZXAddressViewController()
        addrVC.deftProvModel = deftProvModel
        addrVC.deftCityModel = deftCityModel
        addrVC.deftCountyModel = deftCountyModel
        addrVC.zxCompletion = zxCompeletion
        superView.present(addrVC, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.maskView.backgroundColor = UIColor.clear
        
        self.setUI()
        
        self.loadFirstData()
    }

    //MARK: - UI
    func setUI() {
        self.cancelButton.titleLabel?.font = UIFont.zx_bodyFont
        self.cancelButton.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.confirmButton.titleLabel?.font = UIFont.zx_bodyFont
        self.confirmButton.setTitleColor(UIColor.zx_tintColor, for: .normal)
        
        self.titleLB.textColor = UIColor.zx_textColorTitle
        self.titleLB.font = UIFont.zx_bodyFont
        self.titleLB.text = ""
    }
    
    //MARK : - 初始化地址数据
    func loadFirstData() {
//        let list = ZXAddressModel.get()
        
        let list = ZXAddressModel.getJsonData()
        if list.count > 0 {
            self.provinceArray = list
            self.zx_updateData()
        }else{
            ZXHUD.showLoading(in: self.view, text: "", delay: 0)
            /*
            ZXLoginManager.requestForGetArea { (array) in
                ZXHUD.hide(for: self.view, animated: true)
                if array.count > 0 {
                    self.provinceArray = array
                    self.zx_updateData()
                }else{
                    ZXHUD.showFailure(in: self.view, text: "无法获取地址数据", delay: ZXHUD.DelayTime)
                    self.dismiss(animated: true, completion: nil)
                }
            }*/
        }
    }
    
    func zx_updateData() {
        if self.provinceArray.count > 0 {
            
            let provModel = self.provinceArray[self.proIndex]
            self.cityArray = provModel.children
            
            if self.cityArray.count > 0 {
                let cityModel = self.cityArray[self.cityIndex]
                self.countyArray = cityModel.children
            }
            self.pickerView.reloadAllComponents()
            self .setDefaultAddress()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - 默认地址
    func setDefaultAddress() -> Void {
        if (self.deftProvModel != nil),(self.deftCityModel != nil),(self.deftCountyModel != nil) {
            //省
            for (idx0,proModel) in self.provinceArray.enumerated() {
                if proModel.provinceId == self.deftProvModel?.provinceId {
                    self.proIndex = idx0
                    self.pickerView.selectRow(idx0, inComponent: 0, animated: true)
                    
                    //市
                    self.cityArray = proModel.children
                    self.pickerView.reloadComponent(1)
                    if self.cityArray.count > 0 {
                        for (idx1,cityModel) in self.cityArray.enumerated() {
                            if cityModel.cityId == self.deftCityModel?.cityId {
                                self.cityIndex = idx1
                                self.pickerView.selectRow(idx1, inComponent: 1, animated: true)
                                
                                //乡镇
                                self.countyArray = cityModel.children
                                self.pickerView.reloadComponent(2)
                                if self.countyArray.count > 0 {
                                    for (idx2,countyModel) in self.countyArray.enumerated() {
                                        if countyModel.countyId == self.deftCountyModel?.countyId {
                                            self.countyIndex = idx2
                                            self.pickerView.selectRow(idx2, inComponent: 2, animated: true)
                                            break
                                        }
                                    }
                                }
                                break
                            }
                        }
                    }
                    break
                }
            }
        }
    }
    
    //MARK: - 确定
    @IBAction func confirmAction(_ sender: UIButton) {
        if (self.provinceArray.count > 0 && self.cityArray.count > 0 && self.countyArray.count > 0) {
            let proModel = self.provinceArray[self.proIndex]
            let cityModel = self.cityArray[self.cityIndex]
            let countyModel = self.countyArray[self.countyIndex]
            if (zxCompletion != nil) {
                self.zxCompletion?(proModel,cityModel,countyModel)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 取消
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}

//MARK: -
extension ZXAddressViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var lable = UILabel()
        if let tempLable = view as? UILabel {
            lable = tempLable
        }
        lable.numberOfLines = 0
        lable.textColor = UIColor.darkText
        lable.textAlignment = NSTextAlignment.center
        lable.font = UIFont.systemFont(ofSize: 15.0)
        lable.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return lable

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.proIndex = row
            self.cityIndex = 0
            self.countyIndex = 0
            if self.provinceArray.count > 0 {
                //市
                let model = self.provinceArray[row]
                self.cityArray = model.children
                pickerView.reloadComponent(1)
                pickerView.selectRow(self.cityIndex, inComponent: 1, animated: true)
                
                //区县
                if self.cityArray.count > 0 {
                    let cityModel = self.cityArray[self.cityIndex]
                    self.countyArray = cityModel.children
                    pickerView.reloadComponent(2)
                    pickerView.selectRow(self.countyIndex, inComponent: 2, animated: true)
                }
            }
            break
        case 1:
            self.cityIndex = row
            self.countyIndex = 0
            if self.cityArray.count > 0 {
                let cityModel = self.cityArray[self.cityIndex]
                self.countyArray = cityModel.children
                pickerView.reloadComponent(2)
                pickerView.selectRow(self.countyIndex, inComponent: 2, animated: true)
            }
           break
        case 2:
            self.countyIndex = row
            break
        default:
            break
        }
    }
}

extension ZXAddressViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        switch component {
        case 0:
            count = provinceArray.count
        case 1:
            count = cityArray.count
        case 2:
            count = countyArray.count
        default:
            break
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        switch component {
        case 0:
            if self.provinceArray.count > 0 {
                let provinceModel = self.provinceArray[row]
                title = provinceModel.name
            }
        case 1:
            if self.cityArray.count > 0 {
                let cityModel = self.cityArray[row]
                title = cityModel.name
            }
        case 2:
            if self.countyArray.count > 0 {
                let praishModel = self.countyArray[row]
                title = praishModel.name
            }
        default:
            break
        }
        return title
    }
}

