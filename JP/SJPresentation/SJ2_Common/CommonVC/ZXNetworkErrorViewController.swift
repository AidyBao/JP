//
//  ZXNetworkErrorViewController.swift
//  PuJin
//
//  Created by 120v on 2019/9/25.
//  Copyright © 2019 ZX. All rights reserved.
//

import UIKit

typealias ZXNetworkErrorCallback = ()

class ZXNetworkErrorViewController: ZXBPushRootViewController {
    
    
    
    @IBOutlet weak var nav1H: NSLayoutConstraint!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var subTitleLB: UILabel!
    @IBOutlet weak var tryBtn: UIButton!
    

    static func show(superView: UIViewController) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.zx_isX() {
            self.nav1H.constant = 44
        }else{
            self.nav1H.constant = 20
        }
        
        self.subTitleLB.font = UIFont(name:"SourceHanSansCN-Medium", size:18)
        self.subTitleLB.textColor = UIColor.zx_colorWithHexString("#343434")
        
        self.subTitleLB.font = UIFont(name:"SourceHanSansCN-Regular", size:18)
        self.subTitleLB.textColor = UIColor.zx_colorWithHexString("#5585FF")
        
        let layer = CAGradientLayer.zx_CustomLayer(bounds: CGRect(x: self.tryBtn.bounds.origin.x, y: self.tryBtn.bounds.origin.y, width: ZXBOUNDS_WIDTH - 63*2, height: 36))
        self.tryBtn.layer.insertSublayer(layer, at: 0)
        self.tryBtn.layer.cornerRadius = 18
        self.tryBtn.layer.masksToBounds = true
        self.tryBtn.titleLabel?.font = UIFont(name:"SourceHanSansCN-Bold", size:18)
        self.tryBtn.setTitle("刷新试试", for: .normal)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
