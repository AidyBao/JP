//
//  JXVerCodeViewController.swift
//  gold
//
//  Created by SJXC on 2021/3/30.
//

import UIKit
import WebKit

typealias JXVerCodeViewCallback = (_ ticket: String, _ randstr: String) -> Void

class JXVerCodeViewController: ZXUIViewController{
    var webView: WKWebView!
    var jxCallback: JXVerCodeViewCallback?
    
    static func show(superv: UIViewController, callback: JXVerCodeViewCallback?) {
        let vc = JXVerCodeViewController()
        vc.jxCallback = callback
        superv.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "人机验证"

        self.addUI()
    }


    func addUI() {
        let config = WKWebViewConfiguration()
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        // 在 iOS 上默认为 NO，表示是否允许不经过用户交互由 javaScript 自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = true
        config.preferences = preference
        
        //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
        let wkUController = WKUserContentController()
        wkUController.add(self, name: "jsToOcWithPrams")
        config.userContentController = wkUController
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH, height: ZXBOUNDS_HEIGHT), configuration: config)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
//        guard let path = Bundle.main.path(forResource: "JStoOC.html", ofType: nil) else { return}
        
        if let path = Bundle.main.path(forResource: "JStoOC.html", ofType: nil) {
            do {
                let htmlString = try String(contentsOfFile: path, encoding: .utf8)
                
                self.webView.loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: Bundle.main.bundlePath))
                self.view.addSubview(self.webView)
            }catch {
                
            }
        }
    }
}

extension JXVerCodeViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //用message.body获得JS传出的参数体
        if let dic = message.body as? Dictionary<String, Any> {
            //JS调用OC
            if message.name == "jsToOcWithPrams" {
                if let ticket = dic["ticket"] as? String, !ticket.isEmpty, let randstr = dic["randstr"] as? String, !randstr.isEmpty{
                    if let callb = self.jxCallback {
                        callb(ticket, randstr)
                    }
                    self.navigationController?.popViewController(animated: true)
                }else{
                    ZXHUD.showFailure(in: self.view, text: "验证失败，请稍后再试", delay: ZX.HUDDelay)
                }
            }
        }
    }
}

extension JXVerCodeViewController: WKUIDelegate, WKNavigationDelegate {
    // 接收到服务器跳转请求即服务重定向时之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
   
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
}
