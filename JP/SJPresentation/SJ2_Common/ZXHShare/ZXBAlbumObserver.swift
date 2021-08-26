//
//  ZXBAlbumObserver.swift
//  AGG
//
//  Created by 120v on 2019/6/17.
//  Copyright © 2019 screson. All rights reserved.
//

import UIKit
import AssetsLibrary
import PhotosUI
import Photos

class ZXBAlbumObserver: NSObject {
    
    //取得的资源结果，用来存放的PHAsset
    var assetsFetchResults:PHFetchResult<PHAsset>!
    
    //带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    //用于显示缩略图
    var imageView: UIImageView!
    
    //缩略图大小
    var assetGridThumbnailSize:CGSize!
    
    func getImageGroup() {
        //申请权限
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                return
            }
            
            //启动后先获取目前所有照片资源
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                     PHAssetMediaType.image.rawValue)
            self.assetsFetchResults = PHAsset.fetchAssets(with: .image,
                                                          options: allPhotosOptions)
            print("--- 资源获取完毕 ---")
            
            //监听资源改变
            PHPhotoLibrary.shared().register(self)
        })
    }
}


//PHPhotoLibraryChangeObserver代理实现，图片新增、删除、修改开始后会触发
extension ZXBAlbumObserver:PHPhotoLibraryChangeObserver{
    
    //当照片库发生变化的时候会触发
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
                print("--- 监听到变化 ---")
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
                    print("新增了\(insertedIndexes.count)张照片")
                    print("将最新一张照片的缩略图显示在界面上。")
                    
                    //获取最后添加的图片资源
                    let asset = self.assetsFetchResults[insertedIndexes.first!]
                    //获取缩略图
                    self.imageManager.requestImage(for: asset,
                                                   targetSize: self.assetGridThumbnailSize,
                                                   contentMode: .aspectFill, options: nil) {
                                                    (image, nfo) in
                                                    self.imageView.image = image
                    }
                }
            }
        }
    }
}
