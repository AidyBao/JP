//
//  SJAssetMainViewController.swift
//  gold
//
//  Created by 成都世纪星成网络科技有限公司 on 2021/3/26.
//

import UIKit
import WebKit

class SJAssetMainViewController: ZXUIViewController {
    
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    @IBOutlet weak var statusH: NSLayoutConstraint!
    fileprivate var webView: WKWebView!
    fileprivate var urlStr: String = ZXAPIConst.Game.otc + "token=\(ZXToken.token.userToken)"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
    }

    static func show(superV: UIViewController, url: String) {
        let vc = SJAssetMainViewController()
        vc.urlStr = url
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        
        //打开本地webkit
        self.addLocalWebKit()
        
        //打开外部Safari
        //self.addExternalSafari()
    }
    
    //打开外部Safari
    func addExternalSafari() {
        let set = CharacterSet(charactersIn: " ").inverted
        if let turl = urlStr.addingPercentEncoding(withAllowedCharacters: set) {
            ZXCommonUtils.openURL(turl)
        }else {
            ZXEmptyView.show(in: self.view, type: .noData, text: "资源无法加载", subText: nil) {
                ZXEmptyView.hide(from: self.view)

            }
        }
    }
    
    //打开本地webkit
    func addLocalWebKit() {
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
        //wkUController.add(self, name: "jsToOcWithGameStart")
        //wkUController.add(self, name: "jsToOcWithGameEnd")
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //本地webkit不需要此方法
        //self.backAction(UIButton())
    }

    @IBAction func backAction(_ sender: Any) {
        if let vcList = self.navigationController?.viewControllers {
            if vcList.count > 1 {
                self.navigationController?.popViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            ZXRootController.rootNav().dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {

    }
}

extension SJAssetMainViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //用message.body获得JS传出的参数体
        if let _ = message.body as? Dictionary<String, Any> {
            
        }
    }
}

extension SJAssetMainViewController: WKUIDelegate, WKNavigationDelegate {
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
