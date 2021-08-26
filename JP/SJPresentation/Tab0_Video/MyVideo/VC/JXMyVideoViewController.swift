//
//  JXMyVideoViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/24.
//

import UIKit

import Foundation
import HandyJSON

enum JXMyVideoStatus: Int, HandyJSONEnum {
    case waiting    =   1 //审核中
    case pass       =   2 //通过
    case fail       = 4   //未通过
    case defaul     = 9999
    
    func jx_headerDesc() -> String {
        switch self {
        case .waiting:
            return "审核中"
        case .pass:
            return "通过"
        case .fail:
            return "未通过"
        default:
            return ""
        }
    }
}

class JXMyVideoViewController: ZXUIViewController {
    fileprivate var videoStatus: JXMyVideoStatus {
        switch self.type {
        case .waiting:
            return .waiting
        case .pass:
            return .pass
        case .fail:
            return .fail
        case .defaul:
            return .defaul
        }
    }
    
    
    @IBOutlet weak var clvview: UICollectionView!
    var pageIndex:NSInteger = 1
    var totalPageNum:NSInteger = 0
    
    var type: JXMyVideoStatus = .defaul
    var videoList: Array<JXMyVideoModel?> = []
    
    static func show(superV: UIViewController) {
        let vc = JXMyVideoViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.zx_lightGray
        self.clvview.backgroundColor = UIColor.zx_lightGray
        self.clvview.register(UINib(nibName: JXMyVideoCell.NibName, bundle: nil), forCellWithReuseIdentifier: JXMyVideoCell.reuseIdentifier)
        self.setRefresh()
    }
    
    func setRefresh() ->Void{
        self.clvview.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(zx_refresh))
        self.clvview.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(zx_loadmore))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            self.jx_videoList(showHUD:true)
        }
    }
    
    override func zx_reloadAction() {
        if self.videoList.count  == 0 {
            if zx_firstLoad {
                self.jx_videoList(showHUD:true)
                zx_firstLoad = false
            } else {
                self.jx_videoList(showHUD:false)
            }
        }
    }
    
    override func zx_refresh() {
        pageIndex = 1
        self.clvview.mj_footer?.resetNoMoreData()
        self.jx_videoList(showHUD:false)
    }
    
    override func zx_loadmore() {
        pageIndex += 1
        self.jx_videoList(showHUD:false)
    }
}

extension JXMyVideoViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXMyVideoCell.reuseIdentifier, for: indexPath) as! JXMyVideoCell
        cell.loadData(model: self.videoList[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videoList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension JXMyVideoViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let mod = self.videoList[indexPath.row] {
            JXMyVideoPlayerViewController.show(superV: self, videoUrl: mod.videoUrl, title: mod.videoName, videoId: mod.videoId) {
                self.jx_videoList(showHUD: false)
            }
        }
    }
}

extension JXMyVideoViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (ZX_BOUNDS_WIDTH - 2 * 2) / 3
        return CGSize(width: width, height: width*1.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

extension JXMyVideoViewController {
    func jx_videoList(showHUD: Bool = false) {
        if showHUD {
            ZXHUD.showLoading(in: self.view, text: "", delay: 0)
        }
        JXMyVideoManager.videoList(url: ZXAPIConst.Video.myVideo, status: self.videoStatus, pageNum: self.pageIndex, pageSize: ZX.PageSize) { (success, code, mList, info,  errorMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.clvview)
            self.clvview.mj_header?.endRefreshing()
            self.clvview.mj_footer?.endRefreshing()
            if success {
                if let list = mList {
                    if self.pageIndex == 1 {
                        self.videoList.removeAll()
                        self.videoList = list
                        if list.count == 0 {
                            ZXEmptyView.show(in: self.clvview, below: nil, type: .orderEmpty, text: "暂无作品", subText: nil, topOffset: 0, retry: nil)
                        }
                    } else {
                        self.videoList.append(contentsOf: list)
                    }
                    if list.count < ZX.PageSize {
                        self.clvview.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                self.clvview.reloadData()
            } else {
                if self.pageIndex == 1, self.videoList.count == 0 {
                    ZXEmptyView.show(in: self.view, below: nil, type: .networkError, text: nil, subText: nil, topOffset: 0, retry: {
                        self.jx_videoList(showHUD: true)
                    })
                } else {
                    ZXHUD.showFailure(in: self.view, text: errorMsg ?? "", delay: ZXHUD.DelayTime)
                }
            }
        }
    }
}

