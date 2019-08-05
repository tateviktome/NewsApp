//
//  CustomSplitViewController.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/4/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import Foundation
import DeviceKit
import UIKit

class CustomSplitViewController: UISplitViewController {
    fileprivate let device = Device.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = NewsViewController(nibName: "NewsViewController", bundle: nil)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        self.viewControllers = [nav]
    }
    
    override var traitCollection: UITraitCollection {
        if device.isPad {
            return super.traitCollection
        } else {
            return UITraitCollection(traitsFrom: [super.traitCollection,
                                     UITraitCollection(horizontalSizeClass: .compact)])
        }
    }
}

extension CustomSplitViewController: NewsViewControllerDelegate {
    func didSelect(news: NewsItem, dateFormatter: DateFormatter, _ controller: NewsViewController) {
        CoreDataService.shared.save(url: news.shareUrl!)
        let contr = NewsDetailViewController(nibName: "NewsDetailViewController", bundle: nil)
        contr.dateFormatter = dateFormatter
        contr.config(withNews: news)
        
        if device.isPad {
            self.showDetailViewController(contr, sender: nil)
        } else {
            controller.navigationController?.pushViewController(contr, animated: true)
        }
    }
}
