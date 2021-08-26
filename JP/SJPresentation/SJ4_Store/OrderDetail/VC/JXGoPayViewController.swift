//
//  JXGoPayViewController.swift
//  gold
//
//  Created by SJXC on 2021/5/6.
//

import UIKit

//0: gsv, 1:支付宝
typealias JXGoPayResult = (_ type: Int) -> Void

class JXGoPayViewController: ZXBPushRootViewController {
    
    override var zx_dismissTapOutSideView: UIView? {return contentView}
    
    @IBOutlet weak var contentView: UIView!
//    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    fileprivate var order:JXOrderDetailModel!
    fileprivate var callback: JXGoPayResult? = nil
    
    static func show(superV: UIViewController, orderm: JXOrderDetailModel, result: JXGoPayResult?) {
        let vc = JXGoPayViewController()
        vc.order = orderm
        vc.callback = result
        superV.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.lb1.textColor = UIColor.zx_textColorBody
//        self.lb1.font = UIFont.zx_bodyFont
        
        self.lb2.textColor = UIColor.zx_textColorBody
        self.lb2.font = UIFont.zx_bodyFont

        NotificationCenter.default.addObserver(self, selector: #selector(payResult(notice:)), name: ZXNotification.Alipay.payStatus.zx_noticeName(), object: nil)
        
    }
    
    @objc func payResult(notice: Notification) {
        if let code = notice.object as? Int {
            switch code {
            case 9000://成功
                self.dismiss(animated: true) {
                    self.callback?(1)
                }
            case 8000:
                ZXHUD.showFailure(in: self.view, text: "支付中...", delay: ZXHUD.DelayOne)
            case 6001:
                ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: "用户取消支付", delay: ZXHUD.DelayOne)
            case 6002://网络连接出错
                ZXHUD.showText(in: self.view, text: "网络连接错误", delay: ZXHUD.DelayTime)
            case 6004://支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                ZXAlertUtils.showAlert(wihtTitle: "支付结果未知", message: "后续请在订单列表查看支付状态", buttonText: "确定", action: {
                    self.dismiss(animated: true) {
                        self.callback?(1)
                    }
                })
            case 4000:
                ZXHUD.showFailure(in: self.view, text: "支付失败", delay: ZXHUD.DelayOne)
            default:
                break
            }
        }
    }


//    @IBAction func gsvAction(_ sender: UIButton) {
//        self.dismiss(animated: true) {
//            self.callback?(0)
//        }
//    }
    ////0-平台支付，1-支付宝，2-微信
    @IBAction func alipayAction(_ sender: UIButton) {
        if self.order.cityInfo.isEmpty {
            ZXHUD.showFailure(in: self.view, text: "请先设置收货地址", delay: ZXHUD.DelayOne)
            return
        }
        
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXOrderListManager.pay(orderNo: self.order.orderSn, payType: "1", tradePassword: nil) { succ, code, nostr, msg in
            ZXHUD.hide(for: self.view, animated: true)
            if succ {
                if let number = nostr, !number.isEmpty {
                    AlipaySDK.defaultService()?.payOrder(number, fromScheme: ALIPAY_AppScheme, callback: { (dict) in
                        JXPayControl.parsePayResult(dict)
                    })
                }else{
                    ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayOne)
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: msg, delay: ZXHUD.DelayOne)
            }
        }
    }
}
