//
//  JXGoodsDetailBannerCell.swift
//  gold
//
//  Created by SJXC on 2021/8/19.
//

import UIKit

class JXGoodsDetailBannerCell: UICollectionViewCell {
    @IBOutlet weak var bannerView: ZXPageControlView!
    
    var list = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .zx_lightGray
        self.addBannerView()
        
    }
    
    func addBannerView() {
        self.bannerView.flipInterval = 3 // Default 2
        self.bannerView.delegate = self
        self.bannerView.dataSource = self
    }
    
    func loadData(list: [String]) {
        if list.count > 0 {
            self.list = list
            self.bannerView.reloadData()
        }
    }
    
    override func select(_ sender: Any?) {
        super.select(sender)
    }
}

extension JXGoodsDetailBannerCell: ZXPageControlViewDataSource {
    func zxPageControlView(_ scrollView: ZXPageControlView, pageAt index: Int) -> UIView {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.zx_lightGray
        if self.list.count > 0 {
            let imgUrl = self.list[index]
            DispatchQueue.main.async {
                imageV.kf.setImage(with: URL(string: imgUrl), placeholder: nil)
            }
        }
        return imageV
    }
    
    
    func numberofPages(_ inScrollView: ZXPageControlView) -> Int {
        return self.list.count
    }
}

extension JXGoodsDetailBannerCell:ZXPageControlViewDelegate {
    func zxAutoScrolView(_ scrollView: ZXPageControlView, selectAt index: Int) {
        switch index {
        case 0:
            break
        case 1:
            let url = self.list[index]
            if url.hasPrefix("https://") {
                
            }
        case 2:
            break
        default:
            break
        }
    }
}
