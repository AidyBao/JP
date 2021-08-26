//
//  ZXAutoScrollView.swift
//  ZXAutoScrollView-Swift
//
//  Created by JuanFelix on 2017/5/17.
//  Copyright © 2017年 screson. All rights reserved.
//

import UIKit

@objc
public protocol ZXAutoScrollViewDataSource : class {
    func numberofPages(_ inScrollView:ZXAutoScrollView) -> Int
    func zxAutoScrollView(_ scrollView:ZXAutoScrollView,pageAt index:Int) -> UIView
}

@objc
public protocol ZXAutoScrollViewDelegate : class {
    func zxAutoScrollView(_ scrollView: ZXAutoScrollView,selectAt index:Int)
    func zxAutoScrollView(_ scrollView: ZXAutoScrollView, scrollTo index: Int)
}

extension ZXAutoScrollViewDelegate {
    func zxAutoScrollView(_ scrollView: ZXAutoScrollView,selectAt index:Int) {}
    func zxAutoScrollView(_ scrollView: ZXAutoScrollView, scrollTo index: Int) {}
}


@IBDesignable
public  class ZXAutoScrollView: UIView {
    weak public var delegate:ZXAutoScrollViewDelegate?
    weak public var dataSource:ZXAutoScrollViewDataSource? {
        didSet{
            self.reloadData()
        }
    }
    
    fileprivate var totalPage = 0
    fileprivate var currentPage = 0 {
        didSet {
            if oldValue != currentPage {
                delegate?.zxAutoScrollView(self, scrollTo: currentPage)
            }
        }
    }
    fileprivate var threeViews = [UIView]()
    fileprivate var flipTimer:Timer?
    var scrollView:UIScrollView!
    
    public var showPageControl: Bool = true
    public var pageControl:UIPageControl!
    public var autoFlip = true {
        didSet {
            checkAutoFlip()
        }
    }
    
    public var flipInterval:TimeInterval = 3.0 {
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
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        self.pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = ZXAutoScrollView.Config.unselectedColor
        pageControl.currentPageIndicatorTintColor = ZXAutoScrollView.Config.selectedColor
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
        self.pageControl.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height - 20)
    }
    
    public func reloadData() {
        currentPage = 0
        self.loadData()
    }
    
    fileprivate func loadData() {
        self.stopTimer()
        if let dataSource = dataSource {
            self.totalPage = dataSource.numberofPages(self)
            self.pageControl.numberOfPages = self.totalPage
            self.pageControl.currentPage = self.currentPage
            for view in scrollView.subviews {
                if (view.tag - ZXAutoScrollView.Config.viewBaseTag) >= 0 {
                    view.removeFromSuperview()
                }
            }
            threeViews.removeAll()
            if totalPage > 0 {
                let pre = (currentPage - 1 + totalPage) % totalPage
                let next = (currentPage + 1) % totalPage
                //Left （n:Last Page， n - 1 Pre Page)
                threeViews.append((self.dataSource?.zxAutoScrollView(self, pageAt: pre))!)
                //Center (1:FirstPage n Current Page)
                threeViews.append((self.dataSource?.zxAutoScrollView(self, pageAt: currentPage))!)
                //Right  （2:SecondPage n + 1:Next Page)
                threeViews.append((self.dataSource?.zxAutoScrollView(self, pageAt: next))!)
                for i in 0..<3 {
                    let aview = threeViews[i]
                    aview.frame = self.scrollView.frame.offsetBy(dx: self.scrollView.frame.size.width * CGFloat(i), dy: 0)
                    aview.tag = ZXAutoScrollView.Config.viewBaseTag + i
                    aview.clipsToBounds = true
                    aview.isUserInteractionEnabled = true
                    aview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureAction)))
                    self.scrollView.addSubview(aview)
                }
                self.refreshContentSize()
                if totalPage > 1 {
                    self.scrollView.isScrollEnabled = true
                    if showPageControl {
                        pageControl.isHidden = false
                    } else {
                        pageControl.isHidden = true
                    }
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
                    flipTimer = Timer.hzx_scheduledTimer(timeInterval: flipInterval, repeats: true) { [weak self] (timer) in
                        self?.autoFlipAction()
                    }
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
        delegate?.zxAutoScrollView(self, selectAt: currentPage)
    }
    
    func autoFlipAction() {
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
}

extension ZXAutoScrollView : UIScrollViewDelegate {
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

extension ZXAutoScrollView {
    struct Config {
        static let viewBaseTag = 900100
        static let selectedColor = UIColor(red: 59 / 255.0, green: 135 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        static let unselectedColor = UIColor.white
    }
}
