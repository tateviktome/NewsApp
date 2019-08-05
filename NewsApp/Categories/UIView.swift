//
//  UIView.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/5/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func showGrayActivityIndicator(animated: Bool = false) {
        let overlay = OverlayView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .white
        overlay.alpha = 0
        self.addSubview(overlay)
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
                overlay.topAnchor.constraint(equalTo: self.topAnchor),
                overlay.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                overlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                overlay.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
            ])
        
        activityIndicator.startAnimating()
        if animated {
            UIView.animate(withDuration: 0.3) {
                overlay.alpha = 1
            }
        } else {
            overlay.alpha = 1
        }
    }
    
    func removeGrayActivityIndicator() {
        for subview in self.subviews where subview.isKind(of: OverlayView.self) {
            UIView.animate(withDuration: 0.3, animations: {
                subview.alpha = 0
            }) { (_) in
                subview.removeFromSuperview()
            }
        }
    }
}

private class OverlayView: UIView {}
