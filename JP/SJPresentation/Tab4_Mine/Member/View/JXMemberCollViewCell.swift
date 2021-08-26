//
//  JXMemberCollViewCell.swift
//  gold
//
//  Created by SJXC on 2021/4/27.
//

import UIKit

class JXMemberCollViewCell: UITableViewCell {
    @IBOutlet weak var collView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.zx_lightGray
        
        
        self.collView.backgroundColor = UIColor.white
        self.collView.layer.cornerRadius = 10
        self.collView.layer.masksToBounds = true
        self.collView.delegate = self
        self.collView.dataSource = self
        self.collView.register(UINib(nibName: JXMemberListCell.NibName, bundle: nil), forCellWithReuseIdentifier: JXMemberListCell.reuseIdentifier)
    }
    
    func loadData(list: Array<JXNowLevelConfig>) {
        self.memberList = list
        self.collView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    lazy var memberList: Array<JXNowLevelConfig> = {
        let list = Array<JXNowLevelConfig>()
        return list
    }()
}

extension JXMemberCollViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: JXMemberListCell = collectionView.dequeueReusableCell(withReuseIdentifier: JXMemberListCell.reuseIdentifier, for: indexPath) as! JXMemberListCell
        cell.loadData(model: self.memberList[indexPath.row])
        return cell
    }
    
}

extension JXMemberCollViewCell: UICollectionViewDelegate {
    
}

extension JXMemberCollViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (ZX_BOUNDS_WIDTH - 2 * 15 - 3*20) / 2
        return CGSize(width: width, height: 177)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
}
