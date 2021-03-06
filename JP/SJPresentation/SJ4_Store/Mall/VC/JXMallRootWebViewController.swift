//
//  JXMallRootWebViewController.swift
//  gold
//
//  Created by SJXC on 2021/8/23.
//

import UIKit
import WebKit
import JavaScriptCore
import HandyJSON

class MallWebJXToOC: NSObject {
    struct method {
        //δΈε
        static  let MallOrder = "jsToOcWithMallOrder"
    }
}

typealias JXMallWebViewCallback = (_ count: String) -> Void

class JXMallRootWebViewController: ZXUIViewController {
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    @objc fileprivate var webView: WKWebView!
    fileprivate var urlStr: String = ZXURLConst.Web.shop + "?" + "token=\(ZXToken.token.userToken)"
    fileprivate var jxCallback: JXMallWebViewCallback? = nil
    var observation: NSKeyValueObservation?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    static func show(superV: UIViewController, url: String, callBack: JXMallWebViewCallback?) {
        let vc = JXMallRootWebViewController()
        vc.urlStr = url
        vc.jxCallback = callBack
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "εε"
        
        self.addWebView()
        
        self.zx_refresh()
        
        self.webView.scrollView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(zx_refresh))
    }
    
    @objc override func zx_refresh() {
        
        if !urlStr.isEmpty {
            if urlStr.hasPrefix("\(ZXURLConst.Web.shop)?token=") {
                urlStr = ZXURLConst.Web.shop + "?" + "token=\(ZXToken.token.userToken)"
            }
            
            //εͺε―ΉURLδΈ­ηη©Ίζ Όε­η¬¦εηΌη 
            let set = CharacterSet(charactersIn: " ").inverted
            if let turl = urlStr.addingPercentEncoding(withAllowedCharacters: set) {
                if let url = URL(string: turl) {
                    ZXHUD.showLoading(in: self.view, text: "", delay: 0)
                    self.webView.load(URLRequest(url: url))
                } else {
                    self.webView.scrollView.mj_header?.endRefreshing()
                    ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: "ε°εδΈε­ε¨", delay: ZXHUD.DelayOne)
                }
            }else{
                ZXEmptyView.show(in: self.view, type: .noData, text: "θ΅ζΊζ ζ³ε θ½½", subText: nil) {
                    ZXEmptyView.hide(from: self.view)
                    self.webView.reload()
                }
            }
        } else {
            self.webView.scrollView.mj_header?.endRefreshing()
            ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: "ε°εδΈε­ε¨", delay: ZXHUD.DelayOne)
        }
    }
    
    func addWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.selectionGranularity = WKSelectionGranularity.character
        //ζ³¨εδΈδΈͺnameδΈΊjsToOcNoPramsηjsζΉζ³ θ?Ύη½?ε€ηζ₯ζΆJSζΉζ³ηε―Ήθ±‘
        let wkUController = WKUserContentController()
        wkUController.add(self, name: MallWebJXToOC.method.MallOrder)
        configuration.userContentController = wkUController

        self.webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH, height: ZXBOUNDS_HEIGHT - 88), configuration: configuration)
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.insertSubview(self.webView, at: 0)
        self.webView.backgroundColor = UIColor.white
        
        observation = webView.observe(\.url, options: [.new,.old], changeHandler: { webVw, change in
            guard let newUrl = change.newValue as? URL else {
                return
            }
            weak var weakself = self
            weakself?.urlStr = newUrl.absoluteString
        })
    }


    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        observation = nil
    }
}

extension JXMallRootWebViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //η¨message.bodyθ·εΎJSδΌ εΊηεζ°δ½
        if let dic = message.body as? Dictionary<String, Any> {
            //JSθ°η¨OC
            if message.name == MallWebJXToOC.method.MallOrder {
                if let _ = dic["orderId"] as? String {
//                    if let callb = self.jxCallback {
//                        callb(count)
//                    }
                    
                    JXOrderRootViewController.show(superV: self)
                }else{
                    ZXHUD.showFailure(in: self.view, text: "ιͺθ―ε€±θ΄₯οΌθ―·η¨εεθ―", delay: ZX.HUDDelay)
                }
            }
        }
    }
}

extension JXMallRootWebViewController: WKUIDelegate, WKNavigationDelegate {
    // ζ₯ζΆε°ζε‘ε¨θ·³θ½¬θ―·ζ±ε³ζε‘ιε?εζΆδΉεθ°η¨
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
   
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.scrollView.mj_header?.endRefreshing()
        ZXHUD.hide(for: self.view, animated: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.webView.scrollView.mj_header?.endRefreshing()
        ZXHUD.hide(for: self.view, animated: true)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
}
