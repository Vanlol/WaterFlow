//
//  MyCollViewCell.swift
//  SwiftWaterFlow
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit

class MyCollViewCell: UICollectionViewCell {
    
    @IBOutlet weak var naLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


protocol NewFlowLayoutDelegate:NSObjectProtocol {
    func waterFlowLayout(waterFlow:NewFlowLayout,index:Int,itemWidth:CGFloat) -> CGFloat
    
}

class NewFlowLayout: UICollectionViewLayout {
    
    weak var delegate:NewFlowLayoutDelegate?
    
    //默认列数
    fileprivate var defaultColumnCount:CGFloat = 3
    //默认列间距
    fileprivate var defaultColumnMargin:CGFloat = 10
    //默认行间距
    fileprivate var defaultRowMargin:CGFloat = 10
    //默认边缘间距
    fileprivate var defaultEdgeInsets:UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    //存放所有列的当前高度
    fileprivate lazy var columnHeights = [CGFloat]()
    //布局属性数组
    fileprivate lazy var attrs = [UICollectionViewLayoutAttributes]()
    //内容容量
    fileprivate var contentHeight:CGFloat = 0
    
    override func prepare() {
        super.prepare()
        //
        contentHeight = 0
        columnHeights.removeAll()
        for _ in 0..<Int(defaultColumnCount) {
            columnHeights.append(defaultEdgeInsets.top)
        }
        attrs.removeAll()
        let count = (collectionView?.numberOfItems(inSection: 0))!
        for index in 0..<count {
            let indexP = IndexPath(item: index, section: 0)
            let attr = layoutAttributesForItem(at: indexP)
            attrs.append(attr!)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let collectionW = collectionView?.frame.size.width
        
        let w:CGFloat = (collectionW! - defaultEdgeInsets.left - defaultEdgeInsets.right - (defaultColumnCount - 1)*defaultColumnMargin) / defaultColumnCount
        
        let h:CGFloat = (delegate?.waterFlowLayout(waterFlow: self, index: indexPath.item, itemWidth: w))!
        
        //找出目标列
        var destColumn = 0
        var minColumnHeight:CGFloat = columnHeights[0]
        for index in 1..<Int(defaultColumnCount) {
            let columnHeight = columnHeights[index]
            if minColumnHeight > columnHeight {
                minColumnHeight = columnHeight
                destColumn = index
            }
        }
        let x:CGFloat = defaultEdgeInsets.left + (w + defaultColumnMargin) * CGFloat(destColumn)
        var y:CGFloat = minColumnHeight
        if y != defaultEdgeInsets.top {
            y += defaultRowMargin
        }
        attr.frame = CGRect(x: x, y: y, width: w, height: h)
        columnHeights[destColumn] = attr.frame.maxY
        
        let columnHeight = columnHeights[destColumn]
        if contentHeight < columnHeight {
            contentHeight = columnHeight
        }
        
        return attr
    }
    
    override var collectionViewContentSize: CGSize{
        get{
            return CGSize(width: 0, height: contentHeight + defaultEdgeInsets.bottom)
        }
    }
    
}




