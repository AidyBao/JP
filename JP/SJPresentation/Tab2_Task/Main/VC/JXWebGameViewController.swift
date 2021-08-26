//
//  JXWebGameViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/20.
//

import UIKit
import WebKit
import JavaScriptCore
import HandyJSON

class WebJXToOC: NSObject {
    struct method {
        static  let WebGameStart = "jsToOcWithGameStart"
        static  let WebGameEnd = "jsToOcWithGameEnd"
        static  let WebSecKill = "jsToOcWithSeckill"
        static  let WebSignin = "jsToOcWithSignin"
    }
}

typealias JXWebGameViewCallback = (_ count: String) -> Void

class JXWebGameViewController: ZXUIViewController {
  
    
    
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    @IBOutlet weak var statusH: NSLayoutConstraint!
    fileprivate var webView: WKWebView!
    fileprivate var urlStr: String = ""
    fileprivate var jxCallback: JXWebGameViewCallback? = nil
    
    static func show(superV: UIViewController, url: String, callBack: JXWebGameViewCallback?) {
        let vc = JXWebGameViewController()
        vc.urlStr = url
        vc.jxCallback = callBack
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }

        self.addWebView()
        
        
        
        //只对URL中的空格字符做编码
        let set = CharacterSet(charactersIn: " ").inverted
        if let turl = urlStr.addingPercentEncoding(withAllowedCharacters: set) {
                if let urls = URL(string: turl) {
                    ZXHUD.showLoading(in: self.view, text: "", delay: 0)
                    self.webView.load(URLRequest(url: urls))
                }
        }else {
            ZXEmptyView.show(in: self.view, type: .noData, text: "资源无法加载", subText: nil) {
                ZXEmptyView.hide(from: self.view)
                self.webView.reload()
            }
        }
    }
    
    func addWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.selectionGranularity = WKSelectionGranularity.character
        //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
        let wkUController = WKUserContentController()
        wkUController.add(self, name: WebJXToOC.method.WebGameStart)
        wkUController.add(self, name: WebJXToOC.method.WebGameEnd)
        //秒杀
        wkUController.add(self, name: WebJXToOC.method.WebSecKill)
        //签到
        wkUController.add(self, name: WebJXToOC.method.WebSignin)
        configuration.userContentController = wkUController
        

        self.webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH, height: ZXBOUNDS_HEIGHT), configuration: configuration)
        self.webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.insertSubview(self.webView, at: 0)
        self.webView.backgroundColor = UIColor.white
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
//        webView.configuration.userContentController.removeScriptMessageHandler(forName: "jsToOcWithGameStart")
//        webView.configuration.userContentController.removeScriptMessageHandler(forName: "jsToOcWithGameEnd")
    }
}

extension JXWebGameViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //用message.body获得JS传出的参数体
        if let dic = message.body as? Dictionary<String, Any> {
            //JS调用OC
            if message.name == WebJXToOC.method.WebGameEnd {
                if let count = dic["count"] as? Int {
                    self.navigationController?.popViewController(animated: true)
                    if let callb = self.jxCallback {
                        callb("\(count)")
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: "验证失败，请稍后再试", delay: ZX.HUDDelay)
                }
            }
            
            if message.name == WebJXToOC.method.WebGameStart {
                
            }
            
            if message.name == WebJXToOC.method.WebSecKill {
                if let count = dic["orderId"] as? String {
                    if let callb = self.jxCallback {
                        callb(count)
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: "验证失败，请稍后再试", delay: ZX.HUDDelay)
                }
            }
            
            if message.name == WebJXToOC.method.WebSignin {
                if let count = dic["orderId"] as? String {
                    if let callb = self.jxCallback {
                        callb(count)
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: "验证失败，请稍后再试", delay: ZX.HUDDelay)
                }
            }
        }
    }
}

extension JXWebGameViewController: WKUIDelegate, WKNavigationDelegate {
    // 接收到服务器跳转请求即服务重定向时之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
   
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ZXHUD.hide(for: self.view, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ZXHUD.hide(for: self.view, animated: true)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
}
