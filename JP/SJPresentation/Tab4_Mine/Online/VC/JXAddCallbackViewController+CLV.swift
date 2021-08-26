//
//  JXAddCallbackViewController+CLV.swift
//  gold
//
//  Created by SJXC on 2021/4/7.
//

import Foundation
import UIKit

extension JXAddCallbackViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeCLV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXProblemTypeCell.reuseIdentifier, for: indexPath) as! JXProblemTypeCell
            cell.loadData(model: self.probTypeList[indexPath.row])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JXProblemSelectImgCell.reuseIdentifier, for: indexPath) as! JXProblemSelectImgCell
            cell.loadData(images: self.probImgs, indexPath: indexPath)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCLV {
            return self.probTypeList.count
        }else {
            if probImgs.count > 0 {
                if probImgs.count < maxCount {
                    return probImgs.count + 1
                }
                return probImgs.count
            }
            return 1//用于添加图片
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension JXAddCallbackViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if collectionView == typeCLV {
            let model = self.probTypeList[indexPath.row]
            self.typeModel = model
        }else{
            if self.probImgs.count > 0 {
                if indexPath.row == self.probImgs.count {
                    self.addImage()
                }
            }else{
                self.addImage()
            }
        }
    }
}

extension JXAddCallbackViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == typeCLV {
            let width = (ZX_BOUNDS_WIDTH - 2 * 15 - 25) / 2
            return CGSize(width: width, height: 60)
        }else{
            let width = (ZX_BOUNDS_WIDTH - 2 * 15 - 15*2) / 3
            return CGSize(width: width, height: width)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


extension JXAddCallbackViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.view.endEditing(true)
    }
}
