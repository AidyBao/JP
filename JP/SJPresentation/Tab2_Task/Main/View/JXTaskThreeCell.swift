//
//  JXTaskThreeCell.swift
//  gold
//
//  Created by SJXC on 2021/6/1.
//

import UIKit

protocol JXTaskThreeCellDelegate: NSObjectProtocol {
    func jx_like(likeModel: JXActivityInfoModel?) -> Void
    func jx_time(timeModel: JXActivityInfoModel?) -> Void
}

class JXTaskThreeCell: UITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    fileprivate var timeModel: JXActivityInfoModel? = nil
    fileprivate var likeModel: JXActivityInfoModel? = nil
    weak var delegate: JXTaskThreeCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
        
        self.lb1.font = UIFont.zx_titleFont
        self.lb1.textColor = UIColor.white
        self.lb1.text = "免费赢大奖游戏"
        
        self.lb2.font = UIFont.zx_bodyFont(14)
        self.lb2.textColor = UIColor.white
        self.lb2.text = "更有奔驰豪车等你来"
        
        self.lb3.font = UIFont.zx_bodyFont(14)
        self.lb3.textColor = UIColor.white
        self.lb3.text = "时间掌控者"
        
        self.lb4.font = UIFont.zx_bodyFont(14)
        self.lb4.textColor = UIColor.white
        self.lb4.text = ""
        
        self.lb6.font = UIFont.zx_bodyFont(14)
        self.lb6.textColor = UIColor.white
        self.lb6.text = ""
        
        self.lb5.font = UIFont.zx_bodyFont(14)
        self.lb5.textColor = UIColor.white
        self.lb5.text = "幸运大转盘"
        
        self.btn1.layer.cornerRadius = self.btn1.frame.height * 0.5
        self.btn1.layer.masksToBounds = true
        self.btn1.layer.borderWidth = 1
        self.btn1.layer.borderColor = UIColor.white.cgColor
        self.btn1.titleLabel?.font = UIFont.zx_bodyFont(14)
        self.btn1.setTitleColor(UIColor.white, for: .normal)
        self.btn1.setTitle("免费玩一次", for: .normal)
        
        self.btn2.layer.cornerRadius = self.btn1.frame.height * 0.5
        self.btn2.layer.masksToBounds = true
        self.btn2.layer.borderWidth = 1
        self.btn2.layer.borderColor = UIColor.white.cgColor
        self.btn2.titleLabel?.font = UIFont.zx_bodyFont(14)
        self.btn2.setTitleColor(UIColor.white, for: .normal)
        self.btn2.setTitle("再玩一次", for: .normal)
    }
    
    func loadData(dataList: Array<JXActivityInfoModel?>) {
        if dataList.count > 1 {
            if let model1 = dataList[1] {
                self.timeModel = model1
                self.lb3.text = model1.name
                if model1.residueTimes == 0 {
                    if model1.freeTimes == 0 {
                        if model1.items.count > 1 {
                            guard let submod1 = model1.items[1] else {
                                return
                            }
                            if submod1.finishTimes >= submod1.sumTimes {
                                self.lb4.text = "\(submod1.sumTimes)" + "/" + "\(submod1.sumTimes)"
                                self.btn1.setTitle("已完成", for: .normal)
                                self.btn1.layer.borderColor = UIColor.clear.cgColor
                                self.btn1.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
                                self.btn1.isEnabled = false
                            }else{
                                self.lb4.text = "\(submod1.finishTimes)" + "/" + "\(submod1.sumTimes)"
                                self.btn1.backgroundColor = UIColor.clear
                                self.btn1.layer.borderColor = UIColor.white.cgColor
                                self.btn1.setTitle("再玩一次", for: .normal)
                                self.btn1.isEnabled = true
                            }
                        }
                    }else{
                        self.btn1.backgroundColor = UIColor.clear
                        self.btn1.setTitle("免费试玩一次", for: .normal)
                        self.btn1.isEnabled = true
                    }
                }else{
                    if model1.items.count > 1 {
                        guard let submod1 = model1.items[1] else {
                            return
                        }
//                        if submod1.finishTimes >= submod1.sumTimes {
//                            self.lb4.text = "\(submod1.sumTimes)" + "/" + "\(submod1.sumTimes)"
//                            self.btn1.setTitle("已完成", for: .normal)
//                            self.btn1.layer.borderColor = UIColor.clear.cgColor
//                            self.btn1.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
//                            self.btn1.isEnabled = false
//                        }else{
                            self.lb4.text = "\(submod1.finishTimes)" + "/" + "\(submod1.sumTimes)"
                            self.btn1.backgroundColor = UIColor.clear
                            self.btn1.layer.borderColor = UIColor.white.cgColor
                            self.btn1.setTitle("再玩一次", for: .normal)
                            self.btn1.isEnabled = true
//                        }
                    }
                }
            }
        }
        
        if dataList.count > 2 {
            if let model2 = dataList[2] {
                self.likeModel = model2
                self.lb5.text = model2.name
                if model2.residueTimes == 0 {
                    if model2.freeTimes == 0 {
                        if model2.items.count > 1 {
                            guard let submod1 = model2.items[1] else {
                                return
                            }
                            if submod1.finishTimes >= submod1.sumTimes {
                                self.lb6.text = "\(submod1.sumTimes)" + "/" + "\(submod1.sumTimes)"
                                self.btn2.setTitle("已完成", for: .normal)
                                self.btn2.layer.borderColor = UIColor.clear.cgColor
                                self.btn2.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
                                self.btn2.isEnabled = false
                            }else{
                                self.lb6.text = "\(submod1.finishTimes)" + "/" + "\(submod1.sumTimes)"
                                self.btn2.backgroundColor = UIColor.clear
                                self.btn2.layer.borderColor = UIColor.white.cgColor
                                self.btn2.setTitle("再玩一次", for: .normal)
                                self.btn2.isEnabled = true
                            }
                        }
                    }else{
                        self.btn2.backgroundColor = UIColor.clear
                        self.btn2.setTitle("免费试玩一次", for: .normal)
                        self.btn2.isEnabled = true
                    }
                }else{
                    if model2.items.count > 1 {
                        guard let submod1 = model2.items[1] else {
                            return
                        }
//                        if submod1.finishTimes >= submod1.sumTimes {
//                            self.lb6.text = "\(submod1.sumTimes)" + "/" + "\(submod1.sumTimes)"
//                            self.btn2.setTitle("已完成", for: .normal)
//                            self.btn2.layer.borderColor = UIColor.clear.cgColor
//                            self.btn2.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
//                            self.btn2.isEnabled = false
//                        }else{
                            self.lb6.text = "\(submod1.finishTimes)" + "/" + "\(submod1.sumTimes)"
                            self.btn2.backgroundColor = UIColor.clear
                            self.btn2.layer.borderColor = UIColor.white.cgColor
                            self.btn2.setTitle("再玩一次", for: .normal)
                            self.btn2.isEnabled = true
//                        }
                    }
                }
            }
        }
    }
    
    @IBAction func time(_ sender: Any) {
        self.delegate?.jx_time(timeModel: self.timeModel)
    }
    
    @IBAction func like(_ sender: Any) {
        self.delegate?.jx_like(likeModel: self.likeModel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
