//
//  JXCityListCell.swift
//  gold
//
//  Created by SJXC on 2021/7/28.
//

import UIKit

class JXCityListCell: UITableViewCell {
    @IBOutlet weak var nameLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLB.font = UIFont.zx_bodyFont
        nameLB.textColor = UIColor.zx_textColorBody
    }
    
    func loadData(mod: JXCitySearchModel?) {
        if let mod = mod {
            nameLB.text = mod.cityName
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
