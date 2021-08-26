//
//  JXCommentListViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/16.
//

import UIKit
import IQKeyboardManagerSwift

typealias JXCommentListCallback = () -> Void

let JX_Comm_PageSize: Int            = 10

class JXCommentListViewController: ZXBPushRootViewController {
    override var zx_dismissTapOutSideView: UIView {
        return bgview
    }
    
    @IBOutlet weak var buttomView: UIView!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var tabview: UITableView!
    @IBOutlet weak var commTF: UITextField!
    fileprivate var isReplaceComm: Bool = false
    fileprivate var currentIndex:NSInteger      = 1
    fileprivate var isOpen: Bool                = true
    fileprivate var selectModel: JXCommModel?   = nil
    fileprivate var selectIndex: Int?           = nil
    fileprivate var replyModel: JXCommSubModel? = nil
    
    var commList: Array<JXCommModel>            = []
    var moreReplyList: Array<JXCommSubModel>    = []
    var videoModel: JXVideoModel?               = nil
    var callback: JXCommentListCallback?        = nil
    
    
    static func show(superV: UIViewController, model: JXVideoModel?, zxCallback: JXCommentListCallback?) {
        let vc = JXCommentListViewController()
        vc.videoModel = model
        vc.callback = zxCallback
        superV.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .clear
        buttomView.backgroundColor = .zx_lightGray
        headView.backgroundColor = .zx_lightGray
        self.bgview.layer.cornerRadius = 10
        self.bgview.layer.masksToBounds = true
        
        self.titleLB.font = UIFont.zx_bodyFont
        self.titleLB.textColor = UIColor.zx_textColorBody
        
        self.sendBtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        self.sendBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.sendBtn.layer.cornerRadius = self.sendBtn.frame.height * 0.5
        self.sendBtn.layer.masksToBounds = true
        self.sendBtn.backgroundColor = UIColor.zx_yellow
        
        self.tabview.estimatedRowHeight = 100
        self.tabview.estimatedSectionHeaderHeight = 100
        self.tabview.register(UINib(nibName: JXCommentListCell.NibName, bundle: nil), forCellReuseIdentifier: JXCommentListCell.reuseIdentifier)
        self.tabview.register(UINib(nibName: JXCommentHeader.NibName, bundle: nil), forHeaderFooterViewReuseIdentifier: JXCommentHeader.reuseIdentifier)
        self.tabview.register(UINib(nibName: JXCommentFooter.NibName, bundle: nil), forHeaderFooterViewReuseIdentifier: JXCommentFooter.reuseIdentifier)
        
        if let vmod = self.videoModel {
            self.titleLB.text = "\(vmod.commentCount)条评论"
        }
        
        self.zx_addKeyboardNotification()
        self.setRefresh()
        self.refreshForHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func comment(_ sender: Any) {
        self.commTF.resignFirstResponder()
        if self.isReplaceComm {
            if let smod = self.selectModel, smod.replyCount < JX_Comm_PageSize {
                smod.replyIndex = 1
                if let rmod = self.replyModel {
                    self.jx_requestForReplyToReply(replyModel: rmod)
                }else{
                    self.jx_requestForReplaceComment()
                }
            }else{
                self.jx_requestForReplaceComment()
            }
        }else{
            
            self.jx_requestForComment()
        }
    }
    
    override func zx_keyboardWillShow(duration dt: Double, userInfo: Dictionary<String, Any>) {
        if self.isReplaceComm {
            self.commTF.placeholder = "回复:"
        }else{
            self.commTF.placeholder = "请输入评论:"
        }
    }
    
    override func zx_keyboardWillHide(duration dt: Double, userInfo: Dictionary<String, Any>) {
        self.commTF.placeholder = "留下您的精彩评论吧(100个字符以内)"
    }
    
    func setRefresh() ->Void{
     
        self.tabview.backgroundColor = UIColor.zx_lightGray
        self.tabview.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tabview.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    @objc func refreshForHeader() -> Void{
        self.currentIndex = 1
        self.jx_requestForCommList()
    }
    
    @objc func refreshForFooter() -> Void{
        self.currentIndex += 1
        self.jx_requestForCommList()
    }
    
    override func zx_reloadAction() {
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        
    }
}

extension JXCommentListViewController: JXCommentListCellDelegate {
    func didCommentReplyDZ(sender: UIButton, model: JXCommSubModel?) {
        if let mod = model {
           if mod.isUps {
            self.jx_requestForUpOrCancel(url: ZXAPIConst.Video.replyUpsCancel, commModel: nil, replyModel: model, commentId: nil, replyId: mod.id, isup: false)
            }else{
                self.jx_requestForUpOrCancel(url: ZXAPIConst.Video.replyUps, commModel: nil, replyModel: model, commentId: nil, replyId: mod.id, isup: true)
            }
        }
    }
}

extension JXCommentListViewController: JXCommentHeaderDelegate {
    func didCommentDZ(sender: UIButton, model: JXCommModel?, section: Int) {
        if let mod = model {
           if mod.isUps {
            self.jx_requestForUpOrCancel(url: ZXAPIConst.Video.commentUpsCancel, commModel: mod, replyModel: nil, commentId: mod.id, replyId: nil, isup: false)
            }else{
                self.jx_requestForUpOrCancel(url: ZXAPIConst.Video.commentUps, commModel: mod, replyModel: nil, commentId: mod.id, replyId: nil, isup: true)
            }
        }
    }
    
    func didJXCommentHeader(model: JXCommModel?, section: Int) {
        self.selectModel = model
        self.isReplaceComm = true
        self.selectIndex = section
        self.commTF.becomeFirstResponder()
        self.commTF.placeholder = "回复:"
    }
}

extension JXCommentListViewController: JXCommentFooterDelegate {
    func didJXCommentFooter(cell: JXCommentFooter, commModel: JXCommModel?, type: JXCommentReplyType, section: Int) {
        self.selectIndex = section
        switch type {
        case .NoReply:
            break
        case .NoMore:
            if let cmodel = commModel {
                cmodel.isOpen = false
            }
            cell.replyLB.text = "加载更多评论"
            self.tabview.reloadData()
        case .More:
            if let cmodel = commModel {
                cmodel.isOpen = true
                if cmodel.replyCount == cmodel.commentReplys.count {
                    self.tabview.reloadData()
                }else{
                    cmodel.replyIndex += 1
                    
                    self.jx_requestForMoreReplyComm(model: commModel)
                }
            }
        default:
            break
        }
    }
}

extension JXCommentListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.commTF {
            if range.location + string.count > 100 {
                ZXHUD.showFailure(in: self.view, text: "评论不能大于100个字符", delay: ZX.HUDDelay)
                return false
            }
        }
        return true
    }
}

extension JXCommentListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.commList.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let commMod = self.commList[section]
        if commMod.isOpen {
            return commMod.commentReplys.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXCommentListCell = tableView.dequeueReusableCell(withIdentifier: JXCommentListCell.reuseIdentifier, for: indexPath) as! JXCommentListCell
        cell.delegate = self
        let model = self.commList[indexPath.section]
        cell.loadData(rmodel: model.commentReplys[indexPath.row])
        return cell
    }
}

extension JXCommentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview: JXCommentHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: JXCommentHeader.reuseIdentifier) as! JXCommentHeader
        headview.delegate = self
        let model = self.commList[section]
        headview.loadData(model: model, section: section)
        return headview
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footview: JXCommentFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: JXCommentFooter.reuseIdentifier) as! JXCommentFooter
        footview.delegate = self
        let model = self.commList[section]
        footview.loadData(model: model, section: section)
        return footview
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mod = self.commList[indexPath.section].commentReplys[indexPath.row]
        self.replyModel = mod
        self.isReplaceComm = true
        self.selectModel = self.commList[indexPath.section]
        self.selectIndex = indexPath.section
        self.commTF.becomeFirstResponder()
        self.commTF.placeholder = "回复:"
    }
}

extension JXCommentListViewController {
    //评论列表
    func jx_requestForCommList() {
        var videoId = ""
        if let mod = self.videoModel {
            videoId = mod.videoId
        }
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayOne)
        JXVideoManager.jx_commentList(url: ZXAPIConst.Video.commentList, videoId: videoId, page: self.currentIndex) { (succ, code, listModel, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            if succ {
                if let listModel = listModel,listModel.count > 0 {
                    if self.currentIndex == 1 {
                        self.commList = listModel
                    }else{
                        self.commList.append(contentsOf: listModel)
                        if listModel.count < ZX.PageSize {
                            self.tabview.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }
                } else {
                    self.tabview.mj_footer?.endRefreshingWithNoMoreData()
                    if self.currentIndex == 1 {
                        
                    }
                }
            }
            
            
            if let smod = self.selectModel, let sin = self.selectIndex {
                self.commList[sin].isOpen = smod.isOpen
            }
            
            if self.selectModel != nil || self.replyModel != nil {
                self.jx_requestForMoreReplyComm(model: self.selectModel)
            }else{
                self.selectModel = nil
                self.selectIndex = nil
                self.tabview.reloadData()
            }
            
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            ZXHUD.showFailure(in: self.view, text: "请求失败", delay: ZX.HUDDelay)
        }
    }
    
    //加载更多评论
    func jx_requestForMoreReplyComm(model: JXCommModel?) {
        if let mod = model {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayOne)
            JXVideoManager.jx_getMoreReply(url: ZXAPIConst.Video.getMoreReply, commentId: mod.id, page: mod.replyIndex) { (succ, code, listModel, msg) in
                ZXHUD.hide(for: self.view, animated: true)
                ZXHUD.hide(for: self.tabview, animated: true)
                if succ {
                    if let list = listModel {
                        if mod.replyIndex == 1, let sin = self.selectIndex {
                            self.commList[sin].commentReplys = list
                        }else{
                            for (_, submod) in list.enumerated() {
                                if let sin = self.selectIndex {
                                    self.commList[sin].commentReplys.append(submod)
                                }
                            }
                        }
                    }
                }
                self.replyModel  = nil
                self.selectModel = nil
                self.selectIndex = nil
                
                self.tabview.reloadData()
            } zxFailed: { (code, msg) in
                ZXHUD.hide(for: self.view, animated: true)
                ZXHUD.hide(for: self.tabview, animated: true)
                ZXHUD.showFailure(in: self.view, text: "请求失败", delay: ZX.HUDDelay)
            }
        }
    }
    
    //评论
    func jx_requestForComment() {
        var videoId = ""
        if let mod = self.videoModel {
            videoId = mod.videoId
        }
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayOne)
        JXVideoManager.jx_comment(url: ZXAPIConst.Video.comment, videoId: videoId, content: self.commTF.text ?? "") { (succ, code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            if succ {
                self.commTF.text = ""
                self.callback?()
                if let vmod = self.videoModel {
                    self.titleLB.text = "\(vmod.commentCount)条评论"
                }
                
                ZXHUD.showSuccess(in: self.view, text: "评论成功", delay: ZX.HUDDelay)
                self.jx_requestForCommList()
            }
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            ZXHUD.showFailure(in: self.view, text: "请求失败", delay: ZX.HUDDelay)
        }
    }
    
    //回复评论
    func jx_requestForReplaceComment() {
        self.isReplaceComm = false
        var commentId = ""
        if let mod = self.selectModel {
            commentId = mod.id
        }
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayOne)
        JXVideoManager.jx_replaceComment(url: ZXAPIConst.Video.replyComment, commentId: commentId, content: self.commTF.text ?? "") { (succ, code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            if succ {
                self.commTF.text = ""
                self.callback?()
                if let vmod = self.videoModel {
                    self.titleLB.text = "\(vmod.commentCount)条评论"
                }
                
                ZXHUD.showSuccess(in: self.view, text: "评论成功", delay: ZX.HUDDelay)
                self.jx_requestForCommList()
            }
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            ZXHUD.showFailure(in: self.view, text: "请求失败", delay: ZX.HUDDelay)
        }
    }
    
    //回复别人的评论
    func jx_requestForReplyToReply(replyModel: JXCommSubModel?) {
        self.isReplaceComm = false
        var rId = ""
        if let rmod = replyModel {
            rId = rmod.id
        }
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZXHUD.DelayOne)
        JXVideoManager.jx_replyToReply(url: ZXAPIConst.Video.replyToReplyer, replyId: rId, content: self.commTF.text ?? "") { (succ, code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            if succ {
                self.commTF.text = ""
                self.callback?()
                if let vmod = self.videoModel {
                    self.titleLB.text = "\(vmod.commentCount)条评论"
                }
                
                ZXHUD.showSuccess(in: self.view, text: "评论成功", delay: ZX.HUDDelay)
                self.jx_requestForCommList()
            }
        } zxFailed: { (code, msg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            ZXHUD.showFailure(in: self.view, text: "请求失败", delay: ZX.HUDDelay)
        }
    }
    
    //点赞或取消
    func jx_requestForUpOrCancel(url: String , commModel: JXCommModel?, replyModel: JXCommSubModel?, commentId: String?, replyId: String?, isup: Bool) {
        JXVideoManager.jx_commentUpOrCancel(url: url, commentId: commentId, replyId: replyId) { (succ, code, msg) in
            if succ {
                if isup {
                    if let cmod = commModel {
                        cmod.ups += 1
                        cmod.isUps = true
                    }
                    
                    if let rmod = replyModel {
                        rmod.ups += 1
                        rmod.isUps = true
                    }
                }else{
                    if let cmod = commModel {
                        if cmod.ups > 0 {
                            cmod.ups -= 1
                        }
                        cmod.isUps = false
                    }
                    
                    if let rmod = replyModel {
                        if rmod.ups > 0 {
                            rmod.ups -= 1
                        }
                        rmod.isUps = false
                    }
                }
                self.tabview.reloadData()
            }
        } zxFailed: { (code, msg) in
            
        }
    }
}
