//
//  JXCityListViewController.swift
//  gold
//
//  Created by SJXC on 2021/7/28.
//

typealias JXCityListCallback = (_ : JXCitySearchModel?) -> Void

import UIKit

class JXCityListViewController: ZXBPushRootViewController {
    @IBOutlet weak var tabView: UITableView!
    fileprivate var dataSoure: Array<JXCitySearchModel> = []
    var zxCallback: JXCityListCallback? = nil
    
    static func show(superView: UIViewController,list: Array<JXCitySearchModel>, callback: JXCityListCallback?) {
        let vc = JXCityListViewController()
        vc.zxCallback = callback
        vc.dataSoure = list
        superView.present(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabView.register(UINib(nibName: JXCityListCell.NibName, bundle: nil), forCellReuseIdentifier: JXCityListCell.reuseIdentifier)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss(animated: true, completion: nil)
    }
}

extension JXCityListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSoure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXCityListCell = tableView.dequeueReusableCell(withIdentifier: JXCityListCell.reuseIdentifier, for: indexPath) as! JXCityListCell
        cell.loadData(mod: self.dataSoure[indexPath.row])
        return cell
    }
}

extension JXCityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mod = self.dataSoure[indexPath.row]
        self.dismiss(animated: true) {
            self.zxCallback?(mod)
        }
    }
}
