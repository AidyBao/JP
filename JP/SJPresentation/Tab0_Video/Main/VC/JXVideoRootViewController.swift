//
//  JXVideoRootViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/30.
//

import UIKit

class JXVideoRootViewController: ZXUIViewController {
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    
    let menuTitles = ["推荐", "同城"]
    
    static func show(superV: UIViewController) {
        let vc = JXOrderRootViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fd_prefersNavigationBarHidden = true
        
        if #available(iOS 11, *) {
            
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        //
        self.view.backgroundColor = UIColor.white
        let segmentMenuPage = JXVideoSegment(frame: UIScreen.main.bounds, menuHeight: 40, menuCountAtOnePage: menuTitles.count, parentController: self, hasNavBar: true, isEnabledScroll: false)
        segmentMenuPage.delegate = self
        segmentMenuPage.dataSource = self
        segmentMenuPage.config.hudColor = UIColor.white
        segmentMenuPage.config.highLightedTextColor = UIColor.white
        segmentMenuPage.selectedIndex = 0
        self.view.addSubview(segmentMenuPage)
    }
}

extension JXVideoRootViewController: JXVideoSegmentDataSource {
    func zxSegmentMenuPage(menuPage: JXVideoSegment, viewAt index: Int) -> UIView {
        let controller = JXRecommentViewController()

        return controller.view
    }
    
    func zxSegmentMenuPage(menuPage: JXVideoSegment, titleFor index: Int) -> String {
        return menuTitles[index]
    }
    
    func numberOfPageInzxSegmentMenuPage(menuPage: JXVideoSegment) -> Int {
        return menuTitles.count
    }
}

extension JXVideoRootViewController: JXVideoSegmentDelegate {
    func zxSegmentMenuPage(menuPage: JXVideoSegment, selectedAt index: Int) {
        
    }
}
