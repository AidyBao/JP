//
//  JXShcoolViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXShcoolViewController: ZXUIViewController {

    let menuTitles = ["视频", "教程"]
    
    static func show(superV: UIViewController) {
        let vc = JXShcoolViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "商学院"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.zx_lightGray
        let segmentMenuPage = ZXSegmentMenuPage(frame: UIScreen.main.bounds, menuHeight: 40, menuCountAtOnePage: menuTitles.count, parentController: self, hasNavBar: true)
        segmentMenuPage.delegate = self
        segmentMenuPage.dataSource = self
        segmentMenuPage.backgroundColor = UIColor.zx_lightGray
        segmentMenuPage.config.hudColor = UIColor.zx_tintColor
        segmentMenuPage.config.highLightedTextColor = UIColor.zx_tintColor
        segmentMenuPage.selectedIndex = 0
        self.view.addSubview(segmentMenuPage)
    }
}

extension JXShcoolViewController: ZXSegmentMenuPageDataSource {
    func zxSegmentMenuPage(menuPage: ZXSegmentMenuPage, viewAt index: Int) -> UIView {
        switch index {
        case 0:
            let controller = JXSchoolVideoViewController()
            return controller.view
        case 1:
            let controller = JXSchoolCourseViewController()
            return controller.view
        default:
            break
        }
        return UIView()
    }
    
    func zxSegmentMenuPage(menuPage: ZXSegmentMenuPage, titleFor index: Int) -> String {
        return menuTitles[index]
    }
    
    func numberOfPageInzxSegmentMenuPage(menuPage: ZXSegmentMenuPage) -> Int {
        return menuTitles.count
    }
}

extension JXShcoolViewController: ZXSegmentMenuPageDelegate {
    func zxSegmentMenuPage(menuPage: ZXSegmentMenuPage, selectedAt index: Int) {
        if let vc = menuPage.childViewControllers[index] as? JXSchoolVideoViewController {
            vc.zx_reloadAction()
        }
        
        if let vc = menuPage.childViewControllers[index] as? JXSchoolCourseViewController {
            vc.zx_reloadAction()
        }
    }
}

