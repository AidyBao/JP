//
//  JXCardHeaderView.swift
//  gold
//
//  Created by SJXC on 2021/4/8.
//

import UIKit

protocol JXCardHeaderViewDelegate: NSObjectProtocol {
    func didBackAction() -> Void
    func didGoExchangList() -> Void
}


class JXCardHeaderView: UIView {
    
    weak var delegate: JXCardHeaderViewDelegate? = nil
    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var bgview3: UIView!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var tgcount: UILabel!
    @IBOutlet weak var noticView: UIView!
    @IBOutlet weak var gobtn: UIButton!
    fileprivate var winnerList: ZXWinnerScrollView!
    
    class func loadNib() -> JXCardHeaderView {
        let view:JXCardHeaderView = Bundle.main.loadNibNamed(String(describing: JXCardHeaderView.self), owner: self, options: nil)?.first as! JXCardHeaderView
        return  view
    }

    @IBAction func exchangList(_ sender: Any) {
        self.delegate?.didGoExchangList()
    }
    
    func loaddata(notices: Array<JXCardNoticeModel>) {
        self.days.text = "连续答题:" + ZXUser.user.continDay + "天"
        self.tgcount.text = "积分日产量:" + "\(ZXUser.user.todayPoints.zx_truncate(places: 3))" + "积分"
        
        self.winnerList.reloadData(notices)
    }
    
    
    func setFrame(frame: CGRect) {
        self.frame = frame
        self.backgroundColor = UIColor.zx_lightGray
        self.bgview.backgroundColor = UIColor.zx_lightGray
        
        self.bgview3.layer.cornerRadius = 10
        self.bgview3.layer.masksToBounds = true
        
        self.days.font = UIFont.zx_bodyFont
        self.days.textColor = UIColor.zx_textColorBody
        
        self.tgcount.font = UIFont.zx_bodyFont
        self.tgcount.textColor = UIColor.zx_textColorBody
        
        self.noticView.backgroundColor = UIColor.white
        self.noticView.layer.cornerRadius = self.noticView.bounds.height * 0.5
        self.noticView.layer.masksToBounds = true
        
        let layerView = UIView()
        layerView.frame = CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 30, height: self.noticView.bounds.height)
        // shadowCode
        layerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor
        layerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        layerView.layer.shadowOpacity = 0.12
        layerView.layer.shadowRadius = 1
        // layerFillCode
        let layer = CALayer()
        layer.frame = layerView.bounds
        layer.backgroundColor = UIColor(red: 0.99, green: 0.8, blue: 0.15, alpha: 1).cgColor
        layerView.layer.addSublayer(layer)
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 1, green: 0.94, blue: 0.39, alpha: 1).cgColor, UIColor(red: 0.98, green: 0.92, blue: 0.73, alpha: 1).cgColor, UIColor(red: 0.99, green: 0.8, blue: 0.15, alpha: 1).cgColor]
        gradient1.locations = [0, 0.5, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = layerView.bounds
        layerView.layer.addSublayer(gradient1)
        layerView.layer.cornerRadius = self.noticView.bounds.height * 0.5
        self.noticView.insertSubview(layerView, at: 0)
        
        winnerList = ZXWinnerScrollView.init(origin: CGPoint(x: 30, y: 0), width: UIScreen.main.bounds.size.width - 80, pageSize: 1, type: 0)
        winnerList.backgroundColor = UIColor.clear
        self.noticView.addSubview(winnerList)

        self.noticView.bringSubviewToFront(self.gobtn)
        
        self.layoutSubviews()
    }

    
    override class func awakeFromNib() {
        
    }
}
