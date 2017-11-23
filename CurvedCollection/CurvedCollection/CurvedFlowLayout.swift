//
//  CurvedFlowLayout.swift
//  CurvedFlowLayout
//
//  Created by Hari Kunwar on 11/10/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit

// Concave, Convex
enum Shape: String {
    case concave = "concave"
    case convex = "convex"
    case isoscelesTrapezoid = "isoscelesTrapezoid"
}

class CurvedFlowLayout: UICollectionViewFlowLayout {
    var shape: Shape = .convex
    var curveDampner: Int = 6
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let attributes = shapedAttributes(layoutAttributes, shape: shape, curveDampner: curveDampner)
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.layoutAttributesForItem(at: indexPath)
        return attribute
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

extension UICollectionViewFlowLayout {
    
    func shapedAttributes(_ layoutAttributes: [UICollectionViewLayoutAttributes], shape: Shape, curveDampner: Int) -> [UICollectionViewLayoutAttributes] {
        let attributes: [UICollectionViewLayoutAttributes]
        switch shape {
        case .concave:
            attributes = concave(layoutAttributes, curveDampner: curveDampner)
        case .convex:
            attributes = convex(layoutAttributes, curveDampner: curveDampner)
        case .isoscelesTrapezoid:
            attributes = isoscelesTrapezoid(layoutAttributes, curveDampner: curveDampner)
        }
        return attributes
    }
    
    func convex(_ layoutAttributes: [UICollectionViewLayoutAttributes], curveDampner: Int) -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = self.collectionView else {
            return []
        }
        
        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        let collectionViewHeight = collectionView.bounds.height
        
        for item in layoutAttributes {
            // Range 1...0...1
            let offsetRatio = fabs((item.frame.minY - collectionView.bounds.midY)/collectionViewHeight)
            
            let n = CGFloat(curveDampner)
            let offsetRatioByN = 1 - offsetRatio/n
            
            item.transform = CGAffineTransform(scaleX: offsetRatioByN, y: 1)
            
            newLayoutAttributes.append(item)
        }
        
        return newLayoutAttributes
    }
    
    func concave(_ layoutAttributes: [UICollectionViewLayoutAttributes], curveDampner: Int) -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = self.collectionView else {
            return []
        }
        
        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        let collectionViewHeight = collectionView.bounds.height
        
        for item in layoutAttributes {
            // Range 1...0...1
            let offsetRatio = 1 - fabs((item.frame.minY - collectionView.bounds.midY)/collectionViewHeight)
            
            let n = CGFloat(curveDampner)
            let offsetRatioByN = 1 - offsetRatio/n
            
            item.transform = CGAffineTransform(scaleX: offsetRatioByN, y: 1)
            
            newLayoutAttributes.append(item)
        }
        
        return newLayoutAttributes
    }


    func isoscelesTrapezoid(_ layoutAttributes: [UICollectionViewLayoutAttributes], inverted: Bool = true, curveDampner: Int) -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = self.collectionView else {
            return []
        }
        
        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for item in layoutAttributes {
            // Range 0 - 1
            let offsetRatio = (item.frame.minY - collectionView.bounds.minY) / collectionView.bounds.height
            
            let n = CGFloat(curveDampner)
            let offsetRatioByN = 1 - offsetRatio/n
            
            item.transform = CGAffineTransform(scaleX: offsetRatioByN, y: 1)
            
            newLayoutAttributes.append(item)
        }
        
        return newLayoutAttributes
    }
}

