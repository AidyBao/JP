//
//  JXTaskTwoCell.swift
//  gold
//
//  Created by SJXC on 2021/6/1.
//

import UIKit

protocol JXTaskTwoCellDelegate: NSObjectProtocol {
    func jx_goNoval(novalModel: JXTaskExprInfo?) -> Void
    func jx_goGame(gameModel: JXTaskExprInfo?) -> Void
}

class JXTaskTwoCell: UITableViewCell {
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var lb3: UILabel!
    @IBOutlet weak var lb4: UILabel!
    @IBOutlet weak var lb5: UILabel!
    @IBOutlet weak var lb6: UILabel!
    @IBOutlet weak var lb7: UILabel!
    @IBOutlet weak var lb8: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    fileprivate var novalModel: JXTaskExprInfo?
    fileprivate var gameModel: JXTaskExprInfo?
    weak var delegate: JXTaskTwoCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
        
        self.lb1.font = UIFont.zx_titleFont
        self.lb1.textColor = UIColor.white
        self.lb1.text = "做任务领经验"
        
        self.lb2.font = UIFont.zx_bodyFont(14)
        self.lb2.textColor = UIColor.white
        self.lb2.text = "玩游戏看小说领经验"
        
        self.lb3.font = UIFont.zx_bodyFont(14)
        self.lb3.textColor = UIColor.white
        self.lb3.text = "看小说"
        
        self.lb4.font = UIFont.zx_bodyFont(14)
        self.lb4.textColor = UIColor.white
        self.lb4.text = ""
        
        self.lb6.font = UIFont.zx_bodyFont(14)
        self.lb6.textColor = UIColor.white
        self.lb6.text = ""
        
        self.lb5.font = UIFont.zx_bodyFont(14)
        self.lb5.textColor = UIColor.white
        self.lb5.text = "玩游戏"
        
        self.lb7.font = UIFont.zx_bodyFont(14)
        self.lb7.textColor = UIColor.white
        self.lb7.text = ""
        
        self.lb8.font = UIFont.zx_bodyFont(14)
        self.lb8.textColor = UIColor.white
        self.lb8.text = ""
        
        self.btn1.layer.cornerRadius = self.btn1.frame.height * 0.5
        self.btn1.layer.masksToBounds = true
        self.btn1.layer.borderWidth = 1
        self.btn1.layer.borderColor = UIColor.white.cgColor
        self.btn1.titleLabel?.font = UIFont.zx_bodyFont(14)
        self.btn1.setTitleColor(UIColor.white, for: .normal)
        self.btn1.setTitle("去得经验", for: .normal)
        
        self.btn2.layer.cornerRadius = self.btn1.frame.height * 0.5
        self.btn2.layer.masksToBounds = true
        self.btn2.layer.borderWidth = 1
        self.btn2.layer.borderColor = UIColor.white.cgColor
        self.btn2.titleLabel?.font = UIFont.zx_bodyFont(14)
        self.btn2.setTitleColor(UIColor.white, for: .normal)
        self.btn2.setTitle("去得经验", for: .normal)
    }
    
    func loadData(novalModel: JXTaskExprInfo?, gameModel: JXTaskExprInfo?) {
        self.novalModel = novalModel
        self.gameModel = gameModel
        if let noval = novalModel {
            self.lb4.text = "\(noval.currentValue)/\(noval.totalValue)"
            self.lb7.text = "\(noval.currentTimes)/\(noval.totalTimes)"
            if noval.currentValue >= noval.totalValue, noval.currentTimes >= noval.totalTimes {
                self.btn1.setTitle("已完成", for: .normal)
                self.btn1.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
                self.btn1.isEnabled = false
            }
        }
        
        if let game = gameModel {
            self.lb6.text = "\(game.currentValue)/\(game.totalValue)"
            self.lb8.text = "\(game.currentTimes)/\(game.totalTimes)"
            if game.currentValue >= game.totalValue, game.currentTimes >= game.totalTimes {
                self.btn2.setTitle("已完成", for: .normal)
                self.btn2.setTitleColor(UIColor.zx_colorWithHexString("#FECC00"), for: .normal)
                self.btn2.isEnabled = false
            }
        }
    }
    
    @IBAction func goNonal(_ sender: Any) {
        self.delegate?.jx_goNoval(novalModel: self.novalModel)
    }
    
    @IBAction func goGame(_ sender: Any) {
        self.delegate?.jx_goGame(gameModel: self.gameModel)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
