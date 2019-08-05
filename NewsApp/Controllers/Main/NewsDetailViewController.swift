//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/4/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    fileprivate enum Sections {
        enum MediaItem {
            case gallery(items: [GalleryItem])
            case videos(items: [Video])
            
            var title: String {
                switch self {
                case .gallery:
                    return "Gallery"
                case .videos:
                    return "Videos"
                }
            }
        }
        
        case news(news: NewsItem)
        case media(mediaItems: [MediaItem])
        
        var title: String {
            switch self {
            case .media:
                return "Media"
            case .news:
                return ""
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var sections: [Sections] = []
    var dateFormatter: DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "news")
    }
    
    func config(withNews news: NewsItem) {
        sections = []
        
        sections.append(.news(news: news))
        
        var mediaItems: [Sections.MediaItem] = []
        if let gallery = news.gallery, !gallery.isEmpty {
            mediaItems.append(.gallery(items: gallery))
        }
        
        if let videos = news.video, !videos.isEmpty {
            mediaItems.append(.videos(items: videos))
        }
        
        if !mediaItems.isEmpty {
            sections.append(.media(mediaItems: mediaItems))
        }
    }
}

extension NewsDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .media(let mediaItems):
            return mediaItems.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .news(let news):
            let cell = tableView.dequeueReusableCell(withIdentifier: "news") as! NewsTableViewCell
            cell.config(news: news, dateFormatter: dateFormatter)
            cell.type = .asDetail
            return cell
        case .media(let mediaItems):
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = mediaItems[indexPath.row].title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch sections[indexPath.section] {
        case .news:
            break
        case .media(let mediaItems):
            switch mediaItems[indexPath.row] {
            case .gallery(let items):
                let controller = GalleryViewController()
                controller.items = items
                let navController = UINavigationController(rootViewController: controller)
                self.present(navController, animated: true, completion: nil)
            case .videos(let items):
                let contr = VideosViewController()
                contr.items = items
                self.present(UINavigationController(rootViewController: contr), animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
