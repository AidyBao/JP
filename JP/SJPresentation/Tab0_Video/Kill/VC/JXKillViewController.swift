//
//  JXKillViewController.swift
//  gold
//
//  Created by SJXC on 2021/6/3.
//

import UIKit

class JXKillViewController: ZXUIViewController {
    @IBOutlet weak var tabView: UITableView!
    
    static func show(superV: UIViewController) {
        let vc = JXKillViewController()
        superV.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "签到秒杀"
        
        self.view.backgroundColor = UIColor.zx_lightGray
        self.tabView.backgroundColor = UIColor.zx_lightGray
        self.tabView.register(UINib(nibName: JXKillOneCell.NibName, bundle: nil), forCellReuseIdentifier: JXKillOneCell.reuseIdentifier)
        
    }
}

extension JXKillViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXKillOneCell = tableView.dequeueReusableCell(withIdentifier: JXKillOneCell.reuseIdentifier, for: indexPath) as! JXKillOneCell
        cell.loadData(indexPath: indexPath)
        return cell
    }
}

extension JXKillViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH, height: 10))
        view.backgroundColor = UIColor.zx_lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let url = ZXAPIConst.Game.signin + "token=" + ZXToken.token.userToken
            JXWebGameViewController.show(superV: self, url: url) { (count) in
                if !count.isEmpty {
                    JXOrderRootViewController.show(superV: self)
                }
            }
        case 1:
            let url = ZXAPIConst.Game.secKill + "token=" + ZXToken.token.userToken
            JXWebGameViewController.show(superV: self, url: url) { (count) in
                if !count.isEmpty {
                    JXOrderRootViewController.show(superV: self)
                }
            }
        default:
            break
        }
    }
}


