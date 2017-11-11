//
//  CurvedFlowLayout.swift
//  CurvedFlowLayout
//
//  Created by Hari Kunwar on 11/10/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit

enum Curve {
    case ellipse
    case hyperbola
}

class CurvedFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let elementsAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        guard let collectionView = collectionView else {
            return nil
        }
    
        let contentOffset = collectionView.contentOffset
        let minVisibleCellY = contentOffset.y + 20
        let maxVisibleCellY = contentOffset.y + collectionView.bounds.height
        
        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        // Modify attributes
        var index = 0
        for (_, itemAttributes) in elementsAttributes.enumerated() {
            let attributes = itemAttributes
            
            // Check if attribute is visible rect.
            if attributes.frame.minY < minVisibleCellY || attributes.frame.minY > maxVisibleCellY {
                // No modifications required.
                newLayoutAttributes.append(attributes)
                continue
            }
            
            var size = attributes.size
            size.width = size.width - CGFloat(index*5)
            attributes.size = size
            newLayoutAttributes.append(attributes)
            index += 1
        }
        
        return newLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attribute = super.layoutAttributesForItem(at: indexPath)

//        collectionView?.indexPathsForVisibleItems
        
        // Modify attribute

        return attribute
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
