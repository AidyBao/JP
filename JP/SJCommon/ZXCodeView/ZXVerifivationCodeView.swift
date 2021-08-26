//
//  ZXVerifivationCodeView.swift
//  FindCar
//
//  Created by 120v on 2017/12/27.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit
enum ZXTextKeyBoardType {
    case numberPad
    case otherPad
}

protocol ZXVerifivationCodeViewDelegate {
    func didVerCodeFinished(codeView verCodeView:ZXVerifivationCodeView,verCode code:String)
}

class ZXVerifivationCodeView: UIView {

    /// 代理回调
    var delegate:ZXVerifivationCodeViewDelegate?
    
    /// 一堆框框的数组
    var textfieldarray = [UITextField]()
    
    /// 框框之间的间隔
    var space:CGFloat = 10.0
    
    /// 框框的大小
    var TextW:CGFloat = 60
    
    /// 框框个数
    var count = 4
    
    /// 键盘类型
    var keyBoardType: ZXTextKeyBoardType = .numberPad
    
    /// 构造函数
    ///
    /// - Parameters:
    ///   - frame: frame，宽度最好设置为屏幕宽度
    ///   - num: 框框个数，默认 4 个
    ///   - margin: 框框之间的间距，默认 10
    init(frame: CGRect,number:Int = 4,margin:CGFloat = 10,boardType:ZXTextKeyBoardType) {
        super.init(frame: frame)
        
        self.space = margin
        self.count = number
        self.keyBoardType = boardType
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI(){
        // 不允许用户直接操作验证码框
        self.isUserInteractionEnabled = false
        
        // 计算左间距
        let leftmargin: CGFloat = 0
        
        self.TextW = (self.frame.width - CGFloat((self.count - 1))*self.space)/CGFloat(self.count)
        
        // 创建 n个 UITextFiedl
        for i in 0..<self.count{
            let rect = CGRect(x: leftmargin + CGFloat(i)*self.TextW + CGFloat(i)*space, y: 0, width: self.TextW, height: self.TextW)
            let textField = addTextField(frame: rect)
            textField.tag = i
            textfieldarray.append(textField)
        }
        // 防止搞事
        if self.count < 1 {
            return
        }
        textfieldarray.first?.becomeFirstResponder()
    }
    
    private func addTextField(frame:CGRect)->UITextField{
        let textField = ZXVerCodeTextField(frame: frame)
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 28)
        textField.textColor = UIColor.black
        textField.delegate = self
        textField.delgate = self
        if keyBoardType == .numberPad {
            textField.keyboardType = .numberPad
        }else if keyBoardType == .otherPad {
            textField.keyboardType = .namePhonePad
        }
        addSubview(textField)
        
        let geliView: UIView = UIView.init()
        geliView.center = CGPoint(x: textField.center.x - frame.size.width * 0.5, y: frame.maxY)
        geliView.frame.size.width = frame.size.width
        geliView.frame.size.height = 1.0
        geliView.backgroundColor = UIColor.zx_lightGray
        addSubview(geliView)
        
        return textField
    }
    
    func clean(){
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            for tv in self.textfieldarray {
                tv.text = ""
            }
        }
        textfieldarray.first?.becomeFirstResponder()
    }
}

extension ZXVerifivationCodeView:UITextFieldDelegate,ZXVerCodeTextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !textField.hasText {
            // tag 对应数组下标
            let index = textField.tag
            
//            textField.resignFirstResponder()
            if index == self.count - 1 {
                textfieldarray[index].text = string
                // 拼接结果
                var code = ""
                for tv in textfieldarray{
                    code += tv.text ?? ""
                }
                delegate?.didVerCodeFinished(codeView: self, verCode: code)
                return false
            }
            
            textfieldarray[index].text = string
            
            if keyBoardType == .numberPad {
                textField.keyboardType = .numberPad
            }else if keyBoardType == .otherPad {
                textField.keyboardType = .namePhonePad
            }
            textfieldarray[index + 1].becomeFirstResponder()
        }
        return false
    }
    
    /// 监听键盘删除键
    func didDeleteBackward(){
        for i in 1..<self.count{
            if !textfieldarray[i].isFirstResponder {
                continue
            }
            textfieldarray[i].resignFirstResponder()
            textfieldarray[i-1].becomeFirstResponder()
            textfieldarray[i-1].text = ""
        }
    }
}

