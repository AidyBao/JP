//
//  JXSchoolCourseViewController.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

class JXSchoolCourseViewController: UIViewController {
    @IBOutlet weak var tabview: UITableView!
    var currentIndex:NSInteger = 1
    var totalPageNum:NSInteger = 0
    var msgType: Int = 1
    
    static func show(superV: UIViewController) {
        let vc = JXSchoolCourseViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabview.backgroundColor = UIColor.white
        
        self.tabview.register(UINib.init(nibName:JXSchoolTextCell.NibName, bundle: nil), forCellReuseIdentifier: JXSchoolTextCell.reuseIdentifier)
        self.setRefresh()
        
        self.refreshForHeader()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func zx_reloadAction() {
        self.jx_requestForSchool(showHUD: false)
    }
    
    func setRefresh() ->Void{
        self.tabview.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(refreshForHeader))
        self.tabview.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(refreshForFooter))
    }
    
    @objc func refreshForHeader() -> Void{
        self.currentIndex = 1
        self.jx_requestForSchool(showHUD: true)
    }
    
    @objc func refreshForFooter() -> Void{
        self.currentIndex += 1
        self.jx_requestForSchool(showHUD: false)
    }
    
    lazy var listModel: Array<JXSchoolVideoModel> = {
        let list: Array<JXSchoolVideoModel> = []
        return list
    }()
}

extension JXSchoolCourseViewController {
    func jx_requestForSchool(showHUD: Bool) {
        if showHUD {
            ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: ZX.HUDDelay)
        }
        JXSchoolManager.jx_school(pageNum: self.currentIndex, pageSize: ZX.PageSize, isAsc: "", lastId: 0, orderByColumn: "", type: 1) { (success, code, listModel, errorMsg) in
            ZXHUD.hide(for: self.view, animated: true)
            ZXHUD.hide(for: self.tabview, animated: true)
            self.tabview.mj_header?.endRefreshing()
            self.tabview.mj_footer?.endRefreshing()
            ZXEmptyView.hide(from: self.tabview)
            ZXEmptyView.hide(from: self.view)
            if success {
                if let listModel = listModel,listModel.count > 0 {
                    if self.currentIndex == 1 {
                        self.listModel = listModel
                    }else{
                        self.listModel.append(contentsOf: listModel)
                        if listModel.count < ZX.PageSize {
                            self.tabview.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }
                } else {
                    self.tabview.mj_footer?.endRefreshingWithNoMoreData()
                    if self.currentIndex == 1 {
                       ZXEmptyView.show(in: self.tabview, type: .noData, text: "暂时教程哦", subText: nil)
                    }
                }
                self.tabview.reloadData()
            }else if code != ZXAPI_LOGIN_INVALID {
                if self.currentIndex == 1 {
                    ZXEmptyView.show(in: self.tabview, type: .networkError, text: nil, subText: "", topOffset: 0, retry: {
                        self.jx_requestForSchool(showHUD: true)
                    })
                } else {
                    ZXHUD.showFailure(in: self.tabview, text: errorMsg, delay: ZX.HUDDelay)
                }
            }
        }
    }
}

extension JXSchoolCourseViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXSchoolTextCell = tableView.dequeueReusableCell(withIdentifier: JXSchoolTextCell.reuseIdentifier, for: indexPath) as! JXSchoolTextCell
        let model = self.listModel[indexPath.row]
        cell.loadData(model: model)
        return cell
    }
}

extension JXSchoolCourseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.listModel[indexPath.row]
        JXSchoolDetailViewController.show(superV: self, model: model)
    }
}
