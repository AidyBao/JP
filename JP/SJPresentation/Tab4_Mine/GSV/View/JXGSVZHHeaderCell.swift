//
//  JXGSVZHHeaderCell.swift
//  gold
//
//  Created by SJXC on 2021/5/20.
//

import UIKit

protocol JXGSVZHHeaderCellDelegate: NSObjectProtocol {
    func jx_exchangeAction(type: JXBaseActive) -> Void
}

class JXGSVZHHeaderCell: UITableViewCell {
    
    @IBOutlet weak var countLB: UILabel!
    @IBOutlet weak var unitLB: UILabel!
    @IBOutlet weak var typeBtn: UIButton!
    fileprivate var typer: JXBaseActive = .Other
    weak var delegate: JXGSVZHHeaderCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none
        self.clipsToBounds = true
        self.typeBtn.backgroundColor = UIColor.zx_colorRGB(90, 160, 250, 1)
        self.typeBtn.layer.cornerRadius = self.typeBtn.frame.height * 0.5
        self.typeBtn.layer.masksToBounds = true
        self.typeBtn.isHidden = true
    }
    
    func loadData(type: JXBaseActive) {
        self.typer = type
        if type == .TG {
            self.typeBtn.setTitle("兑换 GSV", for: .normal)
            self.countLB.text = "\(ZXUser.user.pointsBalance.truncate(places: 3))"
            self.unitLB.text = "积分"
        }else{
            self.typeBtn.setTitle("兑换 积分", for: .normal)
            self.countLB.text = ZXUser.user.gsvBalance
            self.unitLB.text = "GSV"
        }
    }
    
    @IBAction func exchangeAction(_ sender: UIButton) {
        self.delegate?.jx_exchangeAction(type: typer)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
