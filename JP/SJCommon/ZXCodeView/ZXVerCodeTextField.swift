//
//  ZXVerCodeTextField.swift
//  FindCar
//
//  Created by 120v on 2017/12/27.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

protocol ZXVerCodeTextFieldDelegate {
    func didDeleteBackward()
}

class ZXVerCodeTextField: UITextField {

    var delgate:ZXVerCodeTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        delgate?.didDeleteBackward()
    }
}
