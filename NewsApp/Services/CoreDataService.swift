//
//  CoreDataService.swift
//  NewsApp
//
//  Created by Tatevik Tovmasyan on 8/5/19.
//  Copyright © 2019 Tatevik Tovmasyan. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    
    fileprivate var savedManagedObjects: [NSManagedObject] = []
    
    func loadSavedData() {
        let context = getContext()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VisitedNews")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if let result = result as? [NSManagedObject] {
                self.savedManagedObjects = result
            }
        } catch {
            print("Failed")
        }
    }
    
    func isNewsURLSaved(shareURL: String) -> Bool {
        return savedManagedObjects.contains(where: { $0.value(forKey: "shareURL") as! String == shareURL })
    }
    
    func save(url: String) {
        guard !isNewsURLSaved(shareURL: url) else {
            return
        }
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "VisitedNews", in: context)
        let newURL = NSManagedObject(entity: entity!, insertInto: context)
        newURL.setValue(url, forKey: "shareURL")
        
        do {
            //even though AppDelegate saves on Terminating app, still saving
            try context.save()
            self.savedManagedObjects.append(newURL)
        } catch {
            print("Failed saving")
        }
    }
}

extension CoreDataService {
    fileprivate func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
