//
//  JXCardsMainViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/9.
//

import UIKit
import JXSegmentedView

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

class JXCardsMainViewController: ZXUIViewController {
    var pagingView: JXPagingView!
    var userHeaderView: JXCardHeaderView!
    var userHeaderContainerView: UIView!
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    var vcLists = Array<JXCardListViewController>()
    var JXTableHeaderViewHeight: Int = 250
    var JXheightForHeaderInSection: Int = 40
    var currentIndex:NSInteger = 1
    var taskType: Int = 0

    static func show(superV: UIViewController) {
        let vc = JXCardsMainViewController()
        vc.hidesBottomBarWhenPushed = true
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "任务卡"
        
        for index in 0..<vcTitles.count {
            let vc = JXCardListViewController()
            vc.taskType = index
            vcLists.append(vc)
        }

        userHeaderContainerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXTableHeaderViewHeight)))
        userHeaderView = JXCardHeaderView.loadNib()
        userHeaderView.delegate = self
        userHeaderView.setFrame(frame: userHeaderContainerView.bounds)
        userHeaderContainerView.addSubview(userHeaderView)

        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = self.vcTitles
        segmentedViewDataSource.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        segmentedViewDataSource.titleNormalColor = UIColor.black
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isTitleZoomEnabled = true

        segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.delegate = self
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false

        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        lineView.indicatorWidth = 30
        segmentedView.indicators = [lineView]

        let lineWidth = 1/UIScreen.main.scale
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.lightGray.cgColor
        lineLayer.frame = CGRect(x: 0, y: segmentedView.bounds.height - lineWidth, width: segmentedView.bounds.width, height: lineWidth)
        segmentedView.layer.addSublayer(lineLayer)

        pagingView = JXPagingView(delegate: self)

        self.view.addSubview(pagingView)
        
        segmentedView.listContainer = pagingView.listContainerView

        self.requestForBuyCardNotice()
        
        self.setRefresh()
    }
    
    
    func setRefresh() ->Void{
        self.pagingView.mainTableView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
    }
    
    @objc func refreshForHeader() -> Void{
        self.pagingView.mainTableView.mj_header?.endRefreshing()
        self.currentIndex = 1
        let vc = vcLists[taskType]
        
        var newType: Int = 0
        if taskType != 0 {
            newType = taskType + 1
        }
        vc.jx_reloadAction(type: newType, currentIndex: self.currentIndex)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = self.view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.zx_tintColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }

    lazy var vcTitles: Array<String> = {
        var list: Array<String> = []
        list = ["任务卡","进行中","已完成"]
        return list
    }()
    
    
    lazy var noticeList: Array<JXCardNoticeModel> = {
        let list: Array<JXCardNoticeModel> = []
        return list
    }()
    
    lazy var listModel: Array<JXCardLevelModel> = {
        let list: Array<JXCardLevelModel> = []
        return list
    }()

}


extension JXCardsMainViewController: JXCardHeaderViewDelegate {
    func didBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didGoExchangList() {
        JXCardsChangeListViewController.show(superv: self, notices: self.noticeList) {
            self.segmentedView.selectItemAt(index: 0)
        }
    }
}

extension JXCardsMainViewController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return userHeaderContainerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return JXheightForHeaderInSection
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return self.vcTitles.count
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
//        let list = JXCardListViewController()
//        list.jx_reloadAction(type: index)
        
        let vc = vcLists[index]
        
        return vc
    }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
//        userHeaderView?.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }
}
extension JXCardsMainViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        let vc = vcLists[index]
        var newIndex = 0
        if index != 0 {
            newIndex = index + 1
        }
        taskType = index
        vc.jx_reloadAction(type: newIndex, currentIndex: self.currentIndex)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool {
        return true
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        
    }
}

