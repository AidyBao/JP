//
//  JXPowerTwoCell.swift
//  gold
//
//  Created by SJXC on 2021/5/28.
//

import UIKit

protocol JXPowerTwoCellDelegate: NSObjectProtocol {
    func jx_selectMyCapa() -> Void
    func jx_didSelect(model: JXCapaSubList?) -> Void
    func jx_lastMonth() -> Void
}

class JXPowerTwoCell: UITableViewCell {
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var top1ImgV: ZXUIImageView!
    @IBOutlet weak var L11: UILabel!
    @IBOutlet weak var L12: UILabel!
    @IBOutlet weak var top1VImgV: UIImageView!
    
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var top2ImgV: ZXUIImageView!
    @IBOutlet weak var L21: UILabel!
    @IBOutlet weak var L22: UILabel!
    @IBOutlet weak var top2VImgV: UIImageView!
    
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var top3ImgV: ZXUIImageView!
    @IBOutlet weak var L31: UILabel!
    @IBOutlet weak var L32: UILabel!
    @IBOutlet weak var top3VImgV: UIImageView!
    
    @IBOutlet weak var ZLZView: UIView!
    @IBOutlet weak var zxzLB: UILabel!
    @IBOutlet weak var BG1View: ZXUIView!
    @IBOutlet weak var BG1ViewH: NSLayoutConstraint!
    @IBOutlet weak var dataView: ZXUIView!
    @IBOutlet weak var myCapaLB: UILabel!
    
    @IBOutlet weak var tabbgView: ZXUIView!
    @IBOutlet weak var tabview: UITableView!
    fileprivate var capaList: Array<JXCapaSubList?> = []
    weak var delegate: JXPowerTwoCellDelegate? = nil
    
    @IBOutlet weak var lastMonth: UIButton!
    //let datePicker = ZXDatePickerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.contentView.backgroundColor = UIColor.zx_colorRGB(22, 10, 83, 1)
        
        self.ZLZView.backgroundColor = UIColor.zx_colorWithHexString("#6A68FE")
        self.ZLZView.layer.cornerRadius = 10
        self.ZLZView.layer.masksToBounds = true
        
        self.top1ImgV.layer.borderWidth = 1
        self.top1ImgV.layer.borderColor = UIColor.red.cgColor
        
        self.top2ImgV.layer.borderWidth = 1
        self.top2ImgV.layer.borderColor = UIColor.white.cgColor
        
        self.top3ImgV.layer.borderWidth = 1
        self.top3ImgV.layer.borderColor = UIColor.orange.cgColor
        
        self.lastMonth.layer.cornerRadius = self.lastMonth.frame.height * 0.5
        self.lastMonth.layer.masksToBounds = true
        self.lastMonth.backgroundColor = UIColor.orange
        self.lastMonth.titleLabel?.font = UIFont.zx_supMarkFont
        self.lastMonth.setTitleColor(UIColor.white, for: .normal)
        
        self.addGradient(view: self.top1VImgV)
        self.addGradient(view: self.top2VImgV)
        self.addGradient(view: self.top3VImgV)
        
        self.L11.font = UIFont.zx_markFont
        self.L11.textColor = UIColor.white
        self.L11.text = ""
        self.L12.font = UIFont.zx_markFont
        self.L12.textColor = UIColor.white
        self.L12.text = ""
        self.L12.layer.cornerRadius = self.L12.frame.height * 0.5
        self.L12.layer.masksToBounds = true
        
        self.L21.font = UIFont.zx_markFont
        self.L21.textColor = UIColor.white
        self.L21.text = ""
        self.L22.font = UIFont.zx_markFont
        self.L22.textColor = UIColor.white
        self.L22.text = ""
        self.L22.layer.cornerRadius = self.L12.frame.height * 0.5
        self.L22.layer.masksToBounds = true
        
        self.L31.font = UIFont.zx_markFont
        self.L31.textColor = UIColor.white
        self.L31.text = ""
        self.L32.font = UIFont.zx_markFont
        self.L32.textColor = UIColor.white
        self.L32.text = ""
        self.L32.layer.cornerRadius = self.L12.frame.height * 0.5
        self.L32.layer.masksToBounds = true

        self.myCapaLB.font = UIFont.boldSystemFont(ofSize: UIFont.zx_bodyFontSize)
        self.myCapaLB.textColor = UIColor.white
        self.myCapaLB.text = "我的战力值:"
        
        self.zxzLB.font = UIFont.boldSystemFont(ofSize: 22)
        self.zxzLB.textColor = UIColor.white
        self.zxzLB.text = "总战力值:"
        
        BG1View.backgroundColor = UIColor.clear
        
//        let gradient1 = CAGradientLayer()
//        gradient1.colors = [UIColor(red: 0.92, green: 0.64, blue: 0.08, alpha: 1).cgColor, UIColor(red: 0.99, green: 0.87, blue: 0.18, alpha: 1).cgColor]
//        gradient1.locations = [0, 1]
//        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gradient1.frame = CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 15*2, height: BG1View.frame.height)
        //BG1View.layer.insertSublayer(gradient1, at: 0)
        //BG1View.layer.cornerRadius = 32
        
        
        self.dataView.backgroundColor = UIColor.zx_colorRGB(69, 45, 155, 1)
        self.dataView.layer.cornerRadius = self.dataView.frame.height * 0.5
        self.dataView.layer.masksToBounds = true
        
        self.tabbgView.backgroundColor = UIColor.white
        self.tabbgView.layer.cornerRadius = 20
        self.tabbgView.layer.masksToBounds = true
        
        self.tabview.delegate = self
        self.tabview.dataSource = self
        self.tabview.register(UINib(nibName: JXPowerThreeCell.NibName, bundle: nil), forCellReuseIdentifier: JXPowerThreeCell.reuseIdentifier)
        
        //日期
        /*
        let currentDate = ZXDateUtils.current.date(false)
        let dateList = currentDate.components(separatedBy: "-")
        self.yearLB.text = dateList[0]
        self.monLB.text = dateList[1]
        self.dayLB.text = dateList[2]*/
    }
    
    func addGradient(view: UIImageView) {
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.97, green: 0.86, blue: 0.08, alpha: 1).cgColor,UIColor(red: 1, green: 0.42, blue: 0.07, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient1.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient1.frame = CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH*0.3, height: view.bounds.height)
        view.layer.addSublayer(gradient1)
        view.layer.cornerRadius = view.frame.height * 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
   
    @IBAction func lastMonth(_ sender: UIButton) {
        self.delegate?.jx_lastMonth()
    }
    
    @IBAction func dataSelect(_ sender: UIButton) {
//        self.setDate()
        self.delegate?.jx_selectMyCapa()
    }
    
    /*
    func setDate() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -2
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)

        datePicker.show("请选择日期",
                        doneButtonTitle: "确定",
                        cancelButtonTitle: "取消",
                        minimumDate: threeMonthAgo,
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd"
                let dateStr = formatter.string(from: dt)
                let dateList = dateStr.components(separatedBy: "/")
                self.yearLB.text = dateList[0]
                self.monLB.text = dateList[1]
                self.dayLB.text = dateList[2]
                
                self.delegate?.jx_dataSelect(year: dateList[0], month: dateList[1], day: dateList[2])
            }
        }
    }*/
    
    func loadData(list: Array<JXCapaSubList?>, threeList: Array<JXCapaSubList?>, total: String?, myCapa: String?){
        self.addGradientLayer(list: list)
        self.capaList = list
        
        if threeList.count > 0 {
            guard let mod1 = threeList.first else {
                return
            }
            
            if let mo1 = mod1 {
                self.L11.text = mo1.nickName.isEmpty ? "未设置" : mo1.nickName
                self.top1ImgV.kf.setImage(with: URL(string: mo1.headUrl))
                self.L12.text = "\(mo1.capa)"
            }
        }
        
        if threeList.count > 1 {
            let mod2 = threeList[1]
            if let mo2 = mod2 {
                self.L21.text = mo2.nickName.isEmpty ? "未设置" : mo2.nickName
                self.top2ImgV.kf.setImage(with: URL(string: mo2.headUrl))
                self.L22.text = "\(mo2.capa)"
            }
        }
        
        if threeList.count > 2 {
            let mod3 = threeList[2]
            if let mo3 = mod3 {
                self.L31.text = mo3.nickName.isEmpty ? "未设置" : mo3.nickName
                self.top3ImgV.kf.setImage(with: URL(string: mo3.headUrl))
                self.L32.text = "\(mo3.capa)"
            }
        }
        
        self.zxzLB.text = "总战力值：\(total ?? "")"
        
        self.myCapaLB.text = "我的战力值：\(myCapa ?? "")"
        
        self.tabview.reloadData()
    }
    
    func addGradientLayer(list: Array<Any?>) {
        let height: CGFloat = 40 + 60 + 20 + JXPowerThreeCell.height*CGFloat(list.count)
        self.BG1ViewH.constant = height
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.99, green: 0.87, blue: 0.18, alpha: 1).cgColor,UIColor(red: 0.92, green: 0.64, blue: 0.08, alpha: 1).cgColor]
//        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 1)
        gradient1.endPoint = CGPoint(x: 1, y: 1)
        gradient1.frame = CGRect(x: 0, y: 0, width: ZXBOUNDS_WIDTH - 15*2, height: height)
        BG1View.layer.insertSublayer(gradient1, at: 0)
        BG1View.layer.cornerRadius = 32
    }
    
    static func getHeight(list: Array<Any>)-> CGFloat {
        return JXPowerThreeCell.height*CGFloat(list.count) + 20*3 + 60 + 20 + 45 + 127 + 30
    }
}

extension JXPowerTwoCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.capaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JXPowerThreeCell = tableView.dequeueReusableCell(withIdentifier: JXPowerThreeCell.reuseIdentifier, for: indexPath) as! JXPowerThreeCell
        if self.capaList.count > 0 {
            cell.loadData(model: self.capaList[indexPath.row], indexPath: indexPath)
        }
        return cell
    }
}

extension JXPowerTwoCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JXPowerThreeCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mod = self.capaList[indexPath.row]
        self.delegate?.jx_didSelect(model: mod)
    }
}

