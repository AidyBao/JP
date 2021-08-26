//
//  JXVideoListViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/25.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos
import HandyJSON


class JXVideoListViewController: ZXUIViewController {
    
    @IBOutlet weak var clvview: UICollectionView!
    fileprivate var selectedModel: JXAlbumVideo?
    
    static func show(superV: UIViewController) {
        let vc = JXVideoListViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "视频选择"
        
        self.zx_addNavBarButtonItems(textNames: ["下一步"], font: UIFont.zx_bodyFont, color: UIColor.red, at: .right)
        
        self.view.backgroundColor = UIColor.black
        self.clvview.backgroundColor = UIColor.black
        self.clvview.register(UINib(nibName: JXAlbumVideoCell.NibName, bundle: nil), forCellWithReuseIdentifier: JXAlbumVideoCell.reuseIdentifier)
        self.clvview.register(UINib(nibName: JXVideoPreviewCell.NibName, bundle: nil), forCellWithReuseIdentifier: JXVideoPreviewCell.reuseIdentifier)
        
        self.getVideos()
        
    }
    
    func getVideos() {
        DispatchQueue.main.async {
            FileManager.ZXVideo.getPotoVideo { videos in
                if videos.count > 0 {
                    self.videoList = videos
                    DispatchQueue.main.async {
                        self.clvview.reloadData()
                    }
                }else{
                    ZXHUD.showFailure(in: ZXRootController.appWindow()!, text: "暂无视频资源", delay: ZXHUD.DelayTime)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    override func zx_rightBarButtonAction(index: Int) {
        if let mod = selectedModel {
            if mod.videoLength < 200 {
                JXVideoDescriptionViewController.show(superV: self, videoInfo: mod)
            }else{
                ZXHUD.showFailure(in: self.view, text: "上传视频不能大于200M哦", delay: ZXHUD.DelayOne)
            }
        }
    }
  
    
    lazy var videoList: Array<JXAlbumVideo?> = {
        let list: Array<JXAlbumVideo> = []
        return list
    }()
}



extension JXVideoListViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXVideoPreviewCell.reuseIdentifier, for: indexPath) as! JXVideoPreviewCell
            if indexPath.row == 0, self.videoList.count > 0 {
                cell.loadData(model: self.videoList[0])
                selectedModel = self.videoList[0]
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXAlbumVideoCell.reuseIdentifier, for: indexPath) as! JXAlbumVideoCell
            cell.loadData(model: self.videoList[indexPath.row])
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXAlbumVideoCell.reuseIdentifier, for: indexPath) as! JXAlbumVideoCell
            cell.loadData(model: self.videoList[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return self.videoList.count
        }else {
            return 1
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}

extension JXVideoListViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            let mod = self.videoList[indexPath.row]
            self.selectedModel = mod
            guard let preCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? JXVideoPreviewCell else {
                return
            }
            preCell.loadData(model: mod)
        default:
            break
        }
    }
}

extension JXVideoListViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = (ZX_BOUNDS_WIDTH)
            return CGSize(width: width, height: width*1.2)
        }else{
            let width = (ZX_BOUNDS_WIDTH - 2 * 2) / 3
            return CGSize(width: width, height: width*1.1)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            return 2
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            return 2
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
}
