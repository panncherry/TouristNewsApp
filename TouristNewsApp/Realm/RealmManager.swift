//
//  RealmManager.swift
//  TouristNewsApp
//
//  Created by Pann Cherry on 1/20/23.
//

import Foundation
import RealmSwift

/// Manage everything related to Realm
final class RealmManager {
    
    static let shared = RealmManager()
    
    /*
     Note that we are currently returning a new realm here every time to try to make sure that
     we don't have any threading issues with realm access.  If we do, we can switch this out in this
     one location to return a more global realm instance without having to do it in every class that uses realm.
     */
    private var localRealm: Realm {
        return getNewRealm()
    }
    
    var isPerformingWriteOperation: Bool = false
    
    private var currentRealmSchemaVersion: UInt64 = 1
    
    init() {
        prepareRealm()
    }
    
    /*
     This will only run on init (the first time the singleton is accessed).
     This prevents a bunch of file system access from happening every time a class asks for a Realm.
     */
    private func prepareRealm() {
        self.deleteOldRealmFilesIfNeeded()
        self.createRealmDirectoryIfNeeded()
        
        let config = localRealmConfig()
        
        do {
            let _ = try Realm(configuration: config)
        } catch let error as NSError {
            // If the encryption key is wrong, `error` will say that it's an invalid database
            fatalError("Error opening realm: \(error)")
        }
    }
    
    /// Local realm configuration
    private func localRealmConfig() ->  Realm.Configuration {
        let config: Realm.Configuration = Realm.Configuration(schemaVersion: currentRealmSchemaVersion,
                                                              migrationBlock: {migration, oldSchemaVersion in
            if oldSchemaVersion > self.currentRealmSchemaVersion {
                // Do something, usually updating the schema's variables here
            }
        })
        return config
    }
    
    /// Realm does not automatically create directories when trying to create a Realm in a subdirectory. So we have to do it ourselves.
    private func createRealmDirectoryIfNeeded() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let realmDirectory = "\(documentDirectory)/realm/"
        
        if (!FileManager.default.fileExists(atPath: realmDirectory)) {
            do {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: realmDirectory), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
    }
    
    /// Deletes the legacy Realm files created if needed
    private func deleteOldRealmFilesIfNeeded() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let realmPath = "\(documentDirectory)/default_new.realm"
        
        if (FileManager.default.fileExists(atPath: realmPath)) {
            do {
                try FileManager.default.removeItem(atPath: realmPath)
                try FileManager.default.removeItem(atPath: "\(realmPath).lock")
                try FileManager.default.removeItem(atPath: "\(realmPath).management")
            } catch {
                print(error)
            }
        }
    }
    
}

// This is the only public interface aside from the singleton access.
extension RealmManager {
    public func getNewRealm() -> Realm {
        let config = self.localRealmConfig()
        let realm = try! Realm(configuration: config)
        return realm
    }
}
