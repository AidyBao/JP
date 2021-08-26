//
//  JXSysNoticeDetailViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit
import WebKit

class JXSysNoticeDetailViewController: ZXUIViewController {

    @IBOutlet weak var msgContentView: UIView!
    @IBOutlet weak var titleLB: UILabel!
    var msgModel: JXNoticeModel?
    var wkWebView: WKWebView!
    
    class func show(superView: UIViewController, msgModel: JXNoticeModel?) {
        let vc = JXSysNoticeDetailViewController()
        vc.msgModel = msgModel
        superView.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "通知详情"
        self.view.backgroundColor = UIColor.zx_lightGray
        self.msgContentView.backgroundColor = UIColor.zx_lightGray
        
        self.titleLB.textColor = UIColor.zx_textColorTitle
        self.titleLB.font = UIFont.boldSystemFont(ofSize: UIFont.zx_bodyFontSize)
        
        let config = WKWebViewConfiguration.init()
        var js = "var meta = document.createElement('meta');"
        js += "meta.name='viewport';"
        js += "meta.content='width=device-width,initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0,user-scalable=no';"
        js += "document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        config.userContentController = wkUController;
        wkWebView = WKWebView.init(frame: CGRect.zero, configuration: config)
        wkWebView.scrollView.showsHorizontalScrollIndicator = false
        wkWebView.scrollView.alwaysBounceHorizontal = false
        wkWebView.backgroundColor = UIColor.zx_lightGray
        if #available(iOS 11.0, *) {
            wkWebView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        self.msgContentView.addSubview(wkWebView)
        
        wkWebView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(self.msgContentView)
        }
        
        if let model = self.msgModel {
            self.titleLB.text = model.noticeTitle
            self.wkWebView.loadHTMLString(model.noticeContent, baseURL: nil)
        }
    }
}
