//
//  JXMyVideoRootViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/29.
//

import UIKit

class JXMyVideoRootViewController: ZXUIViewController {
    
    let menuTitles = ["审核中", "已通过", "未通过"]
    
    static func show(superV: UIViewController) {
        let vc = JXMyVideoRootViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的作品"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        let segmentMenuPage = ZXSegmentMenuPage(frame: UIScreen.main.bounds, menuHeight: 40, menuCountAtOnePage: menuTitles.count, parentController: self, hasNavBar: true)
        segmentMenuPage.delegate = self
        segmentMenuPage.dataSource = self
        segmentMenuPage.config.hudColor = UIColor.zx_tintColor
        segmentMenuPage.config.highLightedTextColor = UIColor.zx_tintColor
        segmentMenuPage.selectedIndex = 0
        self.view.addSubview(segmentMenuPage)
    }
}

extension JXMyVideoRootViewController: ZXSegmentMenuPageDataSource {
    func zxSegmentMenuPage(menuPage: ZXSegmentMenuPage, viewAt index: Int) -> UIView {
        let controller = JXMyVideoViewController()
        switch index {
        case 0:
            controller.type = .waiting
        case 1:
            controller.type = .pass
        case 2:
            controller.type = .fail
        default:
            break
        }
        return controller.view
    }
    
    func zxSegmentMenuPage(menuPage: ZXSegmentMenuPage, titleFor index: Int) -> String {
        return menuTitles[index]
    }
    
    func numberOfPageInzxSegmentMenuPage(menuPage: ZXSegmentMenuPage) -> Int {
        return menuTitles.count
    }
}

extension JXMyVideoRootViewController: ZXSegmentMenuPageDelegate {
    func zxSegmentMenuPage(menuPage: ZXSegmentMenuPage, selectedAt index: Int) {
        if let vc = menuPage.childViewControllers[index] as? JXMyVideoViewController {
            vc.zx_reloadAction()
        }
    }
}
