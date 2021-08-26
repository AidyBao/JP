//
//  JXNativeADViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/24.
//

import UIKit

class JXNativeADViewController: ZXBPushRootViewController {
    
    override var zx_dismissTapOutSideView: UIView? {return bgview}
    
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var adview: UIView!
    @IBOutlet weak var notGo: UIButton!
    @IBOutlet weak var go: UIButton!
    @IBOutlet weak var lb: UILabel!
    //广告view高度
    var adViewHeight: CGFloat = 0
    var center: QUBIADSdkCenter!
    
    static func show(superV: UIViewController) {
        let vc = JXNativeADViewController()
        superV.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true
        
        self.lb.font = UIFont.zx_bodyFont
        self.lb.textColor = UIColor.zx_textColorBody
        self.go.titleLabel?.font = UIFont.zx_bodyFont
        self.go.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.go.backgroundColor = UIColor.zx_tintColor
        self.go.layer.cornerRadius = self.go.frame.height * 0.5
        self.go.layer.masksToBounds = true
        
        self.notGo.titleLabel?.font = UIFont.zx_bodyFont
        self.notGo.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.notGo.backgroundColor = UIColor.white
        self.notGo.layer.cornerRadius = self.go.frame.height * 0.5
        self.notGo.layer.masksToBounds = true
        self.notGo.layer.borderWidth = 1
        self.notGo.layer.borderColor = UIColor.zx_tintColor.cgColor
        
        //步骤 1：根据宽度算出广告的高度
        self.adViewHeight = JXQBUnifiedNativeImageView.getViewHeightWithWidth(width: self.adview.bounds.width)
        
        //步骤 2：初始化广告view
        self.addAd()
    }
    
    func addAd() {
        center = QUBIADSdkCenter()
        center.unifiedNativeAdDelegate = self
        center.qb_requestUnifiedAd(ZXAPIConst.QUBianAD.UnifiedXXLID, channelNum: "", channelVersion: "", delegate: self, loadAdCount: 1)
        
    }

    @IBAction func notGo(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Go(_ sender: UIButton) {
        self.dismiss(animated: true) {
            ZXRootController.selecteTabarController(selecteIndex: 2)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    lazy var adCotentView: JXQBUnifiedNativeImageView = {
        let view = JXQBUnifiedNativeImageView(frame: CGRect(x: 0, y: 0, width: self.adview.bounds.width, height: self.adview.bounds.height))
        return view
    }()
    
}


extension JXNativeADViewController: QBUnifiedNativeAdDelegate {
    func qb_unifiedNativeAdLoaded(_ unifiedNativeAdDataObjects: [Any], _ error: Error) {
        if unifiedNativeAdDataObjects.count > 0  {
            if let model = unifiedNativeAdDataObjects.first as? GDTUnifiedNativeAdDataObject {
                self.adCotentView.setupWithUnifiedNativeAdObject(unifiedNativeDataObject: model, center: center, rootViewController: self)
                
                self.adview.addSubview(self.adCotentView)
            }
            return
        }
    }
    
    func qb_unifiedNativeAdClick() {
        
    }
    
    func qb_unifiedNativeAdExposure() {
        
    }
}
