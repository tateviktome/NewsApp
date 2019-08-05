//
//  VideoViewController.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/5/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class VideoViewController: UIViewController {
    
    @IBOutlet weak var videoPlayerView: WKYTPlayerView!
    var id: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerVars = [
            "playsinline": "1",
            "controls": "0",
            "showinfo": "0",
            "origin": "https://www.youtube.com"
        ]
        
        videoPlayerView.load(withVideoId: id, playerVars: playerVars)
    }
}
