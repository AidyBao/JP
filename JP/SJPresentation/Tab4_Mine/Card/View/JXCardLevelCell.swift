//
//  JXCardLevelCell.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXCardLevelCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var waitLB: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var LB1: UILabel!
    @IBOutlet weak var LB2: UILabel!
    @IBOutlet weak var LB3: UILabel!
    @IBOutlet weak var LB4: UILabel!
    @IBOutlet weak var LB5: UILabel!
    @IBOutlet weak var LB6: UILabel!
    
    @IBOutlet weak var LB1v: UILabel!
    @IBOutlet weak var LB2v: UILabel!
    @IBOutlet weak var LB3v: UILabel!
    @IBOutlet weak var LB4v: UILabel!
    @IBOutlet weak var LB5v: UILabel!
    @IBOutlet weak var LB6v: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var remainingLB: UILabel!
    @IBOutlet weak var procBgView: JXProcessView!
    @IBOutlet weak var buttomh: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_lightGray
        
        self.clipsToBounds = true
        
        self.bgView.backgroundColor = UIColor.white
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
        
        self.topView.layer.cornerRadius = 10
        self.topView.layer.masksToBounds = true
        
        self.LB1.textColor = UIColor.zx_textColorBody
        self.LB1.font = UIFont.zx_supMarkFont
        self.LB2.textColor = UIColor.zx_textColorBody
        self.LB2.font = UIFont.zx_supMarkFont
        self.LB3.textColor = UIColor.zx_textColorBody
        self.LB3.font = UIFont.zx_supMarkFont
        self.LB4.textColor = UIColor.zx_textColorBody
        self.LB4.font = UIFont.zx_supMarkFont
        self.LB5.textColor = UIColor.zx_textColorBody
        self.LB5.font = UIFont.zx_supMarkFont
        self.LB6.textColor = UIColor.zx_textColorBody
        self.LB6.font = UIFont.zx_supMarkFont
        
        self.LB1v.textColor = UIColor.zx_textColorTitle
        self.LB1v.font = UIFont.zx_supMarkFont
        self.LB2v.textColor = UIColor.zx_textColorTitle
        self.LB2v.font = UIFont.zx_supMarkFont
        self.LB3v.textColor = UIColor.zx_textColorTitle
        self.LB3v.font = UIFont.zx_supMarkFont
        self.LB4v.textColor = UIColor.zx_textColorTitle
        self.LB4v.font = UIFont.zx_supMarkFont
        self.LB5v.textColor = UIColor.zx_textColorTitle
        self.LB5v.font = UIFont.zx_supMarkFont
        self.LB6v.textColor = UIColor.zx_textColorTitle
        self.LB6v.font = UIFont.zx_supMarkFont
        
        self.topView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.waitLB.textColor = UIColor.white
        self.waitLB.font = UIFont.zx_bodyFont
        
        self.remainingLB.textColor = UIColor.zx_textColorMark
        self.remainingLB.font = UIFont.systemFont(ofSize: 10)
        
        self.btn.setTitleColor(UIColor.zx_textColorTitle, for: .normal)
        self.btn.backgroundColor = UIColor.zx_colorRGB(245, 204, 78, 1)
        self.btn.layer.cornerRadius = self.btn.bounds.height * 0.5
        self.btn.layer.masksToBounds = true
        self.btn.isUserInteractionEnabled = false
        
        //设置圆角
        procBgView.backgroundColor = UIColor.zx_lightGray
        procBgView.layer.cornerRadius = 5
        procBgView.progressCornerRadius = 5
        procBgView.progressColors = [UIColor.zx_colorWithHexString("#FDCB25")]
        procBgView.animationDuration = 1
        procBgView.timingFunction = CAMediaTimingFunction(name: .default)
    }

    @IBAction func changeview(_ sender: Any) {
        
        
    }
    
    func loadData(model: JXCardLevelModel?, type: Int) {
        if let mod = model {
            self.imgV.kf.setImage(with: URL(string: mod.formatUrl))
            self.LB1v.text = mod.pointsPrice + "积分"
            self.LB2v.text = mod.totalProfit
            self.LB3v.text = mod.dayProfit
            self.LB4v.text = mod.activity
            self.LB6v.text = "\(mod.cycle)"
            switch type {
            case 0:
                self.topView.isHidden = true
                self.buttomh.constant = 0
                self.buttomView.isHidden = true
                self.buttomView.clipsToBounds = true
                self.procBgView.isHidden = true
                self.remainingLB.isHidden = true
                if mod.buyCount == mod.upperLimit {
                    self.btn.isHidden = true
                }else{
                    self.btn.isHidden = false
                }
                self.LB5v.text = "\(mod.buyCount)" + "/" + "\(mod.upperLimit)"
            case 2:
                if mod.consumeStusus == 1 {
                    self.topView.isHidden = false
                }else if mod.consumeStusus == 2 {
                    self.topView.isHidden = true
                }
                self.buttomh.constant = 24
                self.buttomView.isHidden = false
                self.btn.isHidden = true
                
                self.remainingLB.text = "剩余" + "\(mod.cycle - mod.useCount)" + "天"
                
                let value: Float = Float(mod.useCount)/Float(mod.cycle)
                procBgView.setProgress(value + procBgView.progress, animated: true)
                self.LB5v.text = "\(mod.upperLimit)"
            case 3:
                self.topView.isHidden = false
                self.waitLB.isHidden = true
                self.buttomh.constant = 0
                self.buttomView.isHidden = true
                self.buttomView.clipsToBounds = true
                self.procBgView.isHidden = true
                self.remainingLB.isHidden = true
                self.btn.isHidden = true
                self.LB5v.text = "\(mod.upperLimit)"
            default:
                break
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
