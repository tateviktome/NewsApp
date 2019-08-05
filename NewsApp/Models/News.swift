//
//  News.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/4/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import Foundation

class BaseItem: Codable {
    var metadata: [NewsItem]?
}

class NewsItem: Codable {
    var category: String?
    var title: String?
    var body: String?
    var shareUrl: String?
    var coverPhotoUrl: String?
    var date: Int?
    var gallery: [GalleryItem]?
    var video: [Video]?
}

class GalleryItem: Codable {
    var title: String?
    var thumbnailUrl: String?
    var contentUrl: String?
}

class Video: Codable {
    var title: String?
    var thumbnailUrl: String?
    var youtubeId: String?
}
