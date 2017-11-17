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
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    private var visibleIndexPaths: Set<IndexPath> = []
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        // Get visible layout items
        let visibleRect = collectionView.bounds
        guard let visibleLayoutItems: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: visibleRect) else {
            return
        }

        // Get visible indexPaths
        let visibleIndexPaths = visibleLayoutItems.map {
            return $0.indexPath
        }

        // Remove behaviors that are not visible.
        animator.removeHiddenBehaviors(for: visibleIndexPaths)

        // Find newly visible items.
        let newlyVisibleItems = visibleLayoutItems.filter {
            return !self.visibleIndexPaths.contains($0.indexPath)
        }

        // Add newly visible behaviors.
        for item in newlyVisibleItems {
            guard let index = visibleIndexPaths.index(of: item.indexPath) else {
                continue
            }
            
            // Update item width based on it's index.
//            item.size.width = item.size.width - CGFloat(index*5)
            
            let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)

            
            animator.addBehavior(attachmentBehavior)
            self.visibleIndexPaths.insert(item.indexPath)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let elementsAttributes = super.layoutAttributesForElements(in: rect) else {
//            return nil
//        }
//
//        guard let collectionView = collectionView else {
//            return nil
//        }
//
//        let contentOffset = collectionView.contentOffset
//        let minVisibleCellY = contentOffset.y + 20
//        let maxVisibleCellY = contentOffset.y + collectionView.bounds.height
//
//        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
//        // Modify attributes
//        var index = 0
//        for (_, itemAttributes) in elementsAttributes.enumerated() {
//            let attributes = itemAttributes
//
//            // Check if attribute is visible rect.
//            if attributes.frame.minY < minVisibleCellY || attributes.frame.minY > maxVisibleCellY {
//                // No modifications required.
//                newLayoutAttributes.append(attributes)
//                continue
//            }
//
//            var size = attributes.size
//            size.width = size.width - CGFloat(index*5)
//            attributes.size = size
//            newLayoutAttributes.append(attributes)
//            index += 1
//        }
        
        return animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return animator.layoutAttributesForCell(at: indexPath) ?? super.layoutAttributesForItem(at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        
        // Get visible layout items
        let visibleRect = collectionView.bounds
        
        // Assumption is we get items from top to bottom order.
        guard let visibleLayoutItems = super.layoutAttributesForElements(in: visibleRect) else {
            return false
        }
        
        // Get visible indexPaths
        let visibleIndexPaths = visibleLayoutItems.map {
            return $0.indexPath
        }
        
        animator.behaviors.forEach {
            guard let behavior = $0 as? UIAttachmentBehavior else {
                return
            }
            
            guard let item = behavior.items.first as? UICollectionViewLayoutAttributes else {
                return
            }
            
            guard let index = visibleIndexPaths.index(of: item.indexPath) else {
                return
            }
            
            // Update item width based on it's index.
            item.size.width = item.size.width - CGFloat(index*5)
            
            animator.updateItem(usingCurrentState: item)
        }
        
        return collectionView.bounds.width != newBounds.width
    }
    
}

private extension UIDynamicAnimator {
    func removeHiddenBehaviors(for visibleIndexPaths: [IndexPath]) {
        guard let attachmentBehavior = self.behaviors as? [UIAttachmentBehavior] else {
            return
        }
        
        for behavior in attachmentBehavior {
            guard let itemAttributes = behavior.items.first as? UICollectionViewLayoutAttributes else {
                continue
            }
            
            if !visibleIndexPaths.contains(itemAttributes.indexPath) {
                self.removeBehavior(behavior)
            }
        }
    }
}
