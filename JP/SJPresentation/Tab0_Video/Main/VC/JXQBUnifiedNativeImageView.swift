//
//  JXQBUnifiedNativeImageView.swift
//  gold
//
//  Created by SJXC on 2021/4/28.
//

import UIKit

let descLabelHeight: CGFloat = 30
let descLabel_to_imageView: CGFloat = 7

class JXQBUnifiedNativeImageView: GDTUnifiedNativeAdView {
    
    var mylabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.logoView.isHidden = true
        self.addSubview(descLabel)
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.descLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: descLabelHeight)
        self.imageView.frame = CGRect(x: 0, y: (descLabelHeight+descLabel_to_imageView), width: frame.size.width, height: frame.size.width * 9.0 / 16.0)

    }

    /// 赋值接口
    /// @param unifiedNativeDataObject 广告数据
    /// @param center 用于调用qb_registerDataObject，绑定点击页面
    /// @param rootViewController 点击之后跳转时需要一个锚点viewcontroller
    open func setupWithUnifiedNativeAdObject(unifiedNativeDataObject: GDTUnifiedNativeAdDataObject, center: QUBIADSdkCenter, rootViewController: UIViewController) -> Void {
        
        self.viewController = rootViewController
        self.descLabel.text = unifiedNativeDataObject.desc
        if let imageURL = URL(string: unifiedNativeDataObject.imageUrl) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        center.qb_registerDataObject(unifiedNativeDataObject, view: self, clickableViews: [imageView], customClickableViews: [])
    }
    
    //计算广告高度接口
    static func getViewHeightWithWidth(width: CGFloat) -> CGFloat {
        //图片宽高比为16：9
        let viewHeight: CGFloat = width * 9.0 / 16.0
        //descLabel 高度为30
        let descLabelHeight1: CGFloat = descLabelHeight
        //descLabel 距离imageView 10
        let descLabel_to_imageView1: CGFloat = descLabel_to_imageView
        return viewHeight + descLabelHeight1 + descLabel_to_imageView1
    }
    
    lazy var imageView: UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
    
    lazy var descLabel: UILabel = {
        let lab = UILabel()
        return lab
    }()
}
