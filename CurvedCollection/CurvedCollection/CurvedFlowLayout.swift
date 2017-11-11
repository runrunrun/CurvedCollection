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
        
        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        // Modify attributes
        for (index, itemAttributes) in elementsAttributes.enumerated() {
            let attributes = itemAttributes
            var size = attributes.size
            size.width = size.width - CGFloat(index*10)
            attributes.size = size
            newLayoutAttributes.append(attributes)
        }
        
        return newLayoutAttributes
    }
    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        var attribute = super.layoutAttributesForItem(at: indexPath)
//
//        // Modify attribute
//
//        return attribute
//    }
}
