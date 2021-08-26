//
//  JXSchoolVideoViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXSchoolVideoViewController: ZXUIViewController {
    @IBOutlet weak var clvview: UICollectionView!
    var currentIndex:NSInteger = 1
    var totalPageNum:NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.zx_lightGray
        self.clvview.backgroundColor = UIColor.zx_lightGray
        self.clvview.register(UINib(nibName: JXSchoolVideoCell.NibName, bundle: nil), forCellWithReuseIdentifier: JXSchoolVideoCell.reuseIdentifier)
        self.setRefresh()
        self.refreshForHeader()
    }
    
    func setRefresh() ->Void{
        self.clvview.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.clvview.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    @objc func refreshForHeader() -> Void{
        self.currentIndex = 1
        self.jx_requestForSchool(showHUD: true)
    }
    
    @objc func refreshForFooter() -> Void{
        self.currentIndex += 1
        self.jx_requestForSchool(showHUD: false)
    }


    override func zx_reloadAction() {
        self.jx_requestForSchool(showHUD: false)
    }
    
    lazy var listModel: Array<JXSchoolVideoModel> = {
        let list: Array<JXSchoolVideoModel> = []
        return list
    }()
}

extension JXSchoolVideoViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXSchoolVideoCell.reuseIdentifier, for: indexPath) as! JXSchoolVideoCell
        cell.loadData(model: self.listModel[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listModel.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension JXSchoolVideoViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mod = self.listModel[indexPath.row]
        JXVideoDetailViewController.show(superV: self, videoUrl: mod.videoUrl, title: mod.content)
    }
}

extension JXSchoolVideoViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (ZX_BOUNDS_WIDTH - 2 * 15 - 15) / 2
        return CGSize(width: width, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension JXSchoolVideoViewController {
    func jx_requestForSchool(showHUD: Bool) {
        if showHUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZX.HUDDelay)
        }
        JXSchoolManager.jx_school(pageNum: self.currentIndex, pageSize: ZX.PageSize, isAsc: "", lastId: 0, orderByColumn: "", type: 0) { (success, code, listModel, errorMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.clvview, animated: true)
            self.clvview.mj_header?.endRefreshing()
            self.clvview.mj_footer?.endRefreshing()
            ZXEmptyView.hide(from: self.clvview)
            ZXEmptyView.hide(from: self.view)
            if success {
                if let listModel = listModel,listModel.count > 0 {
                    if self.currentIndex == 1 {
                        self.listModel = listModel
                    }else{
                        self.listModel.append(contentsOf: listModel)
                        if listModel.count < ZX.PageSize {
                            self.clvview.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }
                } else {
                    self.clvview.mj_footer?.endRefreshingWithNoMoreData()
                    if self.currentIndex == 1 {
                       ZXEmptyView.show(in: self.clvview, type: .noData, text: "暂时教程哦", subText: nil)
                    }
                }
                self.clvview.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID {
                if self.currentIndex == 1 {
                    ZXEmptyView.show(in: self.clvview, type: .networkError, text: nil, subText: "", topOffset: 0, retry: {
                        self.jx_requestForSchool(showHUD: true)
                    })
                } else {
                    ZXHUD.showFailure(in: self.clvview, text: errorMsg, delay: ZX.HUDDelay)
                }
            }
        }
    }
}
