//
//  JXMemberViewController.swift
//  gold
//
//  Created by Aidy Bao on 2021/4/11.
//

import UIKit

class JXMemberViewController: ZXUIViewController {

    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    
    @IBOutlet weak var tabview: UITableView!
    @IBOutlet weak var titlelb: UIView!
    @IBOutlet weak var jyzBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var statusH: NSLayoutConstraint!
    
   
    var memberModel: JXMemberLevel? = nil
    
    static func show(superV: UIViewController) {
        let vc = JXMemberViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.zx_lightGray
        self.tabview.backgroundColor = UIColor.zx_lightGray
        
        self.fd_prefersNavigationBarHidden = true
        
        if #available(iOS 11.0, *) {
            self.tabview.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if UIDevice.zx_isX() {
            statusH.constant = 44
        }else{
            statusH.constant = 20
        }
        
        navView.backgroundColor = UIColor.zx_tintColor.withAlphaComponent(0)
        
        self.jyzBtn.titleLabel?.font = UIFont.zx_bodyFont
        self.jyzBtn.setTitleColor(UIColor.zx_textColorBody, for: .normal)
        
        self.tabview.register(UINib(nibName: JXMemberHeaderCell.NibName, bundle: nil), forCellReuseIdentifier: JXMemberHeaderCell.reuseIdentifier)
        self.tabview.register(UINib(nibName: JXMemberCollViewCell.NibName, bundle: nil), forCellReuseIdentifier: JXMemberCollViewCell.reuseIdentifier)

        self.jx_requestForMemeberLevel()
        
        self.jx_requestForMemeberLevelList()
        
        //Refresh
        self.tabview.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(self.zx_refresh))
    }
    
    //MARK: - 下拉刷新
    override func zx_refresh() {
        self.jx_requestForMemeberLevel()
        self.jx_requestForMemeberLevelList()
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func jyzAction(_ sender: UIButton) {
        JXJYZListViewController.show(superV: self, member: self.memberModel)
    }
    
    func jx_requestForMemeberLevel() {
        JXUserManager.jx_getUserLevel(urlString: ZXAPIConst.User.getMemberLevel) { (succ, code, model, msg) in
            if succ {
                self.memberModel = model
                self.tabview.reloadData()
            }else{
                ZXHUD.showFailure(in: self.view, text: msg ?? "", delay: ZX.HUDDelay)
            }
        } zxFailed: { (code, msg) in
            ZXHUD.showFailure(in: self.view, text: msg, delay: ZX.HUDDelay)
        }
    }
    
    func jx_requestForMemeberLevelList() {
        JXUserManager.jx_getMemberLevelList(urlString: ZXAPIConst.Member.memberLevelList) { (succ, code, list, msg) in
            if succ {
                if let lis = list {
                    self.memberList = lis
                    self.tabview.reloadData()
                }
            }else{
                ZXHUD.showFailure(in: self.view, text: msg ?? "", delay: ZX.HUDDelay)
            }
        } zxFailed: { (code, msg) in
            ZXHUD.showFailure(in: self.view, text: msg, delay: ZX.HUDDelay)
        }
    }
    
    lazy var memberList: Array<JXNowLevelConfig> = {
        let list = Array<JXNowLevelConfig>()
        return list
    }()
}

extension JXMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: JXMemberHeaderCell = tableView.dequeueReusableCell(withIdentifier: JXMemberHeaderCell.reuseIdentifier, for: indexPath) as! JXMemberHeaderCell
            cell.loadData(model: self.memberModel)
            return cell
        }else{
            let cell: JXMemberCollViewCell = tableView.dequeueReusableCell(withIdentifier: JXMemberCollViewCell.reuseIdentifier, for: indexPath) as! JXMemberCollViewCell
            cell.loadData(list: self.memberList)
            return cell
        }
    }
}

extension JXMemberViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 270
        }
        return 570
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension JXMemberViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minAlphaOffset: CGFloat = -88
        let maxAlphaOffset: CGFloat = 200
        let offset = scrollView.contentOffset.y
        var alpha: CGFloat = 0
        if offset <= 0 {
            alpha = 0
        }else{
            alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset)
        }
        navView.backgroundColor = UIColor.zx_tintColor.withAlphaComponent(alpha)
    }
}
