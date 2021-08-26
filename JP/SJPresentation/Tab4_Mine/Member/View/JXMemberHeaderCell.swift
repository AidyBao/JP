//
//  JXMemberHeaderCell.swift
//  gold
//
//  Created by SJXC on 2021/4/27.
//

import UIKit

class JXMemberHeaderCell: UITableViewCell {

    @IBOutlet weak var activtlb: UILabel!
    @IBOutlet weak var startImg: UIImageView!
    @IBOutlet weak var endImg: UIImageView!
    @IBOutlet weak var processView: JXProcessView!
    @IBOutlet weak var noticBgView: UIView!
    @IBOutlet weak var noticView: UIView!
    var winnerList:ZXWinnerScrollView!
    var memberModel: JXMemberLevel? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.zx_lightGray

        self.activtlb.font = UIFont.zx_bodyFont
        self.activtlb.textColor = UIColor.zx_textColorBody
        self.activtlb.text = ""

        processView.backgroundColor = UIColor.white
        processView.layer.cornerRadius = processView.frame.height * 0.5
        processView.progressCornerRadius = processView.frame.height * 0.5
        processView.progressColors = [.orange]
        processView.animationDuration = 1
        processView.timingFunction = CAMediaTimingFunction(name: .default)

        
        winnerList = ZXWinnerScrollView.init(origin: CGPoint(x: 0, y: 0), width: UIScreen.main.bounds.size.width - 40, pageSize: 1, type: 2)
        winnerList.backgroundColor = UIColor.clear
        self.noticView.addSubview(winnerList)
        self.noticView.backgroundColor = UIColor.zx_lightGray
        
        var list: Array<JXCardNoticeModel> = []
        for i in 0..<1 {
            let mod = JXCardNoticeModel()
            switch i {
            case 0:
                mod.userMoble = "推荐新人实名并且完成任务获得5经验值，连续获得30天"
                mod.value = ""
            case 1:
                mod.userMoble = "兑换黄金以上资产卡包，获得100经验值"
                mod.value = ""
            default:
                break
            }
            list.append(mod)
        }
        
        self.winnerList.reloadData(list)
    }
    
    
    
    func loadData(model: JXMemberLevel?) {
        if let member = model {
            if let nowArr = member.nowLevelConfig, let nowl = nowArr.first {
                self.startImg.kf.setImage(with: URL(string: nowl.iconURL))
            }
            
            if let nextArr = member.nextLevelConfig, let next = nextArr.first {
                self.endImg.kf.setImage(with: URL(string: next.iconURL))
                
                
                self.activtlb.text = "\(member.exp)" + "/" + "\(next.exp)"
                
                let value = Float(member.exp)/Float(next.exp)
                self.processView.setProgress(value, animated: true)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
