//
//  ZXWebViewViewController.swift
//  YDHYK
//
//  Created by 120v on 2017/11/3.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
import WebKit

class ZXWebViewViewController: ZXUIViewController {
    
    fileprivate var urlStr:String = ""
    fileprivate var titleStr:String = ""
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var statusTopH: NSLayoutConstraint!
    
    static func show(superV: UIViewController, urlStr: String, title: String) {
        let vc = ZXWebViewViewController()
        vc.urlStr = urlStr
        vc.titleStr = title
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.zx_DeviceSizeType() == .s_5_8_Inch {
            statusTopH.constant = 20.0 + 24.0
        }
        
        self.title = "\(titleStr)"
        self.view.backgroundColor = UIColor.white
        self.webView.backgroundColor = UIColor.zx_backgroundColor
        self.webView.scrollView.isScrollEnabled = true
        self.webView.isOpaque = false
        self.webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if !urlStr.isEmpty {
            if let url = URL.init(string: urlStr) {
                ZXHUD.showLoading(in: self.view, text: "", delay: nil)
                self.webView.load(URLRequest(url: url))
            }else{
                ZXAlertUtils.showAlert(wihtTitle: "提示", message: "访问出错了", buttonText: "确定", action: {
                    self.dismissAction()
                })
            }
        }else{
            ZXAlertUtils.showAlert(wihtTitle: "提示", message: "访问出错了", buttonText: "确定", action: {
                self.dismissAction()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Dismiss
    @IBAction func dismissAction() -> Void {
        if (self.navigationController != nil) {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ZXWebViewViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ZXHUD.hide(for: self.view, animated: true)
    }
    
    // 接收到服务器跳转请求即服务重定向时之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
   
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ZXHUD.hide(for: self.view, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ZXHUD.hide(for: self.view, animated: true)
        
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
}



