//
//  FlowLayout.swift
//  CurvedCollection
//
//  Created by Hari Kunwar on 11/15/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit

class FlowLayout: UICollectionViewFlowLayout {
    
    public enum BounceStyle {
        case subtle
        case regular
        case prominent
        
        var damping: CGFloat {
            switch self {
            case .subtle: return 1
            case .regular: return 0.75
            case .prominent: return 0.5
            }
        }
        
        var frequency: CGFloat {
            switch self {
            case .subtle: return 2
            case .regular: return 1.5
            case .prominent: return 1
            }
        }
    }
    
    private var damping: CGFloat = BounceStyle.regular.damping
    private var frequency: CGFloat = BounceStyle.regular.frequency
    
    public convenience init(style: BounceStyle) {
        self.init()
        
        damping = style.damping
        frequency = style.frequency
    }
    
    public convenience init(damping: CGFloat, frequency: CGFloat) {
        self.init()
        
        self.damping = damping
        self.frequency = frequency
    }
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    
    public override func prepare() {
        super.prepare()
        guard let view = collectionView, let attributes = super.layoutAttributesForElements(in: view.bounds)?.flatMap({ $0.copy() as? UICollectionViewLayoutAttributes }) else { return }
        
        oldBehaviors(for: attributes).forEach { animator.removeBehavior($0) }
        newBehaviors(for: attributes).forEach { animator.addBehavior($0, damping, frequency) }
    }
    
    private func oldBehaviors(for attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let indexPaths = attributes.map { $0.indexPath }
        return animator.behaviors.flatMap {
            guard let behavior = $0 as? UIAttachmentBehavior, let itemAttributes = behavior.items.first as? UICollectionViewLayoutAttributes else { return nil }
            return indexPaths.contains(itemAttributes.indexPath) ? nil : behavior
        }
    }
    
    private func newBehaviors(for attributes: [UICollectionViewLayoutAttributes]) -> [UIAttachmentBehavior] {
        let indexPaths = animator.behaviors.flatMap { (($0 as? UIAttachmentBehavior)?.items.first as? UICollectionViewLayoutAttributes)?.indexPath }
        return attributes.flatMap { return indexPaths.contains($0.indexPath) ? nil : UIAttachmentBehavior(item: $0, attachedToAnchor: $0.center) }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return animator.items(in: rect) as? [UICollectionViewLayoutAttributes]
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return animator.layoutAttributesForCell(at: indexPath) ?? super.layoutAttributesForItem(at: indexPath)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let view = collectionView else { return false }
        
        animator.behaviors.forEach {
            guard let behavior = $0 as? UIAttachmentBehavior else {
                return
            }
            
            guard let attributes = behavior.items.first as? UICollectionViewLayoutAttributes else {
                return
            }
            
            guard let collectionView = self.collectionView else {
                return
            }
            
            let contentOffset = collectionView.contentOffset
            let minVisibleRectY = contentOffset.y + 20
            let maxVisibleRectY = contentOffset.y + collectionView.bounds.height
            let visibleRectCenterY = contentOffset.y + collectionView.bounds.height/2
            
            // Check if attribute is in visible rect.
            if attributes.frame.minY < minVisibleRectY || attributes.frame.minY > maxVisibleRectY {
                // No modifications required.
                return
            }
            
            var offsetY = visibleRectCenterY - attributes.center.y
            offsetY = offsetY > 0 ? offsetY : -offsetY
            let maxOffsetY = collectionView.bounds.height/2
            
            let offsetYPercent = (offsetY/maxOffsetY)/2
            
            
            // Updated size
            var size = attributes.size
            size.width = size.width - size.width*offsetYPercent
            attributes.size = size
            
            
            //            update(behavior: behavior, and: item, in: view, for: newBounds)
            animator.updateItem(usingCurrentState: attributes)
        }
        return view.bounds.width != newBounds.width
    }
    
    private func update(behavior: UIAttachmentBehavior, and item: UIDynamicItem, in view: UICollectionView, for bounds: CGRect) {
        let delta = CGVector(dx: bounds.origin.x - view.bounds.origin.x, dy: bounds.origin.y - view.bounds.origin.y)
        let resistance = CGVector(dx: fabs(view.panGestureRecognizer.location(in: view).x - behavior.anchorPoint.x) / 1000, dy: fabs(view.panGestureRecognizer.location(in: view).y - behavior.anchorPoint.y) / 1000)
        
        item.center.y += delta.dy < 0 ? max(delta.dy, delta.dy * resistance.dy) : min(delta.dy, delta.dy * resistance.dy)
    }
}

extension UIDynamicAnimator {
    
    open func addBehavior(_ behavior: UIAttachmentBehavior, _ damping: CGFloat, _ frequency: CGFloat) {
        behavior.damping = damping
        behavior.frequency = frequency
        addBehavior(behavior)
    }
}
