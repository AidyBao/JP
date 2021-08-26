//
//  JXCommentListCell.swift
//  gold
//
//  Created by SJXC on 2021/4/16.
//

import UIKit
protocol JXCommentListCellDelegate: NSObjectProtocol {
    func didCommentReplyDZ(sender: UIButton, model: JXCommSubModel?) -> Void
}

class JXCommentListCell: ZXUITableViewCell {
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var commLB: UILabel!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var commcountLB: UILabel!
    @IBOutlet weak var commBtn: UIButton!
    @IBOutlet weak var dzImg: UIImageView!
    @IBOutlet weak var loveView: UIView!
    var smodel: JXCommSubModel? = nil
    weak var delegate: JXCommentListCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        loveView.backgroundColor = .zx_lightGray
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
        self.delegate?.didCommentReplyDZ(sender: sender, model: self.smodel)
    }
    
    func loadData(rmodel: JXCommSubModel?) {
        self.smodel = rmodel
        if let rmod = rmodel {
            self.headImg.kf.setImage(with: URL(string: rmod.fromMemberHeadUrl))
            self.nameLB.text = rmod.fromMemberNickname
            if rmod.replyType == 1 {
                self.commLB.text = "回复:" + rmod.content
            }else{
                self.commLB.text = rmod.content
            }
            
            self.dateLB.text = rmod.createTime
            self.commcountLB.text = "\(rmod.ups)"
            if rmod.isUps {
                self.dzImg.image = UIImage(named: "jx_video_up")
            }else{
                self.dzImg.image = UIImage(named: "jx_video_unup")
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
