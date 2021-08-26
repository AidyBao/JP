//
//  JXQYOneCell.swift
//  gold
//
//  Created by SJXC on 2021/5/24.
//

import UIKit

class JXQYOneCell: UITableViewCell {
    @IBOutlet weak var bannerView: ZXPageControlView!
    
    var list = [JXQYBanner]()
    
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
    
    func loadData(list: [JXQYBanner]) {
        if list.count > 0 {
            self.list = list
            self.bannerView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension JXQYOneCell: ZXPageControlViewDataSource {
    func zxPageControlView(_ scrollView: ZXPageControlView, pageAt index: Int) -> UIView {
        let imageV = UIImageView()
        imageV.backgroundColor = UIColor.zx_lightGray
        if self.list.count > 0 {
            let model = self.list[index]
            DispatchQueue.main.async {
                imageV.kf.setImage(with: URL(string: model.imgUrl), placeholder: nil)
            }
        }
        return imageV
    }
    
    
    func numberofPages(_ inScrollView: ZXPageControlView) -> Int {
        return self.list.count
    }
}

extension JXQYOneCell:ZXPageControlViewDelegate {
    func zxAutoScrolView(_ scrollView: ZXPageControlView, selectAt index: Int) {
        switch index {
        case 0:
            break
        case 1:
            let model = self.list[index]
            if model.content.hasPrefix("https://") {
                
            }
        case 2:
            break
        default:
            break
        }
    }
}
