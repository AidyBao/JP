//
//  JXPayVerCostViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/17.
//

import UIKit


typealias JXPayVerCostCallback = () -> Void

class JXPayVerCostViewController: ZXUIViewController {
    @IBOutlet weak var shuomlb: UILabel!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var zfbBtn: UIButton!
    @IBOutlet weak var wxBtn: UIButton!
    var zxCallback: JXPayVerCostCallback? = nil
    var orderstr: String    = ""
    
    class func show(superView: UIViewController, callback: JXPayVerCostCallback?) -> Void {
        let logVC = JXPayVerCostViewController()
        logVC.zxCallback = callback
        superView.navigationController?.pushViewController(logVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "实名费用"
        
        self.shuomlb.font = UIFont.zx_bodyFont(13)
        self.shuomlb.textColor = UIColor.zx_textColorMark
        self.lb1.font = UIFont.zx_bodyFont(13)
        self.lb1.textColor = UIColor.zx_textColorMark
        
        self.cardView.layer.masksToBounds = true
        self.cardView.layer.cornerRadius = 10
        
        self.cardImg.layer.masksToBounds = true
        self.cardImg.layer.cornerRadius = 10
        
        self.zfbBtn.layer.masksToBounds = true
        self.zfbBtn.layer.cornerRadius = 10
        self.zfbBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.zfbBtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.wxBtn.layer.masksToBounds = true
        self.wxBtn.layer.cornerRadius = 10
        self.wxBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.wxBtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.shuomlb.text = "实名认证需要第三方公司系统认证，用户需要支付2.0元认证费用；如您不同意，请勿支付及认证；如您支付并成功完成认证，将视同意此协议。"
        NotificationCenter.default.addObserver(self, selector: #selector(payResult(notice:)), name: ZXNotification.Alipay.payStatus.zx_noticeName(), object: nil)
        
        jx_requestOrderNo()
    }
    
    @objc func payResult(notice: Notification) {
        if let code = notice.object as? Int {
            switch code {
            case 9000://成功
                ZXHUD.showSuccess(in: self.view, text: "支付成功", delay: ZXHUD.DelayOne)
                //self.zxCallback?()
                self.navigationController?.popToRootViewController(animated: true)
            case 8000:
                ZXHUD.showFailure(in: self.view, text: "支付中...", delay: ZXHUD.DelayOne)
            case 6001:
                ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: "用户取消支付", delay: ZXHUD.DelayOne)
            case 6002://网络连接出错
                ZXHUD.showText(in: self.view, text: "网络连接错误", delay: ZXHUD.DelayTime)
            case 6004://支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                ZXAlertUtils.showAlert(wihtTitle: "支付结果未知", message: "后续请在订单列表查看支付状态", buttonText: "确定", action: {
                })
            case 4000:
                ZXHUD.showFailure(in: self.view, text: "支付失败", delay: ZXHUD.DelayOne)
            default:
                break
            }
        }
    }

    @IBAction func zfbAction(_ sender: Any) {
        if !self.orderstr.isEmpty {
            AlipaySDK.defaultService()?.payOrder(self.orderstr, fromScheme: ALIPAY_AppScheme, callback: { (dict) in
                JXPayControl.parsePayResult(dict)
            })
        }
    }
    
    @IBAction func wxAction(_ sender: Any) {
        
    }
}

extension JXPayVerCostViewController {
    func jx_requestOrderNo() {
        ZXLoginManager.jx_getOrderNo(url: ZXAPIConst.Pay.getOrderNo, businessType: "") { (succ, code, orderStr, msg) in
            if succ {
                if let str = orderStr {
                    self.orderstr = str
                }
            }
        } zxFailed: { (code, msg) in
            
        }
    }
}
