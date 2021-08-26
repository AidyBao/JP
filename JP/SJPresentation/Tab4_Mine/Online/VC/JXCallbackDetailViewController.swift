//
//  JXCallbackDetailViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/6.
//

import UIKit

class JXCallbackDetailViewController: UIViewController {
    @IBOutlet weak var tabview: UITableView!
    var detailModel: JXCallbackModel?   = nil
    
    static func show(superV: UIViewController, detailModel: JXCallbackModel) {
        let vc = JXCallbackDetailViewController()
        vc.detailModel = detailModel
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "在线客服"
        self.tabview.backgroundColor = UIColor.white
        
        self.tabview.register(UINib.init(nibName:JXCallbackNormalCell.NibName, bundle: nil), forCellReuseIdentifier: JXCallbackNormalCell.reuseIdentifier)
        self.tabview.register(UINib.init(nibName:JXCallbackImgCell.NibName, bundle: nil), forCellReuseIdentifier: JXCallbackImgCell.reuseIdentifier)
        self.tabview.register(UINib.init(nibName:JXCallbackFinishCell.NibName, bundle: nil), forCellReuseIdentifier: JXCallbackFinishCell.reuseIdentifier)
        
        self.jx_requestForMessage(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
}

extension JXCallbackDetailViewController {
    //MARK: - 消息列表
    func jx_requestForMessage(_ showHUD: Bool) ->Void{
        if showHUD {
            ZXHUD.showLoading(in: self.tabview, text: "", delay: nil)
        }
        
        JXCallbackManager.jx_callbackDetail(problemId: self.detailModel?.id) { (success, code, model,  errorMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            ZXEmptyView.hide(from: self.tabview)
            ZXEmptyView.hide(from: self.view)
            if success {
                if let mod = model {
                    self.detailModel = mod
                } else {
                    ZXHUD.showFailure(in: self.tabview, text: errorMsg, delay: ZX.HUDDelay)
                }
                self.tabview.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID {
                ZXHUD.showFailure(in: self.tabview, text: errorMsg, delay: ZX.HUDDelay)
            }
        }
    }
}

extension JXCallbackDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 5:
            let cell: JXCallbackImgCell = tableView.dequeueReusableCell(withIdentifier: JXCallbackImgCell.reuseIdentifier, for: indexPath) as! JXCallbackImgCell
            cell.loadData(model: self.detailModel)
            return cell
        case 6:
            let cell: JXCallbackFinishCell = tableView.dequeueReusableCell(withIdentifier: JXCallbackFinishCell.reuseIdentifier, for: indexPath) as! JXCallbackFinishCell
            cell.loadData(model: self.detailModel)
            return cell
        default:
            let cell: JXCallbackNormalCell = tableView.dequeueReusableCell(withIdentifier: JXCallbackNormalCell.reuseIdentifier, for: indexPath) as! JXCallbackNormalCell
            cell.loadData(model: self.detailModel, indexPath: indexPath)
            return cell
        }
    }
}

extension JXCallbackDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 160
        }
        if indexPath.row == 6 {
            if let mod = self.detailModel, mod.remark.isEmpty {
                return CGFloat.leastNormalMagnitude
            }else{
                return UITableView.automaticDimension
            }
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

