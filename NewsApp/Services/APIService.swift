//
//  APIService.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/4/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    func getNews(callback: @escaping (([NewsItem]?, Error?) -> ())) {
        guard let url = URL(string: APIEndpoints.data) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                callback(nil, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(BaseItem.self, from: data)
                callback(value.metadata!, nil)
            } catch let error {
                callback(nil, error)
            }
        }.resume()
    }
}
