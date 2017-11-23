//
//  ViewController.swift
//  CurvedCollection
//
//  Created by Hari Kunwar on 11/10/17.
//  Copyright © 2017 Learning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: CurvedFlowLayout!
    var scenicImages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add images
        for index in 1...15 {
            let imageName = "\(index)"
            scenicImages.append(imageName)
        }
        
        // Setup layout shape and curve
        flowLayout.curveDampner = 6
        flowLayout.shape = .concave
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scenicImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicCell", for: indexPath) as! BasicCell
        
        let cellIndex = indexPath.item
        if scenicImages.count > cellIndex {
            cell.imageView.image = UIImage(named: scenicImages[cellIndex])
        }
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 10
        return CGSize(width: width, height: 60)
    }
    
}
