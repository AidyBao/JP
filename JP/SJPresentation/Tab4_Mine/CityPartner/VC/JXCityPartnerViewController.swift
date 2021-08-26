//
//  JXCityPartnerViewController.swift
//  gold
//
//  Created by SJXC on 2021/7/21.
//  城市合伙人

import UIKit
import IQKeyboardManagerSwift

class JXCityPartnerViewController: ZXUIViewController {
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var statusH: NSLayoutConstraint!
    @IBOutlet weak var cityParterView: UIView!
    @IBOutlet weak var navBgViewH: NSLayoutConstraint!
    
    @IBOutlet weak var headImgV: ZXUIImageView!
    @IBOutlet weak var cityLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var LB1: UILabel!
    @IBOutlet weak var cityDetailLB: UILabel!
    @IBOutlet weak var activtyLB: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!
    @IBOutlet weak var lb7: UILabel!
    
    @IBOutlet weak var bt1: UIButton!
    @IBOutlet weak var bt2: UIButton!
    
    static func show(superV: UIViewController) {
        let vc = JXCityPartnerViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        
        self.jx_activityTotal()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bt1Action(_ sender: UIButton) {
        JXCityActivityViewController.show(superV: self)
    }
    
    @IBAction func bt2Action(_ sender: UIButton) {
        ZXWebViewViewController.show(superV: self, urlStr: ZXURLConst.Web.cityRule, title: "城市运营中心规则")
    }
    
    override var zx_preferredNavgitaionBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension JXCityPartnerViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            self.jx_search(city: text)
        }else{
            ZXHUD.showFailure(in: self.view, text: "请输入城市名字", delay: ZX.HUDDelay)
        }
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

extension JXCityPartnerViewController {
    func setUI() {
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        
        self.view.backgroundColor = UIColor.zx_lightGray
        
        if #available(iOS 11.0, *) {
            
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        headImgV.layer.cornerRadius = headImgV.frame.height * 0.5
        headImgV.layer.masksToBounds = true
        headImgV.kf.setImage(with: URL(string: ZXUser.user.headUrl))
        
        cityLB.font = UIFont.zx_markFont
        cityLB.textColor = UIColor.zx_textColorBody
        if let zxtoken = ZXToken.zxToken {
            if zxtoken.isCityPartner == "false" {
                bt1.isHidden = true
                cityParterView.isHidden = true
                navBgViewH.constant = navView.frame.height + 20
            }else{
                cityLB.text = zxtoken.isCityPartner
                cityDetailLB.text = "合伙人城市：" + zxtoken.isCityPartner
            }
        }
           
        nameLB.font = UIFont.boldSystemFont(ofSize: UIFont.zx_bodyFontSize)
        nameLB.textColor = UIColor.zx_textColorBody
        nameLB.text = ZXUser.user.nickName.isEmpty ? "未设置":ZXUser.user.nickName
        
        cityDetailLB.font = UIFont.boldSystemFont(ofSize: UIFont.zx_bodyFontSize)
        cityDetailLB.textColor = UIColor.zx_textColorBody
        
        LB1.font = UIFont.boldSystemFont(ofSize: UIFont.zx_bodyFontSize)
        LB1.textColor = UIColor.zx_textColorBody
        
        activtyLB.font = UIFont.boldSystemFont(ofSize: 28)
        activtyLB.textColor = UIColor.zx_textColorBody
        activtyLB.text = ""
        
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.white
        searchBar.backgroundImage = UIImage()
       
        lb2.font = UIFont.boldSystemFont(ofSize: 28)
        lb2.textColor = UIColor.white
        lb2.text = ""
        
        lb3.font = UIFont.zx_bodyFont
        lb3.textColor = UIColor.white
        lb3.text = ""
        
        lb4.layer.cornerRadius = 5
        lb4.layer.masksToBounds = true
        lb4.font = UIFont.zx_bodyFont
        lb4.textColor = UIColor.zx_tintColor
        lb4.text = "已有合伙人"
        lb4.isHidden = true
        
        lb5.font = UIFont.zx_bodyFont
        lb5.textColor = UIColor.white
        lb5.isHidden = true
        
        lb6.font = UIFont.zx_bodyFont
        lb6.textColor = UIColor.white
        lb6.isHidden = true
        
        lb7.font = UIFont.zx_bodyFont
        lb7.textColor = UIColor.white
        lb7.isHidden = true
        
        bt2.setTitleColor(UIColor.zx_tintColor, for: .normal)
        bt2.titleLabel?.font = UIFont.zx_bodyFont
        bt2.backgroundColor = UIColor.white
        bt2.layer.cornerRadius = 5
        bt2.layer.masksToBounds = true
        bt2.layer.borderWidth = 1
        bt2.layer.borderColor = UIColor.zx_tintColor.cgColor
        
        bt1.setTitleColor(UIColor.white, for: .normal)
        bt1.titleLabel?.font = UIFont.zx_bodyFont
        bt1.layer.cornerRadius = bt1.frame.height * 0.5
        bt1.layer.masksToBounds = true
        bt1.backgroundColor = UIColor.zx_colorWithHexString("#56A4FD")
    }
}

extension JXCityPartnerViewController {
    func jx_activityTotal() {
        JXCityPartnerManager.jx_cityTotal(url: ZXAPIConst.city.cityTotal) { c, s, count, msg in
            if s {
                if let cou = count {
                    self.activtyLB.text = "\(cou)"
                }
            }
        }
    }
    
    func jx_search(city: String) {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXCityPartnerManager.jx_citySearch(url: ZXAPIConst.city.citySearch, cityName: city) { c, s, listM, msg in
            ZXHUD.hide(for: self.view, animated: true)
            self.loadUI(s: s, listM: listM, msg: msg)
        }
    }
    
    func loadUI(s: Bool, listM: Array<JXCitySearchModel>?, msg: String) {
        if s {
            if let list = listM {
                JXCityListViewController.show(superView: self, list: list) { model in
                    if let mod = model {
                        self.lb2.isHidden = false
                        self.lb3.isHidden = false
                        self.lb4.isHidden = false
                        self.lb2.text = mod.cityName
                        self.lb3.text = "(\(mod.population))人"
                        self.lb4.text = "已有合伙人"
                        self.activtyLB.isHidden = false
                        self.lb4.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                        self.lb5.isHidden = false
                        self.lb5.text = "姓名:" + mod.leaderName
                        self.lb6.isHidden = false
                        self.lb6.text = "电话:" + mod.mobileNo
                        self.lb7.isHidden = false
                        self.lb7.text = "地址:" + mod.provinceName + mod.address
                    }
                }
            }else{
                self.lb4.isHidden = false
                self.lb2.isHidden = true
                self.lb3.isHidden = true
                self.lb5.isHidden = true
                self.lb6.isHidden = true
                self.lb7.isHidden = true
                self.lb4.text = "暂无合伙人"
                self.activtyLB.isHidden = true
                self.lb4.backgroundColor = UIColor.clear
                ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayTime)
            }
        }else{
            self.lb4.isHidden = false
            self.lb2.isHidden = true
            self.lb3.isHidden = true
            self.lb5.isHidden = true
            self.lb6.isHidden = true
            self.lb7.isHidden = true
            self.lb4.text = "暂无合伙人"
            self.activtyLB.isHidden = true
            self.lb4.backgroundColor = UIColor.clear
            ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayTime)
        }
    }
}

extension JXCityPartnerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minAlphaOffset: CGFloat = -88
        let maxAlphaOffset: CGFloat = 200
        let offset = scrollView.contentOffset.y
        var alpha: CGFloat = 0
        if offset <= 0 {
            alpha = 0
        }else{
            alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset)
        }
        navView.backgroundColor = UIColor.zx_tintColor.withAlphaComponent(alpha)
    }
}


