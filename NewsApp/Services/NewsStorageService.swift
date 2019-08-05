//
//  NewsStorageService.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/5/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import Foundation
import Cache

class NewsStorageService {
    static let shared = NewsStorageService()
    
    fileprivate var storage: Storage<[NewsItem]>!
    
    func setup() {
        let diskConfig = DiskConfig(name: "Floppy")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
        
        storage = try? Storage(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: [NewsItem].self)
        )
    }
    
    func save(news: [NewsItem], removingPrevious: Bool = true) {
        if removingPrevious {
            try? storage.removeAll()
        }
        
        try? storage.setObject(news, forKey: "news")
    }
    
    func load() -> [NewsItem] {
        return (try! storage.object(forKey: "news"))
    }
}
