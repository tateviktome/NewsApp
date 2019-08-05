//
//  NewsTableViewCell.swift
//  Dasa
//
//  Created by Tatevik Tovmasyan on 7/18/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    enum CellType {
        case asShortDescription
        case asDetail
    }
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var seenImageView: UIImageView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var mainViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewTrailingConstraint: NSLayoutConstraint!
    
    var type: CellType = .asShortDescription {
        didSet {
            self.configType()
        }
    }
    
    var isVisited: Bool = false {
        didSet {
            if isVisited {
                self.seenImageView.image = UIImage(named: "seen")
            } else {
                self.seenImageView.image = nil
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.mainView.backgroundColor = .gray
        } else {
            self.mainView.backgroundColor = .white
        }
    }
    
    func config(news: NewsItem, dateFormatter: DateFormatter) {
        self.newsImageView.image = UIImage(named: "blank")
        
        self.titleLabel.text = news.title
        self.descriptionLabel.text = news.category
        self.newsImageView.setImage(url: URL(string: news.coverPhotoUrl!)!)
        
        let date = Date(timeIntervalSince1970: TimeInterval(news.date!))
        self.dateLabel.attributedText = self.getAttrDate(fromDateString: dateFormatter.string(from: date))
        
    }
    
    fileprivate func configType() {
        switch self.type {
        case .asDetail:
            self.seenImageView.image = nil
            
            self.mainViewTopConstraint.constant = 0
            self.mainViewBottomConstraint.constant = 0
            self.mainViewLeadingConstraint.constant = 0
            self.mainViewTrailingConstraint.constant = 0
            
            self.layoutIfNeeded()
            self.selectionStyle = .none
        case .asShortDescription:
            self.mainViewTopConstraint.constant = 16
            self.mainViewBottomConstraint.constant = 16
            self.mainViewLeadingConstraint.constant = 16
            self.mainViewTrailingConstraint.constant = 16
            
            self.mainView.layer.shadowColor = UIColor.gray.cgColor
            self.mainView.layer.shadowRadius = 4
            self.mainView.layer.shadowOpacity = 0.5
            
            self.layoutIfNeeded()
        }
    }
}

extension NewsTableViewCell {
    fileprivate func getAttrDate(fromDateString string: String) -> NSMutableAttributedString {
        var attrText: NSMutableAttributedString!
        var boldAttributes: [NSAttributedString.Key : NSObject]!
        let year = string.suffix(4)
        
        let defaultAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
        attrText = NSMutableAttributedString(string: string,
                                             attributes: defaultAttributes)
        boldAttributes = defaultAttributes
        boldAttributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.bold)
        
        attrText.addAttributes(boldAttributes, range: (string as NSString).range(of: String(year)))
        return attrText
    }
}
