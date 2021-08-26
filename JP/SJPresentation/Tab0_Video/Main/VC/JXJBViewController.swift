//
//  JXJBViewController.swift
//  gold
//
//  Created by SJXC on 2021/5/14.
//

import UIKit

class JXJBViewController: ZXBPushRootViewController {
    override var zx_dismissTapOutSideView: UIView? { return bgView}
    
    @IBOutlet weak var bgView: UIView!
    fileprivate var model:JXVideoModel?
    @IBOutlet weak var headV: ZXUIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var textView: ZXTextView!
    
    static func show(superV: UIViewController, model: JXVideoModel?) {
        let vc = JXJBViewController()
        vc.model = model
        superV.present(vc, animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.backgroundColor = UIColor.zx_lightGray
        self.textView.layer.cornerRadius = 10
        self.textView.layer.masksToBounds = true
        self.textView.placeText = "请用文字描述一下您所遇到的问题..."
        self.textView.delegate = self
        self.textView.limitTextNum = 64

        if let mod = model, let umod = mod.userInfo {
            self.nameLB.text = umod.nickName
            self.headV.kf.setImage(with: URL(string: umod.headUrl))
        }
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commitAction(_ sender: UIButton) {
        if let textv = self.textView.textView, let text = textv.text, !text.isEmpty {
            ZXHUD.showLoading(in: self.view, text: "", delay: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                ZXHUD.hide(for: self.view, animated: true)
                ZXHUD.showSuccess(in: self.view, text: "举报成功，平台将会在24小时之内给出回复", delay: ZXHUD.DelayOne)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension JXJBViewController: ZXTextViewDelegate {
    func getTextNum(textNum: Int) {
        
    }
}
