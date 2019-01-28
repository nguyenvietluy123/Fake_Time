//
//  CallerManager.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/25/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//


import Foundation
import UIKit
import CoreData
import UserNotifications

class CallerManager {
    static let sharedInstance = CallerManager()
    var arrSearch: [CallerObj] = []
    
    init() {
    }
    
    func getAllCaller() -> [CallerObj] {
        var fetchedResults: Array<Caller> = Array<Caller>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Caller")
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Caller]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Caller>()
        }
        var result: [CallerObj] = []
        for fetch in fetchedResults {
            let obj: CallerObj = CallerObj(fetch)
            result.append(obj)
        }
        return result.sorted(by: { (obj1, obj2) -> Bool in
            obj1.name.localizedCaseInsensitiveCompare(obj2.name) == .orderedAscending
        })
    }
    
    func loadLocalData() {
        arrSearch = self.getAllCaller()
    }
}

let callerManager = CallerManager.sharedInstance

