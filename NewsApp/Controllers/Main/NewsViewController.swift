//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/4/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import UIKit
import Reachability

protocol NewsViewControllerDelegate: class {
    func didSelect(news: NewsItem, dateFormatter: DateFormatter, _ controller: NewsViewController)
}

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var news: [NewsItem] = []
    fileprivate var reachability = Reachability()
    var dateFormatter: DateFormatter!

    weak var delegate: NewsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "default")
        self.getNews()
        self.configNavigationBar()
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    fileprivate func getNews() {
        if reachability?.connection == .wifi || reachability?.connection == .cellular {
            self.view.showGrayActivityIndicator()
            APIService.shared.getNews { (news, error) in
                guard error == nil, let news = news else {
                    return
                }
                
                self.news = news
                NewsStorageService.shared.save(news: self.news)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.removeGrayActivityIndicator()
                }
            }
        } else {
            let toast = TEToastViewV2(image: UIImage(named: "noInternet"),
                                      title: "No internet connection",
                                      comment: "Loading from cache",
                                      position: .centered)
            toast.present(inSuperview: UIApplication.shared.keyWindow!.rootViewController!.view)
            
            self.news = NewsStorageService.shared.load()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func configNavigationBar() {
        self.title = "News"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func appDidBecomeActive() {
        self.tableView.backgroundColor = UIColor(netHex: 0xf2f2f2)
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default") as! NewsTableViewCell
        cell.config(news: news[indexPath.row], dateFormatter: dateFormatter)
        cell.isVisited = CoreDataService.shared.isNewsURLSaved(shareURL: news[indexPath.row].shareUrl!) ? true : false
        cell.type = .asShortDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        cell.isVisited = true
        cell.setSelected(false, animated: true)
        self.delegate?.didSelect(news: news[indexPath.row], dateFormatter: dateFormatter, self)
    }
}
