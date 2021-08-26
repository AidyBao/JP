//
//  SJVideoMainViewController.swift
//  gold
//
//  Created by 成都世纪星成网络科技有限公司 on 2021/3/26.
//

import UIKit
import JXSegmentedView

class SJVideoMainViewController: ZXUIViewController {

    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    let menuTitles = ["推荐", "同城"]
    var sdataSource: JXSegmentedTitleDataSource?
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    var segmentedView:JXSegmentedView!
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    static func show(superV: UIViewController) {
        let vc = SJVideoMainViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.navigationItem.title = "首页"
        
        self.view.backgroundColor = .white
        
        if #available(iOS 11, *) {
            
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }

        
        jx_getUserInfo()
        
        addSegment()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    func addSegment() {

        //配置数据源
        sdataSource = JXSegmentedTitleDataSource()
        sdataSource?.titles = self.vcTitles
        sdataSource?.isTitleColorGradientEnabled = true
        sdataSource?.isTitleZoomEnabled = true
        sdataSource?.titleSelectedZoomScale = 1.3
        sdataSource?.isTitleStrokeWidthEnabled = true
        sdataSource?.isSelectedAnimable = true
        sdataSource?.titleSelectedFont = UIFont.zx_bodyFont
        sdataSource?.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        sdataSource?.titleNormalFont = UIFont.zx_bodyFont
        sdataSource?.titleNormalColor = UIColor.zx_lightGray
        
        segmentedView = JXSegmentedView(frame: CGRect(x: ZXBOUNDS_WIDTH*(1-0.4)*0.5, y: 100, width: UIScreen.main.bounds.size.width * 0.4, height:50))
        segmentedView.backgroundColor = UIColor.red
        segmentedView.delegate = self
        segmentedView.dataSource = sdataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        self.view.addSubview(segmentedView)
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthen
        indicator.indicatorColor = .white
        indicator.indicatorHeight = 3
        indicator.indicatorCornerRadius = 2
        self.segmentedView.indicators = [indicator]

        listContainerView.contentScrollView().isScrollEnabled = false
        let height = self.tabBarController?.tabBar.frame.size.height ?? 64
        listContainerView.frame = CGRect(x: 0, y: 100, width: ZXBOUNDS_WIDTH, height: ZXBOUNDS_HEIGHT - height)
        self.segmentedView.listContainer = listContainerView
        self.view.addSubview(self.listContainerView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    lazy var vcTitles: Array<String> = {
        var list: Array<String> = []
        list = ["推荐","同城"]
        return list
    }()
}

extension SJVideoMainViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
}

extension SJVideoMainViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return self.vcTitles.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = JXRecommentViewController()
        return vc
    }
}

extension SJVideoMainViewController {
    func jx_getUserInfo() {
        if !ZXToken.token.access_token.isEmpty {
            ZXLoginManager.jx_getUserInfo(urlString: ZXAPIConst.User.userInfo) { (succ, code, model, errMs) in
                
            } zxFailed: { (code, errMsg) in
                
            }
        }
    }
}
