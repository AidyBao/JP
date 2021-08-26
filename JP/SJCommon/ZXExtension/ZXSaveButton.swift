//
//  ZXSaveButton.swift
//  PuJin
//
//  Created by 120v on 2019/7/12.
//  Copyright © 2019 ZX. All rights reserved.
//

import UIKit

class ZXSaveButton: ZXUIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = UIColor.zx_disableColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isEnabled {
            self.backgroundColor = UIColor.zx_tintColor
        }else{
            self.setBackgroundImage(UIImage(named: ""), for: .normal)
            self.backgroundColor = UIColor.zx_disableColor
        }
    }
}
