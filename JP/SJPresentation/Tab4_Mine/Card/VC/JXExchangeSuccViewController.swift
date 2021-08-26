//
//  JXExchangeSuccViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/10.
//

import UIKit

class JXExchangeSuccViewController: ZXBPushRootViewController {
    override var zx_dismissTapOutSideView: UIView? {return bgview}
    
    @IBOutlet weak var bgview: UIView!
    
    static func show(superv: UIViewController) {
        let vc = JXExchangeSuccViewController()
        superv.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true
    }

    @IBAction func confirm(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
