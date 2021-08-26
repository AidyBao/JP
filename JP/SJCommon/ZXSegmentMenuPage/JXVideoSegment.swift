//
//  JXVideoSegment.swift
//  gold
//
//  Created by SJXC on 2021/6/30.
//

import UIKit
import UIKit

protocol JXVideoSegmentDelegate: AnyObject {
    func zxSegmentMenuPage(menuPage: JXVideoSegment, selectedAt index: Int)
}

protocol JXVideoSegmentDataSource: AnyObject {
    func zxSegmentMenuPage(menuPage: JXVideoSegment, titleFor index: Int) -> String
    func zxSegmentMenuPage(menuPage: JXVideoSegment, viewAt index: Int) -> UIView
    func numberOfPageInzxSegmentMenuPage(menuPage: JXVideoSegment) -> Int
    
    func zxSegmentMenuPage(menuPage: JXVideoSegment, showDotAt index: Int) -> Bool
    func zxSegmentMenuPage(menuPage: JXVideoSegment, unreadMsgCountAt index: Int) -> Int
}

extension JXVideoSegmentDataSource {
    func zxSegmentMenuPage(menuPage: JXVideoSegment, showDotAt index: Int) -> Bool { return false }
    func zxSegmentMenuPage(menuPage: JXVideoSegment, unreadMsgCountAt index: Int) -> Int { return 0 }
}

class JXVideoSegment: UIView {
    
    var config = ZXSegmentMenuConfig()
    weak var delegate: JXVideoSegmentDelegate?
    weak var dataSource: JXVideoSegmentDataSource? {
        didSet {
            self.reloadData()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            delegate?.zxSegmentMenuPage(menuPage: self, selectedAt: selectedIndex)
            if selectedIndex < dataCount {
                self.ccvList.selectItem(at: IndexPath.init(row: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
    fileprivate var ccvList: UICollectionView!
    fileprivate var zxContentView: UIScrollView!
    
    weak fileprivate var parentController: UIViewController?
    fileprivate var menuHeight: CGFloat = 40
    fileprivate var zxWidth: CGFloat = 0
    fileprivate var zxHeight: CGFloat = 0
    fileprivate var zxCollViewWidth: CGFloat = 0
    fileprivate var zxContentHeight: CGFloat = 0
    fileprivate var arrMenuModel: Array<ZXSegmentMenuCellModel> = []
    var childViews: Array<UIView> = []
    var childViewControllers: Array<UIViewController> = []
    fileprivate var dataCount = 0
    fileprivate var menuCountAtOnepage = 0//均等分页
    fileprivate var sLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame frameA: CGRect,
                     menuHeight mHeight: CGFloat,
                     menuCountAtOnePage mCount: Int,
                     parentController pcontroler: UIViewController,
                     hasNavBar: Bool = false,
                     hasTabBar: Bool = false,
                     isEnabledScroll: Bool = true) {
       
        self.init(frame: CGRect.zero)
        
        var navBarHeight: CGFloat = 0
        var tabBarHeight: CGFloat = 0
        if frameA.size.height == UIScreen.main.bounds.size.height {
            if let navVC = pcontroler.navigationController, (navVC.navigationBar.window != nil) {
                if hasNavBar {
                    navBarHeight = navVC.navigationBar.frame.size.height
                    navBarHeight += 20
                }
            }
            if let tabbarVC = pcontroler.tabBarController, (tabbarVC.tabBar.window != nil || hasTabBar) {
                if hasTabBar {
                    tabBarHeight = tabbarVC.tabBar.frame.size.height
                }
            }
            if UIScreen.main.bounds.size.height >= 812 {//iPhoneX
                navBarHeight += 24
            }
        }
        self.frame = CGRect(x: frameA.origin.x, y: frameA.origin.y, width:frameA.size.width , height: (frameA.size.height - navBarHeight - tabBarHeight))
//        self.zxHeight = frameA.size.height - navBarHeight - tabBarHeight
//        self.zxContentHeight = self.zxHeight - mHeight
        
        self.zxHeight = frameA.size.height
        self.zxWidth = frameA.size.width
        self.menuHeight = mHeight
        self.zxContentHeight = self.zxHeight
        self.zxCollViewWidth = 120
        self.parentController = pcontroler
        self.menuCountAtOnepage = mCount


        self.zxContentView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.zxWidth, height: self.zxContentHeight))
        self.zxContentView.contentInsetAdjustmentBehavior = .never
        self.zxContentView.showsHorizontalScrollIndicator = false
        self.zxContentView.showsHorizontalScrollIndicator = false
        self.zxContentView.bounces = false
        self.zxContentView.delegate = self
        self.zxContentView.isPagingEnabled = true
        self.zxContentView.isScrollEnabled = isEnabledScroll
        self.addSubview(self.zxContentView)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.ccvList = UICollectionView.init(frame: CGRect(x: (zxWidth - zxCollViewWidth)*0.5, y: 40, width: zxCollViewWidth, height: menuHeight), collectionViewLayout: layout)
        self.ccvList.backgroundColor = UIColor.clear
        self.ccvList.register(UINib.init(nibName: "ZXSegmentMenuCell", bundle: nil), forCellWithReuseIdentifier: "ZXSegmentMenuCell")
        self.ccvList.showsVerticalScrollIndicator = false
        self.ccvList.showsHorizontalScrollIndicator = false
        self.ccvList.delegate = self
        self.ccvList.dataSource = self
        self.addSubview(self.ccvList)
        
        self.sLine.frame = CGRect(x: 0, y: menuHeight, width: self.zxWidth, height: 0.5)
        self.sLine.backgroundColor = UIColor.lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        
        for sView in self.childViews {
            sView.removeFromSuperview()
        }
        self.childViews.removeAll()
        
        for sVC in self.childViewControllers {
            sVC.removeFromParent()
        }
        self.childViewControllers.removeAll()

        self.arrMenuModel.removeAll()
        
        if let dataSource = dataSource {
            self.dataCount = dataSource.numberOfPageInzxSegmentMenuPage(menuPage: self)
            self.zxContentView.contentSize = CGSize(width: self.zxWidth * CGFloat(self.dataCount), height: self.zxContentHeight)
            for i in 0..<self.dataCount {
                let model = ZXSegmentMenuCellModel()
                model.name = dataSource.zxSegmentMenuPage(menuPage: self, titleFor: i)
                model.unreadMsgCount = dataSource.zxSegmentMenuPage(menuPage: self, unreadMsgCountAt: i)
                model.showDot = dataSource.zxSegmentMenuPage(menuPage: self, showDotAt: i)
                self.arrMenuModel.append(model)
                let tempView = dataSource.zxSegmentMenuPage(menuPage: self, viewAt: i)
                let frame = CGRect(x: self.zxWidth * CGFloat(i), y: 0, width: self.zxWidth, height: self.zxContentHeight)
                tempView.frame = frame
                self.zxContentView.addSubview(tempView)
                self.childViews.append(tempView)
                if let next = tempView.next, let vc = next as? UIViewController, vc != self.parentController {
                    self.childViewControllers.append(vc)
                    self.parentController?.addChild(vc)
                }
            }
        }
        self.ccvList.reloadData()
        if self.selectedIndex < self.dataCount {
            self.ccvList.selectItem(at: IndexPath.init(row: self.selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func reloadTitle() {
        if let dataSource = dataSource {
            let index = self.selectedIndex
            self.arrMenuModel.removeAll()
            self.dataCount = dataSource.numberOfPageInzxSegmentMenuPage(menuPage: self)
            for i in 0..<self.dataCount {
                let model = ZXSegmentMenuCellModel()
                model.name = dataSource.zxSegmentMenuPage(menuPage: self, titleFor: i)
                model.unreadMsgCount = dataSource.zxSegmentMenuPage(menuPage: self, unreadMsgCountAt: i)
                model.showDot = dataSource.zxSegmentMenuPage(menuPage: self, showDotAt: i)
                self.arrMenuModel.append(model)
            }
            self.ccvList.reloadData()
            self.selectedIndex = index
        }
    }
}

extension JXVideoSegment: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.zxContentView.contentOffset = CGPoint(x: self.zxWidth * CGFloat(indexPath.row), y: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZXSegmentMenuCell", for: indexPath) as! ZXSegmentMenuCell
        cell.reloadData(model: self.arrMenuModel[indexPath.row], config: config)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMenuModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.arrMenuModel[indexPath.row]
        if menuCountAtOnepage > 0 {
            return CGSize(width: self.zxCollViewWidth / CGFloat(menuCountAtOnepage), height: self.menuHeight)
        } else {
            return CGSize(width: model.width, height: self.menuHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension JXVideoSegment: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.zxContentView {
            let offset = scrollView.contentOffset
            let page = Int(floor((offset.x + self.zxWidth / 2) / self.zxWidth))
            if page != self.selectedIndex {
                self.ccvList.selectItem(at: IndexPath.init(row: page, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                self.selectedIndex = page
            }
        }
    }
}

