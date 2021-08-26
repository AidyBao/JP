//
//  JXVideoUploadViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/22.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos
import MobileCoreServices

class JXVideoUploadViewController: ZXUIViewController {
 
    fileprivate var firstImage: UIImage?  = nil
    fileprivate let folderName = ZXDateUtils.zx_serialNumber()
    fileprivate var folderPath: String { return FileManager.ZXVideo.tempPath(folderName) }
    fileprivate var zipPath: String {
        return FileManager.ZXVideo.videoCachesPath + "/" + "\(folderName).zip"
    }
    
    static func show(superV: UIViewController) {
        let vc = JXVideoUploadViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        var success = FileManager.ZXVideo.videoFolderCheck()
        if success {
            success = FileManager.ZXVideo.createFolder(at: folderPath)
        }
        if !success {
            ZXAlertUtils.showAlert(wihtTitle: nil, message: "创建本地文件目录失败,请清除本地缓存后重试", buttonText: "好的", action: {
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        
        self.photoVideo()
        
        /*
        ZXAlertUtils.showActionSheet(withTitle: "温馨提示", message: nil, buttonTexts: ["从视频库选择","录像"], cancelText: "取消") { (index) in
            switch index {
            case 0://从视频库选择
                self.photoVideo()
            case 1://录像
                self.cameraVideo()
            default:
                break
            }
        }*/
        
    }
    
    
    func photoVideo() {
        if HImagePickerUtils.canUserPickVideosFromPhotoLibrary() {
            let ipc = UIImagePickerController()
            ipc.modalPresentationStyle = .fullScreen
            ipc.sourceType = .photoLibrary
            ipc.mediaTypes = [kUTTypeMovie as String]
            ipc.allowsEditing = true
    //        ipc.videoMaximumDuration = 30.0
            ipc.delegate = self
            self.present(ipc, animated: true, completion: nil)
        }
    }
    
    func cameraVideo() {
        if HImagePickerUtils.doesCameraSupportShootingVides() {
            let ipc = UIImagePickerController()
            ipc.modalPresentationStyle = .fullScreen
            ipc.sourceType = .camera
            ipc.cameraDevice = .rear
            guard let availableMedia: Array = UIImagePickerController.availableMediaTypes(for: .camera) else {
                return
            }
            ipc.mediaTypes = availableMedia
            ipc.videoQuality = .type640x480
            ipc.allowsEditing = true
            ipc.cameraCaptureMode = .video
            ipc.delegate = self
            self.present(ipc, animated: true, completion: nil)
        }
    }
    
    ////获取视频的第一帧截图, 返回UIImage (需要导入AVFoundation.h)
    func getVideoPreViewImageWithPath(videoPath: URL) -> UIImage? {
        let asset = AVURLAsset(url: videoPath, options: nil)
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        var actualTime: CMTime = CMTimeMake(value: 0, timescale: 0)
        var cgImage: CGImage?
        do {
            cgImage = try gen.copyCGImage(at: time, actualTime: &actualTime)
        }catch{
            print("获取失败")
        }
        if let cimg = cgImage {
            return UIImage(cgImage: cimg)
        }
        return nil
    }
    
    /**
     *  视频压缩
     *  @param originFilePath       视频资源的原始路径
     *  @param outputPath      输出路径
     */
    func compressVideoAccroding(originFilePath: URL, outputPath: String, completion:((Data?)->Void)?) {
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
                        let _ = self.getSizeWithData(data: videoData)
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
    
    /**获取文件大小*/
    func getSizeWithData(data: Data) -> String {
        var convertedValue = data.count
        var multiplyFactor = 0
        let tokens = ["bytes","KB","MB","GB","TB","PB", "EB", "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%.2f %@", convertedValue, tokens[multiplyFactor])
    }
}

extension JXVideoUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获取用户选择或拍摄的是照片还是视频
        var videoEditor: UIVideoEditorController? = nil
        let mediaType = info[.mediaType] as? NSString
        let currentType = kUTTypeMovie as NSString
        if mediaType == currentType {
            guard let url = info[.mediaURL] as? URL else {
                return
            }
            if picker.sourceType == .camera {
                try? PHPhotoLibrary.shared().performChangesAndWait {
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }
                
                if UIVideoEditorController.canEditVideo(atPath: url.path) {
                    videoEditor = UIVideoEditorController()
                    videoEditor?.videoPath = url.path
                    videoEditor?.delegate = self
                }
            }
            
            //3.0 写入本地缓存,方便播放使用
            let fileManager = FileManager.default
            try? fileManager.copyItem(atPath: url.absoluteString, toPath: self.folderPath)
            
            //2.0 压缩视频 & 保存视频数据 & 获取第一张图片
            self.firstImage = self.getVideoPreViewImageWithPath(videoPath: url)
            self.compressVideoAccroding(originFilePath: url, outputPath: self.zipPath) {[unowned self] videoData in
                DispatchQueue.main.async {
//                    JXVideoDescriptionViewController.show(superV: self, videoData: videoData, coverImage: self.firstImage)
                }
            }
        }
        
        picker.dismiss(animated: true, completion: {
//            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
//            self.navigationController?.popViewController(animated: true)
        })
    }
}

extension JXVideoUploadViewController: UIVideoEditorControllerDelegate {
    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        
    }
}
