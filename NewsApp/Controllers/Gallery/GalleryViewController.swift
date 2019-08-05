//
//  GalleryViewController.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/5/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import Foundation
import UIKit
import DeviceKit
import Imaginary

class GalleryViewController: UIViewController {
    
    fileprivate var collectionView: UICollectionView!
    fileprivate let device = Device.current
    var items: [GalleryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Photos"
        self.view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.register(UINib(nibName: "GalleryItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "default")
        self.view.addSubview(collectionView)
        
        self.configItems()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                                       style: .plain,
                                                                                       target: self,
                                                                                       action: #selector(closeButtonPressed))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func configItems() {
        self.collectionView.reloadData()
    }
    
    @objc func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath) as! GalleryItemCollectionViewCell
        cell.imageView.setImage(url: URL(string: items[indexPath.row].thumbnailUrl!)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let vc = GalleryItemViewController()
        vc.items = self.items
        vc.selectedIndexPath = indexPath
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if device.orientation == .portrait {
            return CGSize(width: width/4 - 1, height: width/4 - 1)
        } else {
            return CGSize(width: width/6 - 1, height: width/6 - 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
