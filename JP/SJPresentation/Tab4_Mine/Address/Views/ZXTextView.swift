//
//  ZXTextView.swift
//  YDY_GJ_3_5
//
//  Created by 120v on 2017/5/15.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

///return textView.text.Characters.count 返回textView的字数
@objc protocol ZXTextViewDelegate: NSObjectProtocol{
    
    @objc optional func getTextNum(textNum: Int)
    
}

class ZXTextView: UIView, UITextViewDelegate {
    
    //MARK: - Properties
    var textView: UITextView!
    var placeLabel: UILabel!
//    var characterNum    = 0
    ////限制文字字数
    var limitTextNum    = INT_MAX
    
    weak var delegate: ZXTextViewDelegate?
    
    var placeText : String = "" {
        didSet{
            placeLabel?.text = placeText
        }
    }
    
    //MARK: - LifeCycle
    init(frame: CGRect, placeHolder: String?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        placeText = placeHolder!
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Actions
    func setup() {
        textView = UITextView.init()
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.tintColor = UIColor.lightGray
        textView.returnKeyType = .done
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = NSTextAlignment.left
        textView.textColor = UIColor.zx_textColorBody
        textView.delegate = self
        addSubview(textView!)
        
        placeLabel = UILabel.init()
        placeLabel.backgroundColor = UIColor.clear
        placeLabel?.text = placeText
        placeLabel.font = UIFont.systemFont(ofSize: 13)
        placeLabel.textColor = UIColor.lightGray
        addSubview(placeLabel!)
        if textView.text.count > 0 {
            placeLabel.isHidden = true
        }else{
            placeLabel.isHidden = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelH: CGFloat = 20.0
        let labelW: CGFloat = self.frame.width - 3
        self.textView.frame =  CGRect.init(x: 0, y: 3, width: self.frame.size.width, height: self.frame.size.height)
        self.placeLabel.frame = CGRect.init(x: 3, y: 12, width: labelW, height: labelH)
        if textView.text.count > 0 {
            placeLabel.isHidden = true
        }else{
            placeLabel.isHidden = false
        }
    }
    
    //MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        let str = textView.text
        if (str?.count)! > 0 {
            placeLabel!.isHidden = true
        }else{
            placeLabel!.isHidden = false
        }
        if delegate != nil {
            self.delegate?.getTextNum!(textNum: (str?.count)!)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        
        if  (textView.textInputMode?.primaryLanguage!.isEqual("emoji")) == true || ((textView.textInputMode?.primaryLanguage) == nil){
            return false
        }
        
        if let inputMode = textView.textInputMode, let language = inputMode.primaryLanguage, language.hasPrefix("zh") {
            if let newrange = textView.markedTextRange {
                let start = textView.offset(from: textView.beginningOfDocument, to: newrange.start)
                if start > limitTextNum {
                    ZXHUD.showFailure(in: (UIApplication.shared.keyWindow?.rootViewController?.view)!, text: "输入字符长度不能大于\(limitTextNum)！", delay: ZX.HUDDelay)
                    return false
                }
            }else{
                if let oldText = textView.text {
                    if oldText.count + text.count - range.length > limitTextNum {
                        ZXHUD.showFailure(in: (UIApplication.shared.keyWindow?.rootViewController?.view)!, text: "输入字符长度不能大于\(limitTextNum)！", delay: ZX.HUDDelay)
                        return false
                    }
                }
            }
        }else{
            if let oldText = textView.text {
                if oldText.count + text.count - range.length > limitTextNum {
                    ZXHUD.showFailure(in: (UIApplication.shared.keyWindow?.rootViewController?.view)!, text: "输入字符长度不能大于\(limitTextNum)！", delay: ZX.HUDDelay)
                    return false
                }
            }
        }

        return true
    }
    
    //重写hitTest方法,来处理在View点击外区域收回键盘
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isUserInteractionEnabled == false && self.alpha <= 0.01 && self.isHidden == true {
            return nil
        }
        if self.point(inside: point, with: event) == false {
            textView?.resignFirstResponder()
            return nil
        }else{
            for subView in self.subviews.reversed() {
                let convertPoint = subView.convert(point, from: self)
                let hitTestView = subView.hitTest(convertPoint, with: event)
                if (hitTestView != nil) {
                    return hitTestView
                }
            }
            return self
        }
    }
}

