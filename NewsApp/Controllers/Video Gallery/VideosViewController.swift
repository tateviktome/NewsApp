//
//  VideosViewController.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/5/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import UIKit
import Imaginary
import Reachability

class VideosViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var reachability = Reachability()
    var items: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Videos"
        
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView.separatorStyle = .none
        self.view.addSubview(tableView)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(closeButtonPressed))
    }
    
    @objc func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = items[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard reachability?.connection == .wifi || reachability?.connection == .cellular else {
            let toast = TEToastViewV2(image: UIImage(named: "noInternet"),
                                      title: "No internet connection",
                                      comment: "Can't play youtube video",
                                      position: .boundary(position: .bottom, inset: 20.0))
            toast.present(inSuperview: self.view)
            return
        }
        let contr = VideoViewController(nibName: "VideoViewController", bundle: nil)
        contr.id = items[indexPath.row].youtubeId!
        self.navigationController?.pushViewController(contr, animated: true)
    }
}
