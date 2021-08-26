//
//  JXTaskFinishViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/28.
//

import UIKit

class JXTaskFinishViewController: ZXBPushRootViewController {
    
    override var zx_dismissTapOutSideView: UIView? {return contentView}

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    fileprivate var succ: Bool = false
    fileprivate var count: String = ""
    
    static func show(superV: UIViewController, succ: Bool, count: String = "") {
        let vc = JXTaskFinishViewController()
        vc.succ = succ
        vc.count = count
        superV.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.lb1.font = UIFont.zx_bodyFont
        self.lb1.textColor = UIColor.white
        
        self.lb2.font = UIFont.zx_bodyFont
        self.lb2.textColor = UIColor.white
        self.lb2.text = count
        
        if succ {
            imgV.image = UIImage(named: "jx_gettg_succ")
            self.lb1.isHidden = false
            self.lb2.isHidden = false
        }else{
            imgV.image = UIImage(named: "jx_gettg_fail")
            self.lb1.isHidden = true
            self.lb2.isHidden = true
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
