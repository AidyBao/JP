//
//  JXCommentHeader.swift
//  gold
//
//  Created by SJXC on 2021/4/16.
//

import UIKit

protocol JXCommentHeaderDelegate: NSObjectProtocol {
    func didJXCommentHeader(model: JXCommModel?, section: Int) -> Void
    func didCommentDZ(sender: UIButton, model: JXCommModel?, section: Int) -> Void
}

class JXCommentHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var loveview: UIView!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var commLB: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var commcountLB: UILabel!
    @IBOutlet weak var commBtn: UIButton!
    @IBOutlet weak var dzImg: UIImageView!
    var cmodel: JXCommModel? = nil
    weak var delegate: JXCommentHeaderDelegate? = nil
    fileprivate var section: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        loveview.backgroundColor = .zx_lightGray
        contentView.backgroundColor = .zx_lightGray
        self.nameLB.font = UIFont.zx_bodyFont(12)
        self.commLB.font = UIFont.zx_bodyFont(13)
        self.dateLB.font = UIFont.zx_bodyFont(10)
        self.commcountLB.font = UIFont.zx_bodyFont(10)
        
        self.nameLB.textColor = UIColor.zx_grayColor
        self.commLB.textColor = UIColor.zx_textColorBody
        self.dateLB.textColor = UIColor.zx_grayColor
        self.commcountLB.textColor = UIColor.zx_grayColor
        
        self.headImg.layer.cornerRadius = self.headImg.frame.height * 0.5
        self.headImg.layer.masksToBounds = true
    }
    @IBAction func commAction(_ sender: UIButton) {
        self.delegate?.didCommentDZ(sender: sender, model: self.cmodel, section: self.section)
    }

    func loadData(model: JXCommModel?, section: Int) {
        self.cmodel = model
        self.section = section
        if let mod = model {
            self.headImg.kf.setImage(with: URL(string: mod.memberHeadUrl))
            self.nameLB.text = mod.memberNickname
            self.commLB.text = mod.content
            self.dateLB.text = mod.createTime
            self.commcountLB.text = "\(mod.ups)"
            if mod.isUps {
                self.dzImg.image = UIImage(named: "jx_video_up")
            }else{
                self.dzImg.image = UIImage(named: "jx_video_unup")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.didJXCommentHeader(model: self.cmodel, section: self.section)
    }
}
