//
//  JXCommentFooter.swift
//  gold
//
//  Created by SJXC on 2021/4/17.
//

import UIKit

enum JXCommentReplyType {
    case NoReply
    case NoMore
    case More
    case Other
}

protocol JXCommentFooterDelegate: NSObjectProtocol {
    func didJXCommentFooter(cell: JXCommentFooter, commModel: JXCommModel?, type: JXCommentReplyType, section: Int) -> Void
}

class JXCommentFooter: UITableViewHeaderFooterView {
    
    @IBOutlet weak var replyLB: UILabel!
    var type: JXCommentReplyType = .NoReply
    
    weak var delegate: JXCommentFooterDelegate? = nil
    var commModel: JXCommModel? = nil
    fileprivate var section: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .zx_lightGray
        replyLB.font = UIFont.zx_bodyFont(10)
        replyLB.textColor = UIColor.zx_grayColor
        replyLB.text = ""
    }
    
    func loadData(model: JXCommModel?, section: Int) {
        self.section = section
        if let mod = model {
            self.commModel = mod
            switch mod.replyCount {
            case 0:
                self.type = .NoReply
                self.replyLB.text = "暂无回复"
            case 1:
                if mod.isOpen {
                    self.type = .NoMore
                    self.replyLB.text = "收起评论"
                }else{
                    self.type = .More
                    self.replyLB.text = "加载更多评论"
                }
            default:
                if mod.replyCount == mod.commentReplys.count {
                    if mod.isOpen {
                        self.type = .NoMore
                        self.replyLB.text = "收起评论"
                    }else{
                        self.type = .More
                        self.replyLB.text = "加载更多评论"
                    }
                }else{
                    self.type = .More
                    self.replyLB.text = "加载更多评论"
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.didJXCommentFooter(cell: self, commModel: self.commModel, type: self.type, section: self.section)
    }
}
