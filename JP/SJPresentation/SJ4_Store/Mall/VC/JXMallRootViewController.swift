//
//  JXMallRootViewController.swift
//  gold
//
//  Created by SJXC on 2021/8/19.
//

import UIKit

class JXMallRootViewController: ZXUIViewController {

    @IBOutlet weak var clvview: UICollectionView!
    fileprivate var selectedModel: JXAlbumVideo?
    var currentPage = 1
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = false
    }
    
    static func show(superV: UIViewController) {
        let vc = JXMallRootViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "积分商城"
        
        self.view.backgroundColor = UIColor.white
        self.clvview.backgroundColor = UIColor.white
        self.clvview.register(UINib(nibName: JXMallRootCell.NibName, bundle: nil), forCellWithReuseIdentifier: JXMallRootCell.reuseIdentifier)
        self.clvview.register(UINib(nibName: JXMallBannerCell.NibName, bundle: nil), forCellWithReuseIdentifier: JXMallBannerCell.reuseIdentifier)
        
        self.clvview.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(zx_refresh), whiteColor: false)
        self.clvview.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(zx_loadmore))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            self.jx_mall(true)
        }
    }

    //MARK: - 下拉刷新
    override func zx_refresh() {
        currentPage = 1
        self.jx_mall(false)
    }
    //MARK: - 加载更多
    override func zx_loadmore() {
        currentPage = 1
        self.jx_mall(false)
    }
  
    
    lazy var dataSoure: Array<JXMallDetailModel?> = {
        let list: Array<JXMallDetailModel> = []
        return list
    }()
}



extension JXMallRootViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXMallBannerCell.reuseIdentifier, for: indexPath) as! JXMallBannerCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXMallRootCell.reuseIdentifier, for: indexPath) as! JXMallRootCell
            cell.loadData(model: self.dataSoure[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXMallRootCell.reuseIdentifier, for: indexPath) as! JXMallRootCell
            cell.loadData(model: self.dataSoure[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return self.dataSoure.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension JXMallRootViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
}

extension JXMallRootViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ZX_BOUNDS_WIDTH, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = (ZX_BOUNDS_WIDTH)
            return CGSize(width: width, height: 90)
        }else{
            let width = (ZX_BOUNDS_WIDTH - 10 * 2 - 10*2) / 3
            return CGSize(width: width, height: 240)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }else{
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }else{
            return 10
        }
    }
}

extension JXMallRootViewController {
    func jx_mall(_ showHUD: Bool) {
        if showHUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        }
        JXMallManager.jx_mallList(url: ZXAPIConst.Shop.goods, pageNum: currentPage, pageSize: ZX.PageSize) { code, success, listModel, errorMsg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXCommonUtils.showNetworkActivityIndicator(false)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.clvview)
            self.clvview.mj_header?.endRefreshing()
            self.clvview.mj_footer?.endRefreshing()
            self.clvview.mj_footer?.resetNoMoreData()
            if success {
                if self.currentPage == 1 {
                    self.dataSoure.removeAll()
                    if let listModel = listModel,listModel.count > 0 {
                        self.dataSoure = listModel
                        //if listModel.count < ZX.PageSize {
                            self.clvview.mj_footer?.endRefreshingWithNoMoreData()
                        //}
                    }else {
                        ZXEmptyView.show(in: self.clvview, type: .noData, text: errorMsg, subText: nil, topOffset: 0)
                        self.clvview.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }else{
                    if let listModel = listModel,listModel.count > 0 {
                        self.dataSoure.append(contentsOf: listModel)
                        if listModel.count < ZX.PageSize {
                            self.clvview.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        self.clvview.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                self.clvview.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID{
                if self.currentPage == 1 {
                    ZXEmptyView.show(in: self.view, below: nil, type: .networkError, text: nil, subText: nil, topOffset: 0, backgroundColor: nil) {
                        self.jx_mall(true)
                    }
                }else{
                    ZXHUD.showFailure(in: self.view, text: errorMsg, delay: 1.5)
                }
            }
        }
    }
}
