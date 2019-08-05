//
//  GalleryItemViewController.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/5/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import Foundation
import UIKit

//Also implemented zooming of images and from one preview swiping to next and to previous images

class GalleryItemViewController: UIViewController  {
    
    fileprivate var collectionView: UICollectionView!
    var selectedIndexPath = IndexPath()
    var items: [GalleryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.register(UINib(nibName: "GalleryItemPreviewCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "default")
        collectionView.isPagingEnabled = true
        
        self.view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.scrollToItem(at: selectedIndexPath, at: .left, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = collectionView.frame.size
        flowLayout.invalidateLayout()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = collectionView.contentOffset
        let width  = collectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        collectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.reloadData()
            
            self.collectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
}

extension GalleryItemViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! GalleryItemPreviewCollectionViewCell
        cell.imageView.setImage(url: URL(string: items[indexPath.row].thumbnailUrl!)!)
        return cell
    }
}
