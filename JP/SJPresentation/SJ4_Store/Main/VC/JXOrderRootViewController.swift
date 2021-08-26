//
//  JXOrderRootViewController.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/5.
//

import UIKit

//0-全部 1-待付款 2-待发货 3-待收货 4-已完成
/// 订单列表分组界面
class JXOrderRootViewController: ZXUIViewController {
    
    let menuTitles = ["全部", "待付款", "待发货", "已完成"]
    
    static func show(superV: UIViewController) {
        let vc = JXOrderRootViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的订单"
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

extension JXOrderRootViewController: ZXSegmentMenuPageDataSource {
    func zxSegmentMenuPage(menuPage: ZXSegmentMenuPage, viewAt index: Int) -> UIView {
        let controller = JXOrderListViewController()
        switch index {
        case 0:
            controller.type = .all
        case 1:
            controller.type = .waitPay
        case 2:
            controller.type = .paid
        case 3:
            controller.type = .finish
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

extension JXOrderRootViewController: ZXSegmentMenuPageDelegate {
    func zxSegmentMenuPage(menuPage: ZXSegmentMenuPage, selectedAt index: Int) {
        if let vc = menuPage.childViewControllers[index] as? JXOrderListViewController {
            vc.zx_reloadAction()
        }
    }
}
