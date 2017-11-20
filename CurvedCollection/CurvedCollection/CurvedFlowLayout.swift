//
//  CurvedFlowLayout.swift
//  CurvedFlowLayout
//
//  Created by Hari Kunwar on 11/10/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit

enum Shape {
    case rhombus
    case isoscelesTrapezoid
}

class CurvedFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let attributes = shapedAttributes(layoutAttributes, shape: .isoscelesTrapezoid)
        
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
    
    func shapedAttributes(_ layoutAttributes: [UICollectionViewLayoutAttributes], shape: Shape) -> [UICollectionViewLayoutAttributes] {
        let attributes: [UICollectionViewLayoutAttributes]
        switch shape {
        case .isoscelesTrapezoid:
            attributes = isoscelesTrapezoid(layoutAttributes)
        case .rhombus:
            attributes = []
            break
        }
        
        return attributes
    }
    
    func isoscelesTrapezoid(_ layoutAttributes: [UICollectionViewLayoutAttributes], inverted: Bool = true) -> [UICollectionViewLayoutAttributes] {
        
        guard let collectionView = self.collectionView else {
            return []
        }
        
        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for item in layoutAttributes {
            // Range 0 - 1
            let offsetRatio = (item.frame.minY - collectionView.bounds.minY)/collectionView.bounds.height
            
            // Range 0 - 1/n
            let n: CGFloat = 6
            let offsetRatioByN = 1 - offsetRatio/n
            
            // item.size.width = collectionView.bounds.width - collectionView.bounds.width*offsetRatioByN
            item.transform = CGAffineTransform(scaleX: offsetRatioByN, y: 1)
            
            newLayoutAttributes.append(item)
        }
        
        return newLayoutAttributes
    }
}


