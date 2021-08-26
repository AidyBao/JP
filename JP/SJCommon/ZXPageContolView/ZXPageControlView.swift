//
//  ZXPageControlView.swift
//  ZXPageControlView_Example
//
//  Created by 120v on 2018/6/26.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

@objc
public protocol ZXPageControlViewDataSource : class {
    func numberofPages(_ inScrollView:ZXPageControlView) -> Int
    func zxPageControlView(_ scrollView:ZXPageControlView,pageAt index:Int) -> UIView
}

@objc
public protocol ZXPageControlViewDelegate : class {
    func zxAutoScrolView(_ scrollView:ZXPageControlView,selectAt index:Int)
}

extension ZXPageControlViewDelegate {
    func zxAutoScrolView(_ scrollView:ZXPageControlView,selectAt index:Int){}
}


@IBDesignable
public  class ZXPageControlView: UIView {
    weak public var delegate:ZXPageControlViewDelegate?
    weak public var dataSource:ZXPageControlViewDataSource? {
        didSet{
            self.initUI()
            self.reloadData()
        }
    }
    
    fileprivate var totalPage = 0
    fileprivate var currentPage = 0
    fileprivate var threeViews = [UIView]()
    fileprivate var flipTimer:Timer?
    fileprivate var scrollView:UIScrollView!
    fileprivate var dealloc = false
    
    var pageControl:ZXUIPageControl!
    
    public var autoFlip = true {
        didSet {
            checkAutoFlip()
        }
    }
    
    public var flipInterval:TimeInterval = 2.0 {
        didSet {
            self.stopTimer()
            self.autoFlip = true
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
        
    fileprivate func initUI() {
        self.scrollView = UIScrollView(frame: frame)
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.bounces = false
        self.addSubview(scrollView)
        
        self.scrollView.layer.shadowColor = UIColor.zx_shadowColor.cgColor
        self.scrollView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.scrollView.layer.shadowOpacity = 0.2
        self.scrollView.layer.shadowRadius = 8.0
        self.scrollView.layer.cornerRadius = 8.0
        self.scrollView.layer.masksToBounds = true        
        
        self.pageControl = ZXUIPageControl()
        self.pageControl.backgroundColor = UIColor.clear
        pageControl.pageIndicatorTintColor = ZXPageControlView.Config.unselectedColor
        pageControl.currentPageIndicatorTintColor = ZXPageControlView.Config.selectedColor
        pageControl.numberOfPages = 0
        self.addSubview(self.pageControl)
        
        self.refreshContentSize()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.refreshContentSize()
        self.loadData()
    }
    
    fileprivate func refreshContentSize() {
        let frame = self.frame
        self.scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        scrollView.contentSize = CGSize(width: frame.size.width * 3, height: frame.size.height)
        scrollView.contentOffset = CGPoint(x: frame.size.width, y: 0)
        self.pageControl.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height - 15)
        self.pageControl.frame.size = CGSize(width: 300, height: 20)
    }
    
    public func reloadData() {
        if dealloc {
            return
        }
        currentPage = 0
        self.loadData()
    }
    
    fileprivate func loadData() {
        if dealloc {
            return
        }
        self.stopTimer()
        if let dataSource = dataSource {
            self.totalPage = dataSource.numberofPages(self)
            self.pageControl.numberOfPages = self.totalPage
            self.pageControl.currentPage = self.currentPage
            for view in scrollView.subviews {
                if (view.tag - ZXPageControlView.Config.viewBaseTag) >= 0 {
                    view.removeFromSuperview()
                }
            }
            threeViews.removeAll()
            if totalPage > 0 {
                let pre = (currentPage - 1 + totalPage) % totalPage
                let next = (currentPage + 1) % totalPage
                //Left （n:Last Page， n - 1 Pre Page)
                threeViews.append((self.dataSource?.zxPageControlView(self, pageAt: pre))!)
                //Center (1:FirstPage n Current Page)
                threeViews.append((self.dataSource?.zxPageControlView(self, pageAt: currentPage))!)
                //Right  （2:SecondPage n + 1:Next Page)
                threeViews.append((self.dataSource?.zxPageControlView(self, pageAt: next))!)
                for i in 0..<3 {
                    let aview = threeViews[i]
                    aview.frame = self.scrollView.frame.offsetBy(dx: self.scrollView.frame.size.width * CGFloat(i), dy: 0)
                    aview.tag = ZXPageControlView.Config.viewBaseTag + i
                    aview.clipsToBounds = true
                    aview.isUserInteractionEnabled = true
                    aview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureAction)))
                    self.scrollView.addSubview(aview)
                }
                self.refreshContentSize()
                if totalPage > 1 {
                    self.scrollView.isScrollEnabled = true
                    pageControl.isHidden = false
                } else {
                    self.scrollView.isScrollEnabled = false
                    pageControl.isHidden = true
                }
            }
        }
        self.checkAutoFlip()
    }
    
    fileprivate func checkAutoFlip () {
        if totalPage > 1 {
            if autoFlip {
                if flipTimer == nil {
                    flipTimer = Timer.scheduledTimer(timeInterval: flipInterval, target: self, selector: #selector(autoFlipAction), userInfo: nil, repeats: true)
                    RunLoop.current.add(flipTimer!, forMode: RunLoop.Mode.common)
                } else {
                    flipTimer?.fireDate = Date()
                }
            } else {
                self.stopTimer()
            }
        }
    }
    
    @objc func tapGestureAction() {
        delegate?.zxAutoScrolView(self, selectAt: currentPage)
    }
    
    @objc func autoFlipAction() {
        if totalPage > 1 {
            let offsetX = self.scrollView.contentOffset.x + scrollView.frame.size.width
            let index = Int(offsetX / scrollView.frame.size.width + 0.5)
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * self.scrollView.frame.size.width, y: 0), animated: true)
        }
    }
    
    //Timer
    fileprivate func pauseTimer() {
        if flipTimer != nil {
            flipTimer?.fireDate = Date.distantFuture
        }
    }
    
    fileprivate func resumeTimer() {
        if flipTimer != nil {
            flipTimer?.fireDate = Date.init(timeIntervalSinceNow: self.flipInterval)
        }
    }
    
    fileprivate func stopTimer() {
        if flipTimer != nil {
            flipTimer?.invalidate()
            flipTimer = nil
        }
    }
    
    override public func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            dealloc = true
            self.stopTimer()
        } else {
            dealloc = false
            self.checkAutoFlip()
        }
    }
}

extension ZXPageControlView : UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if autoFlip,totalPage > 1 {
            let offsetX = scrollView.contentOffset.x
            if offsetX >= scrollView.frame.size.width * 2 {
                currentPage = (currentPage + 1) % totalPage
                self.loadData()
            } else if offsetX <= 0 {
                currentPage = (currentPage - 1 + totalPage ) % totalPage
                self.loadData()
            }
            //resume timer
            self.resumeTimer()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !autoFlip,totalPage > 1 {
            let offsetX = scrollView.contentOffset.x
            if offsetX >= scrollView.frame.size.width * 2 {
                currentPage = (currentPage + 1) % totalPage
                self.loadData()
            } else if offsetX <= 0 {
                currentPage = (currentPage - 1 + totalPage ) % totalPage
                self.loadData()
            }
            //resume timer
            self.resumeTimer()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoFlip {
            self.pauseTimer()
        }
    }
}

extension ZXPageControlView {
    struct Config {
        static let viewBaseTag = 900100
        static let selectedColor = UIColor.zx_colorWithHexString("#FECC00")
        static let unselectedColor = UIColor.zx_lightGray
    }
}

