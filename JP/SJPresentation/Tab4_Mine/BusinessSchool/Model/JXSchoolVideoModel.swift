//
//  JXSchoolVideoModel.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit
import HandyJSON

class JXSchoolVideoModel: HandyJSON {
    required init() {}
    var updateTime: String  = ""
    var id: String          = ""
    var content: String     = ""
    var videoUrl: String    = ""
    var updateBy: String    = ""
    var params: String      = ""
    var searchValue: String = ""
    var createTime: String  = ""
    var remark: String      = ""
    var sort: String        = ""
    var describes: String   = ""
    var createBy: String    = ""
    var firstImage: UIImage? {
        if !videoUrl.isEmpty, let url = URL(string: videoUrl) {
            return FileManager.ZXVideo.getVideoPreViewImageWithPath(videoPath: url)
        }
        return nil
    }
}
