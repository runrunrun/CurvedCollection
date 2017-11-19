//
//  AnimatorFlowLayout.swift
//  CurvedCollection
//
//  Created by Hari Kunwar on 11/19/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit

class AnimatorFlowLayout: UICollectionViewFlowLayout {
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    private var visibleIndexPaths: Set<IndexPath> = []
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        // Get visible layout items
        let visibleRect = collectionView.bounds
        guard let currentlyVisibleLayoutItems: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: visibleRect) else {
            return
        }
        
        // Get visible indexPaths
        let currentlyVisibleIndexPaths = currentlyVisibleLayoutItems.map {
            return $0.indexPath
        }
        
        // Remove behaviors that are not visible.
        animator.removeHiddenBehaviors(for: currentlyVisibleIndexPaths)
        
        // Find newly visible items.
        let newVisibleItems = currentlyVisibleLayoutItems.filter {
            return !self.visibleIndexPaths.contains($0.indexPath)
        }
        
        // Add newly visible behaviors.
        for item in newVisibleItems {
            guard let _ = currentlyVisibleIndexPaths.index(of: item.indexPath) else {
                continue
            }
            
            let offsetYPercent = (item.frame.minY - collectionView.bounds.minY)/collectionView.bounds.height
            item.size.width = collectionView.bounds.width - collectionView.bounds.width*offsetYPercent/6
            
            let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
            
            animator.addBehavior(attachmentBehavior)
        }
        
        // Update visibleIndexPaths
        visibleIndexPaths = Set(currentlyVisibleIndexPaths)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        return animator.layoutAttributesForCell(at: indexPath) ?? attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        
        animator.behaviors.forEach {
            guard let behavior = $0 as? UIAttachmentBehavior else {
                return
            }
            
            guard let item = behavior.items.first as? UICollectionViewLayoutAttributes else {
                return
            }
            
            let offsetYPercent = (item.frame.minY - collectionView.bounds.minY)/collectionView.bounds.height
            item.size.width = collectionView.bounds.width - collectionView.bounds.width*offsetYPercent/6
            
            animator.updateItem(usingCurrentState: item)
        }
        
        return true
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
