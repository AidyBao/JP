//
//  ZXBAutoScrollView.swift
//  PuJin
//
//  Created by 120v on 2019/8/16.
//  Copyright © 2019 ZX. All rights reserved.
//

import UIKit

@objc
public protocol ZXBAutoScrollViewDataSource : class {
    func zx_numberofPages(_ inScrollView:ZXBAutoScrollView) -> Int
    func zx_autoScrollView(_ scrollView:ZXBAutoScrollView,pageAt index:Int) -> UIView
}

@objc
public protocol ZXBAutoScrollViewDelegate : class {
    func zx_autoScrollView(_ scrollView: ZXBAutoScrollView,selectAt index:Int)
    func zx_autoScrollView(_ scrollView: ZXBAutoScrollView, scrollTo index: Int)
}


public extension ZXBAutoScrollViewDelegate {
    func zx_autoScrollView(_ scrollView: ZXBAutoScrollView,selectAt index:Int) {}
    func zx_autoScrollView(_ scrollView: ZXBAutoScrollView, scrollTo index: Int) {}
}


@IBDesignable
public  class ZXBAutoScrollView: UIView {
    weak public var delegate:ZXBAutoScrollViewDelegate?
    weak public var dataSource:ZXBAutoScrollViewDataSource? {
        didSet{
            self.reloadData()
        }
    }
    
    fileprivate var ZXBAutoPageControlH: CGFloat = 28
    fileprivate var ZXBAutoViewGap: CGFloat = 10
    fileprivate var totalPage = 0
    fileprivate var currentPage = 0 {
        didSet {
            if oldValue != currentPage {
                delegate?.zx_autoScrollView(self, scrollTo: currentPage)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func initUI() {
        self.clipsToBounds = true
        
        self.scrollView = UIScrollView(frame: frame)
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.bounces = false
        self.addSubview(scrollView)
        self.scrollView.layer.cornerRadius = 10
        self.scrollView.layer.masksToBounds = true
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        self.pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.zx_colorRGB(195, 195, 195, 1)
        pageControl.currentPageIndicatorTintColor = UIColor.zx_colorRGB(70, 132, 248, 1)
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        pageControl.backgroundColor = UIColor.blue
        self.addSubview(self.pageControl)
        
        self.refreshContentSize()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.refreshContentSize()
        self.loadData()
    }
    
    fileprivate func refreshContentSize() {
        let frame = self.frame
        self.scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width , height: frame.size.height - ZXBAutoPageControlH)
        scrollView.contentSize = CGSize(width: frame.size.width * 3, height: frame.size.height - ZXBAutoPageControlH)
        scrollView.contentOffset = CGPoint(x: frame.size.width, y: 0)
        self.pageControl.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height - ZXBAutoPageControlH/2)
    }
    
    public func reloadData() {
        currentPage = 0
        self.loadData()
    }
    
    fileprivate func loadData() {
        self.stopTimer()
        if let dataSource = dataSource {
            self.totalPage = dataSource.zx_numberofPages(self)
            self.pageControl.numberOfPages = self.totalPage
            self.pageControl.currentPage = self.currentPage
            for view in scrollView.subviews {
                if (view.tag - ZXBAutoScrollView.Config.viewBaseTag) >= 0 {
                    view.removeFromSuperview()
                }
            }
            threeViews.removeAll()
            if totalPage > 0 {
                let pre = (currentPage - 1 + totalPage) % totalPage
                let next = (currentPage + 1) % totalPage
                //Left （n:Last Page， n - 1 Pre Page)
                threeViews.append((self.dataSource?.zx_autoScrollView(self, pageAt: pre))!)
                //Center (1:FirstPage n Current Page)
                threeViews.append((self.dataSource?.zx_autoScrollView(self, pageAt: currentPage))!)
                //Right  （2:SecondPage n + 1:Next Page)
                threeViews.append((self.dataSource?.zx_autoScrollView(self, pageAt: next))!)
                for i in 0..<3 {
                    let aview = threeViews[i]
                    aview.frame = self.scrollView.frame.offsetBy(dx: self.scrollView.frame.size.width * CGFloat(i), dy: 0)
                    aview.tag = ZXBAutoScrollView.Config.viewBaseTag + i
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
                    //flipTimer = Timer.scheduledTimer(timeInterval: flipInterval, target: self, selector: #selector(autoFlipAction), userInfo: nil, repeats: true)
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
        delegate?.zx_autoScrollView(self, selectAt: currentPage)
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

extension ZXBAutoScrollView : UIScrollViewDelegate {
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

extension ZXBAutoScrollView {
    struct Config {
        static let viewBaseTag = 900100
        static let selectedColor = UIColor.blue
        static let unselectedColor = UIColor.lightGray
    }
}
