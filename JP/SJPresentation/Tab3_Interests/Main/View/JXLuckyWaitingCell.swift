//
//  JXLuckyWaitingCell.swift
//  gold
//
//  Created by SJXC on 2021/8/9.
//

import UIKit

protocol JXLuckyWaitingCellDelegate: NSObjectProtocol {
    func jx_dbAction(model:JXYZJModel?)
}


class JXLuckyWaitingCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var timeBGView: UIView!
    @IBOutlet weak var processView: JXProcessView!
    @IBOutlet weak var percent: UILabel!
    fileprivate var model:JXYZJModel?
    weak var delegate: JXLuckyWaitingCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.bgView.backgroundColor = UIColor.zx_colorWithHexString("#701FE5")
        self.bgView.layer.cornerRadius = 5
        self.bgView.layer.masksToBounds = true
        
        self.nameLB.font = UIFont.zx_bodyFont
        self.nameLB.textColor = UIColor.white
        
        self.percent.font = UIFont.zx_markFont
        self.percent.textColor = UIColor.white
        
        self.imgV.backgroundColor = UIColor.zx_lightGray
        self.imgV.layer.cornerRadius = 5
        self.imgV.layer.masksToBounds = true
        
        self.timeBGView.backgroundColor = UIColor.zx_tintColor
        self.timeBGView.layer.cornerRadius = 5
        self.timeBGView.layer.masksToBounds = true
        
        processView.backgroundColor = UIColor.white
        processView.layer.cornerRadius = processView.frame.height * 0.5
        processView.progressCornerRadius = processView.frame.height * 0.5
        processView.progressColors = [.orange]
        processView.animationDuration = 1
        processView.timingFunction = CAMediaTimingFunction(name: .default)
        self.processView.setProgress(0.4, animated: true)
    }
    
    func loadData(mod: JXYZJModel?) {
        self.model = mod
        if let modle = mod {
            self.imgV.kf.setImage(with: URL(string: modle.goodsImg))
            self.nameLB.text = modle.goodsName
            
            let value = Float(modle.turnAmount)/Float(modle.totalAmount)
            self.processView.setProgress(value, animated: true)
            
            self.percent.text = "\(Int(Double(value).roundTo(places: 2)*100))" + "%"
        }
    }
    
    @IBAction func dbAction(_ sender: UIButton) {
        self.delegate?.jx_dbAction(model: self.model)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
