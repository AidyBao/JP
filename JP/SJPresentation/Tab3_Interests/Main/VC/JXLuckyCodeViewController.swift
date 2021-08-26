//
//  JXLuckyCodeViewController.swift
//  gold
//
//  Created by SJXC on 2021/8/3.
//

import UIKit

class JXLuckyCodeViewController: ZXUIViewController {
    override var zx_preferredNavgitaionBarHidden: Bool {return true}
    @IBOutlet weak var tabView: UITableView!
    var currentPage = 1
    @IBOutlet weak var segmentV: UIView!
    @IBOutlet weak var goodsImgV: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    var turnCode: String = ""
    var goodsCode: JXYZJCode? = nil
    
    static func show(superV: UIViewController, turnCode: String) {
        let vc = JXLuckyCodeViewController()
        vc.turnCode = turnCode
        superV.navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goodsName.textColor = UIColor.white
        goodsName.font = UIFont.zx_bodyFont
        
        self.goodsImgV.backgroundColor = UIColor.zx_tintColor
        self.goodsImgV.layer.cornerRadius = 5
        self.goodsImgV.layer.masksToBounds = true
        
        self.tabView.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            self.tabView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.tabView.register(UINib(nibName: JXLuckyCodeCell.NibName, bundle: nil), forCellReuseIdentifier: JXLuckyCodeCell.reuseIdentifier)

        //Refresh
        self.tabView.zx_addHeaderRefresh(showGif: true, target: self, action: #selector(self.zx_refresh))
        //LoadMore
        self.tabView.zx_addFooterRefresh(autoRefresh: true, target: self, action: #selector(self.zx_loadmore))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if zx_firstLoad {
            zx_firstLoad = false
            zx_refresh()
        }
    }
    
    //MARK: - 下拉刷新
    override func zx_refresh() {
        currentPage = 1
        self.jx_goodsCode()
    }
    //MARK: - 加载更多
    override func zx_loadmore() {
        currentPage += 1
        self.jx_goodsCode()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension JXLuckyCodeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goodsCode?.codes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXLuckyCodeCell = tableView.dequeueReusableCell(withIdentifier: JXLuckyCodeCell.reuseIdentifier, for: indexPath) as! JXLuckyCodeCell
//            cell.delegate = self
        cell.loadData(mod: self.goodsCode?.codes[indexPath.row])
        return cell
    }
}

extension JXLuckyCodeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

extension JXLuckyCodeViewController {
    func jx_goodsCode() {
        ZXHUD.showLoading(in: self.view, text: ZX_LOADING_TEXT, delay: 0)
        JXCJModelView.jx_goodsCode(url: ZXAPIConst.Bet.goodsCode, pageNum: self.currentPage, pageSize: ZX.PageSize, turnCode: self.turnCode) { c, s, modle, msg in
            ZXHUD.hide(for: self.view, animated: true)
            ZXEmptyView.hide(from: self.view)
            ZXEmptyView.hide(from: self.tabView)
            self.tabView.mj_header?.endRefreshing()
            self.tabView.mj_footer?.endRefreshing()
            self.tabView.mj_footer?.resetNoMoreData()
            if s {
                if self.currentPage == 1 {
                    if let mod = modle {
                        self.goodsCode = mod
                        if mod.codes.count > 0,mod.codes.count < ZX.PageSize {
                            self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                        }
                    }else {
                        ZXEmptyView.show(in: self.view, type: .noData, text: "暂无数据", subText: "", topOffset: 220,backgroundColor: UIColor.clear)
                    }
                }else{
                    if let mod = modle {
                        if mod.codes.count > 0, let goodM = self.goodsCode {
                            goodM.codes.append(contentsOf: mod.codes)
                            if mod.codes.count < ZX.PageSize {
                                self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                            }
                        }
                    }else {
                        self.tabView.mj_footer?.endRefreshingWithNoMoreData()
                    }
                }
                
                if let mod = self.goodsCode {
                    self.goodsImgV.kf.setImage(with: URL(string: mod.goodsImg))
                    self.goodsName.text = mod.goodsName
                }
                
                self.tabView.reloadData()
            }
        }
    }
}
