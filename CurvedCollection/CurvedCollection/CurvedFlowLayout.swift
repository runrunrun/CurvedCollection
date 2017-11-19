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
    
        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for item in elementsAttributes {
            let offsetYPercent = (item.frame.minY - collectionView.bounds.minY)/collectionView.bounds.height
            item.size.width = collectionView.bounds.width - collectionView.bounds.width*offsetYPercent/6
            
            newLayoutAttributes.append(item)
        }
        
        return newLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.layoutAttributesForItem(at: indexPath)
        return attribute
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

