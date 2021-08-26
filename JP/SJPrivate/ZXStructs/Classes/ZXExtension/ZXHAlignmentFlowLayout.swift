//
//  ZXHAlignmentFlowLayout.swift
//  AGG
//
//  Created by screson on 2019/4/30.
//  Copyright © 2019 screson. All rights reserved.
//

import UIKit

enum ZXHAlignmentType : Int {
    case left   = 0
    case center = 1
    case right  = 2
}
class ZXHAlignmentFlowLayout: UICollectionViewFlowLayout {
    var betweenOfCell : CGFloat {
        didSet{
            self.minimumInteritemSpacing = betweenOfCell
        }
    }
    var alignmentType : ZXHAlignmentType = .center
    //在居中对齐的时候需要知道这行所有cell的宽度总和
    var sumCellWidth : CGFloat = 0.0
    
    override init() {
        betweenOfCell = 5.0
        super.init()
        scrollDirection = UICollectionView.ScrollDirection.vertical
        minimumLineSpacing = 5
        sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    convenience init(_ alignmentType:ZXHAlignmentType){
        self.init()
        self.alignmentType = alignmentType
    }
    
    convenience init(_ alignmentType: ZXHAlignmentType, _ betweenOfCell: CGFloat){
        self.init()
        self.alignmentType = alignmentType
        self.betweenOfCell = betweenOfCell
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes_super : [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect) ?? [UICollectionViewLayoutAttributes]()
        let layoutAttributes:[UICollectionViewLayoutAttributes] = NSArray(array: layoutAttributes_super, copyItems:true)as! [UICollectionViewLayoutAttributes]
        var layoutAttributes_t : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        for index in 0..<layoutAttributes.count{
            
            let currentAttr = layoutAttributes[index]
            let previousAttr = index == 0 ? nil : layoutAttributes[index-1]
            let nextAttr = index + 1 == layoutAttributes.count ?
                nil : layoutAttributes[index+1]
            
            layoutAttributes_t.append(currentAttr)
            sumCellWidth += currentAttr.frame.size.width
            
            let previousY :CGFloat = previousAttr == nil ? 0 : previousAttr!.frame.maxY
            let currentY :CGFloat = currentAttr.frame.maxY
            let nextY:CGFloat = nextAttr == nil ? 0 : nextAttr!.frame.maxY
            
            if currentY != previousY && currentY != nextY{
                if currentAttr.representedElementKind == UICollectionView.elementKindSectionHeader{
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                } else if currentAttr.representedElementKind == UICollectionView.elementKindSectionFooter{
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                } else{
                    self.setCellFrame(with: layoutAttributes_t)
                    layoutAttributes_t.removeAll()
                    sumCellWidth = 0.0
                }
            } else if currentY != nextY{
                self.setCellFrame(with: layoutAttributes_t)
                layoutAttributes_t.removeAll()
                sumCellWidth = 0.0
            }
        }
        return layoutAttributes
    }
    
    /// 调整Cell的Frame
    ///
    /// - Parameter layoutAttributes: layoutAttribute 数组
    func setCellFrame(with layoutAttributes : [UICollectionViewLayoutAttributes]){
        var nowWidth : CGFloat = 0.0
        switch alignmentType {
        case .left:
            nowWidth = self.sectionInset.left
            for attributes in layoutAttributes{
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = nowFrame
                nowWidth += nowFrame.size.width + self.betweenOfCell
            }
            
        case .center:
            nowWidth = (self.collectionView!.frame.size.width - sumCellWidth - (CGFloat(layoutAttributes.count - 1) * betweenOfCell)) / 2
            for attributes in layoutAttributes{
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth
                attributes.frame = nowFrame
                nowWidth += nowFrame.size.width + self.betweenOfCell
            }
            
        case .right:
            nowWidth = self.collectionView!.frame.size.width - self.sectionInset.right
            for var index in 0 ..< layoutAttributes.count{
                index = layoutAttributes.count - 1 - index
                let attributes = layoutAttributes[index]
                var nowFrame = attributes.frame
                nowFrame.origin.x = nowWidth - nowFrame.size.width
                attributes.frame = nowFrame
                nowWidth = nowWidth - nowFrame.size.width - betweenOfCell
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        betweenOfCell = 5.0
        super.init(coder: aDecoder)
    }
}
