//
//  JXTaskFourell.swift
//  gold
//
//  Created by SJXC on 2021/6/1.
//

import UIKit

protocol JXTaskFourellDelegate: NSObjectProtocol {
    func jx_waKuang() -> Void
    func jx_goLike() -> Void
    func jx_goAd(model: JXActivityInfoModel?) -> Void
}

class JXTaskFourell: UITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    fileprivate var model: JXActivityInfoModel? = nil
    weak var delegate: JXTaskFourellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
        
        self.lb1.font = UIFont.zx_titleFont
        self.lb1.textColor = UIColor.white
        self.lb1.text = "每日任务"
        
        self.lb2.font = UIFont.zx_bodyFont(14)
        self.lb2.textColor = UIColor.white
        self.lb2.text = "做任务得积分"
        
        self.lb3.font = UIFont.zx_bodyFont(14)
        self.lb3.textColor = UIColor.white
        self.lb3.text = "点赞"
        
        self.lb4.font = UIFont.zx_bodyFont(14)
        self.lb4.textColor = UIColor.white
        self.lb4.text = ""
        
        self.lb6.font = UIFont.zx_bodyFont(14)
        self.lb6.textColor = UIColor.white
        self.lb6.text = ""
        
        self.lb5.font = UIFont.zx_bodyFont(14)
        self.lb5.textColor = UIColor.white
        self.lb5.text = "看广告"
        
        self.btn1.layer.cornerRadius = self.btn1.frame.height * 0.5
        self.btn1.layer.masksToBounds = true
        self.btn1.layer.borderWidth = 1
        self.btn1.layer.borderColor = UIColor.white.cgColor
        self.btn1.titleLabel?.font = UIFont.zx_bodyFont(14)
        self.btn1.setTitleColor(UIColor.white, for: .normal)
        self.btn1.setTitle("去完成", for: .normal)
        
        self.btn2.layer.cornerRadius = self.btn1.frame.height * 0.5
        self.btn2.layer.masksToBounds = true
        self.btn2.layer.borderWidth = 1
        self.btn2.layer.borderColor = UIColor.white.cgColor
        self.btn2.titleLabel?.font = UIFont.zx_bodyFont(14)
        self.btn2.setTitleColor(UIColor.white, for: .normal)
        self.btn2.setTitle("去完成", for: .normal)
    }

    func loadData(model: JXActivityInfoModel?) {
        self.model = model
        if let mode = model {
            self.lb1.text = "每日任务"
            if mode.items.count >= 2 {
                guard let submod1 = mode.items[0] else {
                    return
                }
                guard let submod2 = mode.items[1] else {
                    return
                }
                
                if submod1.finishTimes <= submod1.sumTimes {
                    lb4.text = "\(submod1.finishTimes)" + "/" + "\(submod1.sumTimes)"
                }else{
                    lb4.text = "\(submod1.sumTimes)" + "/" + "\(submod1.sumTimes)"
                }
                
                if submod2.finishTimes <= submod2.sumTimes {
                    lb6.text = "\(submod2.finishTimes)" + "/" + "\(submod2.sumTimes)"
                }else{
                    lb6.text = "\(submod2.sumTimes)" + "/" + "\(submod2.sumTimes)"
                }
                
                lb3.text = submod1.name
                lb5.text = submod2.name
                
                if submod1.finishTimes >= submod1.sumTimes {
                    btn1.setTitle("已完成", for: .normal)
                    btn1.backgroundColor = UIColor.clear
                    btn1.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
                }else{
                    btn1.setTitle("去完成", for: .normal)
                    btn1.backgroundColor = UIColor.clear
                    btn1.setTitleColor(UIColor.white, for: .normal)
                }
                
                if submod2.finishTimes >= submod2.sumTimes {
                    btn2.setTitle("已完成", for: .normal)
                    btn2.backgroundColor = UIColor.clear
                    btn2.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
                }else{
                    btn2.setTitle("去完成", for: .normal)
                    btn2.backgroundColor = UIColor.clear
                    btn2.setTitleColor(UIColor.white, for: .normal)
                }
                
                
                if mode.items.count >= 2 {
                    guard let submod1 = mode.items[0] else {
                        return
                    }
                    guard let submod2 = mode.items[1] else {
                        return
                    }
                    if submod1.finishTimes >= submod1.sumTimes, submod2.finishTimes >= submod2.sumTimes {
                        self.delegate?.jx_waKuang()
                    }
                }
            }
        }
    }
    
    @IBAction func goLike(_ sender: Any) {
        self.delegate?.jx_goLike()
    }
    
    @IBAction func goAd(_ sender: Any) {
        self.delegate?.jx_goAd(model: self.model)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
