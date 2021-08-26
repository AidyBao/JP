//
//  JXAutoScrollView.swift
//  gold
//
//  Created by SJXC on 2021/4/24.
//

import UIKit

class JXAutoScrollView: UIViewController,UITableViewDelegate,UITableViewDataSource{

     var tableView:UITableView!
     var doubleTableView:UITableView!
     let kScreenW = UIScreen.main.bounds.size.width
     let kXPercent = UIScreen.main.bounds.size.width / 375.0
     let kBorderW = CGFloat(15.0)
     let kYPercent = UIScreen.main.bounds.size.width / 375.0
     let cellId:String = "drawViewCell1"

     override func viewDidLoad() {
        super.viewDidLoad()
        self.addListTableView()
     }
     func addListTableView(){

         let tableWidth = kScreenW - kBorderW*3
         let tableBgView = UIView(frame: CGRect(x: (kScreenW-tableWidth)/2.0,y: 100*kYPercent,width: tableWidth,height: 148*kYPercent))
         tableBgView.clipsToBounds = true
         tableBgView.backgroundColor = UIColor.yellow
         self.view.addSubview(tableBgView)
         //

        tableView = UITableView(frame: CGRect(x: 0,y: 0,width: tableWidth,height: 148*kYPercent*2), style: UITableView.Style.plain)
         tableView.backgroundColor = UIColor.clear
         tableView.delegate = self
         tableView.dataSource = self
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
         tableBgView.addSubview(tableView)


            doubleTableView = UITableView(frame: CGRect(x: 0,y: tableView.frame.origin.y+tableView.frame.size.height,width: tableWidth,height: 148*kYPercent*2), style: UITableView.Style.plain)
         doubleTableView.backgroundColor = UIColor.clear
         doubleTableView.delegate = self
         doubleTableView.dataSource = self
            doubleTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
         tableBgView.addSubview(doubleTableView)

         //
         Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(personListScroll(timer:)), userInfo: nil, repeats: true)
     }
     @objc func personListScroll(timer:Timer){

         // 1>移动tableView的frame
         var newTableViewframe = self.tableView.frame
         newTableViewframe.origin.y -= 2*kYPercent
         if (newTableViewframe.origin.y < -(doubleTableView.frame.size.height)) {

            newTableViewframe.origin.y = tableView.frame.size.height
         }
         self.tableView.frame = newTableViewframe

         // 2>移动doubleTableView的frame
         var newDoubleViewframe = self.doubleTableView.frame
         newDoubleViewframe.origin.y -= 2*kYPercent
         if newDoubleViewframe.origin.y < -(tableView.frame.size.height) {

          newDoubleViewframe.origin.y = tableView.frame.size.height
         }
         self.doubleTableView.frame = newDoubleViewframe

     }

     //返回行的个数
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
     }
     //返回列的个数
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
     }
     //去除头部空白
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
     }
     //去除尾部空白
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
     }
     //返回一个cell
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

         //回收池
         var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellId)

         if cell == nil{//判断是否为nil

            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
         }
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none

         if tableView == self.tableView{// 测试是否循环滚动

            cell.textLabel?.text = "张先生"
         }else {

            cell.textLabel?.text = "李小姐"
         }

         return cell
     }
     //返回cell的高度
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{

        return 148/5.0*kYPercent
     }


     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

     }


}
