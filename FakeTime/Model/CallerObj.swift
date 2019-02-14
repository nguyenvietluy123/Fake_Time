//
//  CallObj.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/25/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import CoreData

class CallerObj: NSObject {
    var id: String = ""
    var name: String = ""
    var phoneNumber: String = ""
    var avatar: UIImage = #imageLiteral(resourceName: "Avatar_default")
    var pathVideo: String = ""
    var delayTime: Int = 0
    var typeCall: typeCall = .call
    
    override init() {
        super.init()
        id = UUID().uuidString
    }
    
    init(name: String, phoneNumber: String, avatar: UIImage, pathVideo: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.avatar = avatar
        self.pathVideo = pathVideo
    }
    
    init(_ obj: Caller) {
        self.id = obj.id ?? ""
        self.name = obj.name ?? ""
        self.phoneNumber = obj.phoneNumber ?? ""
        if let data = obj.avatar {
            if let img = UIImage(data: data) {
                self.avatar = img
            }
        }
        self.pathVideo = obj.videoUrl ?? ""
    }
}

extension CallerObj {
    func saveCallerList(_ isMerge: Bool = false) {
        print("save Caller list, \(self.name), \(isMerge)")
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = mainContextInstance
        
        let caller = NSEntityDescription.insertNewObject(forEntityName: "Caller",
                                                          into: minionManagedObjectContextWorker) as! Caller
        caller.id = self.id
        caller.name = self.name
        caller.phoneNumber = self.phoneNumber
        caller.videoUrl = self.pathVideo
        caller.avatar = self.avatar.pngData()
        
        persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        if isMerge {
            persistenceManager.mergeWithMainContext()
        }
    }
    
    func updateCaller() {
        if let caller = findCaller() {
            caller.avatar = self.avatar.pngData()
            caller.videoUrl = self.pathVideo
            caller.name = self.name
            caller.phoneNumber = self.phoneNumber
            persistenceManager.mergeWithMainContext()
        }
    }
    
    func deleteCaller() {
        if let caller = findCaller() {
            mainContextInstance.delete(caller)
            persistenceManager.mergeWithMainContext()
        }
    }
    
    func findCaller() -> Caller? {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Caller")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == %@", "id", self.id as CVarArg)
        
        var fetchedResults: Array<Caller> = Array<Caller>()
        
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Caller]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Caller>()
        }
        if fetchedResults.count == 1 {
            return fetchedResults[0]
        }
        return nil
    }
}

