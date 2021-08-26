//
//  FileManager+ZX.swift
//  gold
//
//  Created by SJXC on 2021/4/7.
//

import Foundation
import Photos
import HandyJSON

class JXAlbumVideo: HandyJSON {
    required init() {}
    var image: UIImage?             // 视频封面
    var duration: Double?           // 视频时长
    var asset: PHAsset?             // 操作信息的对象
    var videoUrl: URL?              // 视频本地地址
    var avURLAsset: AVURLAsset?     //
    var avSet: AVAsset?             // 剪辑控制
    var creationDate: Date?         // 视频创建时间
    var tempPath: String?           // 视频保存在本地临时路径
    var videoLength: Int64      = 0 //视频文件大小
}

extension FileManager {
    struct ZXVideo {
        @discardableResult static func videoFolderCheck() -> Bool {
            return createFolder(at: videoCachesPath)
        }
        
        static var videoCachesPath: String {
            get {
                return NSHomeDirectory() + "/Library/JXVideoCaches"
            }
        }
        
        @discardableResult static func saveVideo(_ data:Data?,filename:String) -> Bool {
            if let data = data {
                do {
                    try data.write(to: URL(fileURLWithPath: (self.videoCachesPath + "/\(filename)")))
                    return true
                } catch {
                    return false
                }
            }
            return false
        }
        
        static func tempPath(_ timeStr:String) -> String{
            return videoCachesPath + "/" + timeStr
        }
        
        static func currenTimeStr() -> String{
            return ZXDateUtils.millisecond.dateformat(ZXDateUtils.current.millisecond(), format: "yyyMMdd_HHmmss")
        }
        
        @discardableResult static func createFolder(at path:String) -> Bool{
            let manager = FileManager.default
            if !manager.fileExists(atPath: path) {
                do{
                    try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                    return true
                } catch {
                    return false
                }
            }
            return true
        }
        
        static func removeAll(at path:String) {
            let manager = FileManager.default
            if let fileArray = manager.subpaths(atPath: path) {
                for fn in fileArray {
                    try? manager.removeItem(atPath: path + "/\(fn)")
                }
            }
        }
        
        static func removeItem(_ path:String) {
            let manager = FileManager.default
            try? manager.removeItem(atPath: path)
        }
        
        /**
         *  视频压缩
         *  @param originFilePath       视频资源的原始路径
         *  @param outputPath      输出路径
         */
        static func compressVideoAccroding(originFilePath: URL, outputPath: String, completion:((Data?)->Void)?) {
            let asset = AVURLAsset(url: originFilePath, options: nil)
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
                return
            }
            exportSession.shouldOptimizeForNetworkUse = true
            exportSession.outputURL = URL(fileURLWithPath: outputPath)
            exportSession.outputFileType = .mp4
            exportSession.exportAsynchronously(completionHandler: {
                let exportStatus = exportSession.status
                switch exportStatus {
                    case .failed:
                        print(exportSession.error as Any)
                    case .completed:
                        let url = URL(fileURLWithPath: outputPath)
                        do {
                            let videoData = try Data(contentsOf: url)
                            completion?(videoData)
                        }catch{
                            print("视频输出错误")
                        }
                        break
                    default:
                        break
                }
            })
        }
        
        // 从相册中获取所有视频数组
        static func getPotoVideo(result:((_ list: Array<JXAlbumVideo?>) -> Void)?) {
            DispatchQueue.global(qos: .userInteractive).async {
                var videos: [JXAlbumVideo] = []
                let option = PHVideoRequestOptions()
                option.version = .current
                option.deliveryMode = .automatic
                option.isNetworkAccessAllowed = true
                
                let manager = PHImageManager.default()
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .video, options: nil)
                // 获取视频
                var tempCount = fetchResult.count
                if tempCount > 0 {
                    for i in 0..<fetchResult.count {
                        let asset = fetchResult.object(at: i)
                        manager.requestAVAsset(forVideo: asset, options: option) { (avasset, audioMix, array) in
                            // 为了防止多次回调
                            tempCount = tempCount - 1
                            
                            guard let urlAsset: AVURLAsset = avasset as? AVURLAsset else {
                                if tempCount == 0 {
                                    print("第\(i)获取视频失败")
                                   result?([])
                                }
                                return
                            }
                        
                            let model = JXAlbumVideo()
                            model.asset = asset
                            model.avSet = avasset
                            model.videoUrl = urlAsset.url
                            model.avURLAsset = urlAsset
                            model.duration = CMTimeGetSeconds(urlAsset.duration)
                            model.creationDate = asset.creationDate
                            let list = urlAsset.tracks(withMediaType: .video)
                            for track in list {
                                if track.mediaType == .video {
                                    model.videoLength = track.totalSampleDataLength/1024/1024
                                }
                            }
                            videos.append(model)

                            if tempCount == 0 {
                                // 把视频按照日期排序
                                videos = videos.sorted(by: { (video1, video2) -> Bool in
                                    guard let date1 = video1.creationDate,
                                        let date2 = video2.creationDate else {
                                        return true
                                    }
                                    return date1 > date2
                                })
                                DispatchQueue.main.async {
                                    result?(videos)
                                }
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        result?(videos)
                    }
                }
            }
        }
        
        //导出视频方法一：通过路径直接copy
        static func exportVideoWithCopyPath(videoPath: String) -> String? {
            //创建文件夹
            let success = videoFolderCheck()
            if !success {
                ZXAlertUtils.showAlert(wihtTitle: nil, message: "创建本地文件目录失败,请清除本地缓存后重试", buttonText: "好的", action: {
                    return
                })
            }
            
            let manager = FileManager.default
            let tempPath = tempPath(currenTimeStr()).appending(".mp4")
            if manager.fileExists(atPath: tempPath){
                removeItem(tempPath)
            }
            do {
                try manager.copyItem(atPath: videoPath, toPath: tempPath)
                return tempPath
            }catch{
                print("文件保存到缓存失败")
            }
            return nil
        }
        
        //导出视频方法二：自定义视频导出
        static func startExportVideoWithVideoAsset(videoAsset: AVURLAsset, completion: ((_ outputPath: String) -> Void)?) {
            guard let session = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetMediumQuality) else { return }
            let filePath = self.tempPath(currenTimeStr()).appending(".mp4")
            session.outputURL = URL(fileURLWithPath: filePath)
            session.shouldOptimizeForNetworkUse = true
            session.outputFileType = .mp4
            if FileManager.default.fileExists(atPath: filePath) {
                try? FileManager.default.removeItem(atPath: filePath)
            }
            
            session.exportAsynchronously {
                switch session.status {
                case .unknown:
                    print("AVAssetExportSessionStatusUnknown")
                case .waiting:
                    print("AVAssetExportSessionStatusWaiting")
                case .exporting:
                    print("AVAssetExportSessionStatusExporting")
                case .completed:
                    DispatchQueue.main.async {
                        completion?(filePath)
                    }
                case .failed:
                    print("AVAssetExportSessionStatusFailed")
                default:
                    break
                }
            }
        }
        
        //次方法会导致内存爆增
        ////获取视频的第一帧截图, 返回UIImage (需要导入AVFoundation.h)
        static func getVideoPreViewImageWithPath(videoPath: URL) -> UIImage? {
            let asset = AVURLAsset(url: videoPath, options: nil)
            let gen = AVAssetImageGenerator(asset: asset)
            gen.appliesPreferredTrackTransform = true
            gen.apertureMode = .encodedPixels
            let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
//            var actualTime: CMTime = CMTimeMake(value: 0, timescale: 0)
            var cgImage: CGImage?
            do {
                cgImage = try gen.copyCGImage(at: time, actualTime: nil)
            }catch{
                print("获取失败")
            }
            if let cimg = cgImage {
                return UIImage(cgImage: cimg)
            }
            return nil
        }
        
        //获取视频第一zhen
        static func getCoverImage(asset: PHAsset, callback:((_ resultImage: UIImage?) -> Void)?) {
            // 新建一个默认类型的图像管理器imageManager
            let imageManager = PHImageManager.default()
            // 新建一个PHImageRequestOptions对象
            let imageRequestOption = PHImageRequestOptions()
            // PHImageRequestOptions是否有效
            imageRequestOption.isSynchronous = true
            // 缩略图的压缩模式设置为无
            imageRequestOption.resizeMode = .none
            // 缩略图的质量为快速
            imageRequestOption.deliveryMode = .fastFormat
            // 按照PHImageRequestOptions指定的规则取出图片
            imageManager.requestImage(for: asset, targetSize: CGSize.init(width: 140, height: 140), contentMode: .aspectFill, options: imageRequestOption) { result, dict in
                callback?(result)
            }
        }
    }
    
    
    
    struct ZXImage {
        @discardableResult static func imageFolderCheck() -> Bool {
            return createFolder(at: imageCachesPath)
        }
        
        static var imageCachesPath: String {
            get {
                return NSHomeDirectory() + "/Library/Caches/JXImageCaches"
            }
        }
        
        @discardableResult static func saveImage(_ data:Data?,filename:String,folderName:String) -> Bool {
            if let data = data {
                do {
                    try data.write(to: URL(fileURLWithPath: (self.imageCachesPath + "/\(folderName)" + "/\(filename)")))
                    return true
                } catch {
                    return false
                }
            }
            return false
        }
        
        static func tempPath(_ timeStr:String) -> String{
            return imageCachesPath + "/" + timeStr
        }
        
        static func currenTimeStr() -> String{
            return ZXDateUtils.millisecond.dateformat(ZXDateUtils.current.millisecond(), format: "yyyMMdd_HHmmss")
        }
        
        @discardableResult static func createFolder(at path:String) -> Bool{
            let manager = FileManager.default
            if !manager.fileExists(atPath: path) {
                do{
                    try manager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                    return true
                } catch {
                    return false
                }
            }
            return true
        }
        
        static func removeAll(at path:String) {
            let manager = FileManager.default
            if let fileArray = manager.subpaths(atPath: path) {
                for fn in fileArray {
                    try? manager.removeItem(atPath: path + "/\(fn)")
                }
            }
        }
        
        static func removeItem(_ path:String) {
            let manager = FileManager.default
            try? manager.removeItem(atPath: path)
        }
    }
}
