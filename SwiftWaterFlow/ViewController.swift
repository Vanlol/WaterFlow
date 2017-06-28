//
//  ViewController.swift
//  SwiftWaterFlow
//
//  Created by admin on 17/6/9.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var contentCollVi: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = NewFlowLayout()
        layout.delegate = self
        contentCollVi.collectionViewLayout = layout
        contentCollVi.register(UINib(nibName: "MyCollViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCollViewCellID")
        
        
    }
    
    
    
    
    
}

extension ViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollViewCellID", for: indexPath) as! MyCollViewCell
        
        cell.naLab.text = "\(indexPath.item)"
        
        return cell
    }
    
}

extension ViewController:NewFlowLayoutDelegate {
    
    func waterFlowLayout(waterFlow: NewFlowLayout, index: Int, itemWidth: CGFloat) -> CGFloat {
        return CGFloat(100 + arc4random_uniform(50))
    }
    
}



class WaterFlowLayout: UICollectionViewLayout {
    
    lazy var attributesArray = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        attributesArray.removeAll()
        collectionView?.contentSize = CGSize(width: 0, height: 1000)
        
        let total = (collectionView?.numberOfItems(inSection: 0))!
        for index in 0..<total {
            let indexPath = IndexPath(item: index, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributesArray.append(attribute)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesArray[0]
    }
    
    
    
}


class CustomLayout: UICollectionViewLayout {
    
    fileprivate lazy var attributesArray:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        attributesArray.removeAll()
        let total = (collectionView?.numberOfItems(inSection: 0))!
        
        for index in 0..<total {
            let indexPath = IndexPath(item: index, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            
            
            attributesArray.append(attribute)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
    
    
    
}



class MyFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        /**
         0.UICollectionViewLayoutAttributs约束属性
         1.一个cell就对应一个UICollectionViewLayoutAttributs对象
         2.UICollectionViewLayoutAttrinuts对象决定了cell的展示样式,即:frame
         */
        
        scrollDirection = .horizontal
        itemSize = CGSize(width: 150, height: 150)
        sectionInset = UIEdgeInsets(top: 0, left: 75, bottom: 0, right: 75)
        
    }
    /**
     当collectionview的显示范围发生改变的时候是否要重新刷新布局(Invalidate,刷新)
     一旦重新刷新布局就会重新调用layoutAttributesForElements这个方法
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /**
     这个方法的返回值是一个数组(数组内存放着rect范围内所有元素的布局属性)
     这个方法的返回值决定了rect范围内所有元素的排布,即:frame
     */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attrs = super.layoutAttributesForElements(in: rect)
        
        //需要进行比较的两个值(需要找到的是间距,也就是距离差)
        //1. collectionview的contentoffset + collevtionview的宽度的一半
        //2. layoutAttributes的center.x
        let first = (collectionView?.contentOffset.x)! + (collectionView?.bounds.size.width)! * 0.5
        
        
        for attributes in attrs! {
            let second = attributes.center.x
            let delta = abs(first - second)
            let scale = 1 - (delta / (collectionView?.bounds.size.width)!)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
            //print(delta)
        }
        
        
        return attrs
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let rect = CGRect(x: proposedContentOffset.x, y: 0, width: (collectionView?.frame.size.width)!, height: (collectionView?.frame.size.height)!)
        let attributes = super.layoutAttributesForElements(in: rect)
        let first = proposedContentOffset.x + (collectionView?.bounds.size.width)! * 0.5
        var minDetal = CGFloat(MAXFLOAT)
        
        for attr in attributes! {
            let second = attr.center.x
            if abs(minDetal) > abs(first - second) {
                minDetal = second - first
            }
        }
        let newPoint = CGPoint(x: proposedContentOffset.x + minDetal, y: proposedContentOffset.y)
        
        return newPoint
    }
    
    
}






















