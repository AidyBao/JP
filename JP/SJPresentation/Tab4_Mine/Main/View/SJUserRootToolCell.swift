//
//  SJUserRootToolCell.swift
//  gold
//
//  Created by SJXC on 2021/3/27.
//

import UIKit

struct JXUserToolBtnTag {
    static let UserCSHHRTag   = 51001
    static let UserJFKTag    = 51002
    static let UserZLZTag   = 51003
    static let UserTGMTag    = 51004
}

protocol SJUserRootToolCellDelegate: NSObjectProtocol {
    func jx_toolCellBtnTag(tag: Int) -> Void
}

class SJUserRootToolCell: ZXUITableViewCell {
    weak var delegate: SJUserRootToolCellDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func cshhr(_ sender: UIButton) {
        if let del = delegate {
            del.jx_toolCellBtnTag(tag: sender.tag)
        }
    }
    
    @IBAction func jfk(_ sender: UIButton) {
        if let del = delegate {
            del.jx_toolCellBtnTag(tag: sender.tag)
        }
    }
    @IBAction func zlz(_ sender: UIButton) {
        if let del = delegate {
            del.jx_toolCellBtnTag(tag: sender.tag)
        }
    }
    
    @IBAction func tgm(_ sender: UIButton) {
        if let del = delegate {
            del.jx_toolCellBtnTag(tag: sender.tag)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
