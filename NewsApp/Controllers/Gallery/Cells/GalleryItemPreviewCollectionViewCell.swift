//
//  GalleryItemPreviewCollectionViewCell.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/5/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import UIKit

class GalleryItemPreviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 4
        self.scrollView.alwaysBounceVertical = false
        self.scrollView.alwaysBounceHorizontal = false
        self.scrollView.showsVerticalScrollIndicator = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTap)
    }
    
    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if self.scrollView.zoomScale == 1 {
            self.scrollView.zoom(to: zoomRect(forScale: self.scrollView.maximumZoomScale,
                                                      center: recognizer.location(in: recognizer.view)),
                                 animated: true)
        } else {
            self.scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRect(forScale scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = self.imageView.frame.size.height/scale
        zoomRect.size.width  = self.imageView.frame.size.width/scale
        let newCenter = self.imageView.convert(center, from: self.scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width/2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height/2.0)
        return zoomRect
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.scrollView.setZoomScale(1, animated: true)
    }
}

extension GalleryItemPreviewCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
