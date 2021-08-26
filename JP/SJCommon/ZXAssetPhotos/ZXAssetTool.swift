//
//  ZXAssetTool.swift
//  AGG
//
//  Created by 120v on 2019/6/19.
//  Copyright © 2019 screson. All rights reserved.
//

import UIKit
import Photos

typealias ZXAssetToolCallback = (PHAuthorizationStatus,UIImage?) ->Void

class ZXAssetTool: NSObject {
    static let share    =  ZXAssetTool()
    var assetsFetchResults:PHFetchResult<PHAsset>? = nil
    var zxAssetCallback:ZXAssetToolCallback?       = nil
    var zx_status: PHAuthorizationStatus           = .notDetermined
    
    static func zx_getAssetPhotos(zxAssetCallback: ZXAssetToolCallback?) {
        ZXAssetTool.share.zxAssetCallback = zxAssetCallback
        //申请权限
        PHPhotoLibrary.requestAuthorization({ (status) in
            ZXAssetTool.share.zx_status = status
            if status == .authorized {
                //启动后先获取目前所有照片资源
                let allPhotosOptions = PHFetchOptions()
                allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
                allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",PHAssetMediaType.image.rawValue)
                ZXAssetTool.share.assetsFetchResults = PHAsset.fetchAssets(with: .image,options: allPhotosOptions)
                //监听资源改变
                PHPhotoLibrary.shared().register(ZXAssetTool.share)
            }else{
                ZXAssetTool.share.zxAssetCallback?(status, nil)
            }
        })
    }
}

extension ZXAssetTool: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        //获取assetsFetchResults的所有变化情况，以及assetsFetchResults的成员变化前后的数据
        guard let collectionChanges = changeInstance.changeDetails(for:
            self.assetsFetchResults as! PHFetchResult<PHObject>) else { return }
        
        DispatchQueue.main.async {
            //获取最新的完整数据
            if let allResult = collectionChanges.fetchResultAfterChanges
                as? PHFetchResult<PHAsset>{
                self.assetsFetchResults = allResult
            }
            
            if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves{
                return
            }else{
                 //照片删除情况
                if let removedIndexes = collectionChanges.removedIndexes,
                    removedIndexes.count > 0{
                    print("删除了\(removedIndexes.count)张照片")
                }
                //照片修改情况
                if let changedIndexes = collectionChanges.changedIndexes,
                    changedIndexes.count > 0{
                    print("修改了\(changedIndexes.count)张照片")
                }
                //照片新增情况
                if let insertedIndexes = collectionChanges.insertedIndexes,
                    insertedIndexes.count > 0{
                    //获取最后添加的图片资源
                    if let assetResults = self.assetsFetchResults {
                        let asset = assetResults[insertedIndexes.first!]
                        //获取缩略图
                        let imageManager = PHCachingImageManager()
                        imageManager.requestImage(for: asset, targetSize: UIScreen.main.bounds.size, contentMode: .aspectFill, options: nil) { (rImage, info) in
                            if let rImg = rImage {
                                ZXAssetTool.share.zxAssetCallback?(ZXAssetTool.share.zx_status, rImg)
                            }
                        }
                    }
                }
            }
        }
    }
}
