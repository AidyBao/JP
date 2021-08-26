//
//  JXSchoolDetailViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXSchoolDetailViewController: ZXUIViewController {
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var contentLB: UILabel!
    var model: JXSchoolVideoModel? = nil
    
    static func show(superV: UIViewController, model: JXSchoolVideoModel?) {
        let vc = JXSchoolDetailViewController()
        vc.model = model
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "详情"
        
        self.view.backgroundColor = UIColor.zx_lightGray
        
        self.titleLB.textColor = UIColor.zx_textColorTitle
        self.titleLB.font = UIFont.zx_bodyFont
        
        self.contentLB.textColor = UIColor.zx_textColorBody
        self.contentLB.font = UIFont.zx_bodyFont
        
        if let mod = model {
            self.titleLB.text = mod.describes
            self.contentLB.text = mod.content
        }
    }


}
