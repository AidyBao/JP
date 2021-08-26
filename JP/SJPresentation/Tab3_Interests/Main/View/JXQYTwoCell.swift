//
//  JXQYTwoCell.swift
//  gold
//
//  Created by SJXC on 2021/5/24.
//

import UIKit

protocol JXQYTwoCellDelegate: NSObjectProtocol {
    func jx_didCollView(model: JXQYModel?) -> Void
}

class JXQYTwoCell: UITableViewCell {
    
    @IBOutlet weak var clvView: UICollectionView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    @IBOutlet weak var clvBGView: UIView!
    weak var delegate: JXQYTwoCellDelegate? = nil
    fileprivate var list = [JXQYModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = .zx_lightGray
        self.titleView.backgroundColor = .zx_lightGray
        
        self.lb1.font = UIFont.boldSystemFont(ofSize: UIFont.zx_bodyFontSize)
        self.lb1.textColor = UIColor.zx_textColorTitle
        
        self.lb2.font = UIFont.zx_bodyFont
        self.lb2.textColor = UIColor.red
        
        self.clvBGView.layer.cornerRadius = 10
        self.clvBGView.layer.masksToBounds = true
        
        self.clvView.backgroundColor = UIColor.white
        self.clvView.delegate = self
        self.clvView.dataSource = self
        self.clvView.register(UINib.init(nibName: JXQYThreeCell.NibName, bundle: nil), forCellWithReuseIdentifier: JXQYThreeCell.reuseIdentifier)
    }
    
    func loadData(listmodel: [JXQYModel]) {
        if listmodel.count > 0 {
            self.list = listmodel
            self.clvView.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension JXQYTwoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.list.count > 0 {
            self.delegate?.jx_didCollView(model: self.list[indexPath.row])
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXQYThreeCell.reuseIdentifier, for: indexPath) as! JXQYThreeCell
        cell.loadData(model: self.list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat((ZXBOUNDS_WIDTH - 30) / 5)
        return CGSize(width: width, height: self.clvView.frame.height * 0.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}
