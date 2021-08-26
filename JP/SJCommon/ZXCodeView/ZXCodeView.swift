//
//  ZXCodeView.swift
//  FindCar
//
//  Created by 120v on 2018/1/23.
//  Copyright © 2018年 screson. All rights reserved.
//

import UIKit

protocol ZXCodeViewDelegate: NSObjectProtocol {
    func zxCodeViewCode(codeView: ZXCodeView, code: String)
}

enum ZXKeyBoardType {
    case numberPad
    case otherPad
}

class ZXCodeView: UIView {
    
    weak var delegate: ZXCodeViewDelegate?
    /// 密码框的数组
    fileprivate var codeArr = [UILabel]()
    
    /// 框框之间的间隔
    fileprivate var space:CGFloat = 10.0
    
    /// 框的大小
    fileprivate var codeW:CGFloat = 60
    
    /// 框框个数
    fileprivate var codeCount = 4
    
    /// 键盘类型
    fileprivate var keyBoardType: ZXKeyBoardType = .numberPad
    
    /// 输入框
    var codeText : UITextField!
    
    init(frame: CGRect,count:Int = 4,margin:CGFloat = 10,boardType:ZXKeyBoardType) {
        super.init(frame: frame)
        space = margin
        codeCount = count
        keyBoardType = boardType
        
        addSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        
        //1.
        codeText = UITextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        codeText.isHidden = true
        codeText.backgroundColor = UIColor.lightGray
        codeText.delegate = self
        if keyBoardType == .otherPad {
            codeText.keyboardType = .asciiCapable
        }else {
            codeText.keyboardType = .numberPad
        }
        codeText.becomeFirstResponder()
        codeText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addSubview(codeText)
        
        //2. 计算左间距
        let leftmargin: CGFloat = 0
        
        codeW = (self.frame.width - CGFloat((codeCount - 1))*space)/CGFloat(codeCount)
        
        // 创建 n个 UITextFiedl
        for i in 0..<codeCount{
            let rect = CGRect(x: leftmargin + CGFloat(i)*codeW + CGFloat(i)*space, y: 0, width: codeW, height: self.frame.size.height)
            let dot = addLabel(frame: rect)
            dot.tag = i
            codeArr.append(dot)
        }
        // 防止搞事
        if codeCount < 1 {
            return
        }
    }
    
    private func addLabel(frame:CGRect)->UILabel{
        let dot = UILabel(frame: frame)
        dot.layer.cornerRadius = 10
        dot.layer.masksToBounds = true
        dot.backgroundColor = UIColor.zx_lightGray
        dot.textAlignment = .center
        dot.textColor = UIColor.zx_tintColor
        dot.font = UIFont.init(name: "DINAlternate-Bold", size: 50)
        addSubview(dot)
        
        let geliView: UIView = UIView.init()
        geliView.center = CGPoint(x: dot.center.x - frame.size.width * 0.5, y: frame.maxY)
        geliView.frame.size.width = frame.size.width
        geliView.frame.size.height = 1.0
        geliView.backgroundColor = UIColor.clear
        addSubview(geliView)
        
        return dot
    }
    
    func setDotWithCount(_ index: Int,_ value: String) {
        if value.count > 0 {
            codeArr[index].text = value
        }else{
            codeArr[index].text = value
        }
    }
    
    func clean() {
        for (_,dot) in codeArr.enumerated() {
            codeText.text = ""
            dot.text = ""
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if keyBoardType == .otherPad {
            textField.keyboardType = .asciiCapable
        }else {
            textField.keyboardType = .numberPad
        }
        if textField.text?.count == codeCount {
            if delegate != nil {
                delegate?.zxCodeViewCode(codeView: self, code: textField.text!)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        codeText.becomeFirstResponder()
    }
    
    func resignResponder() {
        codeText.resignFirstResponder()
    }
}

extension ZXCodeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 0 {
            if (((textField.text?.count)! >= codeCount) && (string.count > 0)) {
                return false
            }else{
                self.setDotWithCount((textField.text?.count)!,string)
            }
        }else{
            self.setDotWithCount((textField.text?.count)! - 1,string)
        }
        return true
    }
}

