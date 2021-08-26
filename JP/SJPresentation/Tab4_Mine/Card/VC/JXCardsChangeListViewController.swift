//
//  JXCardsChangeListViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/9.
//

import UIKit

typealias JXCardsChangeListCallback = () -> Void

class JXCardsChangeListViewController: ZXBPushRootViewController {
    
    override var zx_dismissTapOutSideView: UIView {
        return bgview
    }

    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var recordContentView: UIView!

    fileprivate var winnerList: ZXWinnerScrollView!
    fileprivate var nList: Array<JXCardNoticeModel> = []
    fileprivate var zxCallback:JXCardsChangeListCallback? = nil
    
    static func show(superv: UIViewController, notices: Array<JXCardNoticeModel>, callback: JXCardsChangeListCallback?) {
        let vc = JXCardsChangeListViewController()
        vc.nList = notices
        vc.zxCallback = callback
        superv.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true

        winnerList = ZXWinnerScrollView.init(origin: CGPoint(x: 10, y: 15), width: UIScreen.main.bounds.size.width - 40, pageSize: 4, type: 1)
        self.recordContentView.addSubview(winnerList)
        
        self.winnerList.reloadData(nList)
    }
    @IBAction func exchange(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.zxCallback?()
        })
    }
    
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
