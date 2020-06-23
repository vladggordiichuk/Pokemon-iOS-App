//
//  RealmManager.swift
//  Pokemon App
//
//  Created by Vlad Gordiichuk on 23.06.2020.
//  Copyright © 2020 Vlad Gordiichuk. All rights reserved.
//

import RealmSwift

final class RealmManager {
    
    private static let defaultRealm = try! Realm(configuration: Realm.Configuration(schemaVersion: 0, deleteRealmIfMigrationNeeded: true))
    
    static func update(_ block: @escaping () -> ()) {
        DispatchQueue.main.async {
            defaultRealm.beginWrite()
            block()
            try! defaultRealm.commitWrite()
        }
    }
        
    static func get<Element: Object>(_ type: Element.Type, completion: @escaping (Results<Element>) -> Void) {
        return DispatchQueue.main.async {
             completion(defaultRealm.objects(type))
        }
    }
    
    static func add<T: Object>(objects: [T], update: Bool = true) {
        DispatchQueue.main.async {
            do {
                try defaultRealm.safeWrite {
                    defaultRealm.add(objects, update: update ? .modified : .all)
                }
            } catch { print(error) }
        }
    }
    
    static func replace<T: Object>(_ type: T.Type, with objects: [T]) {
        DispatchQueue.main.async {
            RealmManager.get(type) { results in
                results.forEach { RealmManager.delete(object: $0) }
                RealmManager.add(objects: objects)
            }
        }
    }
    
    static func delete<T: Object>(_ type: T.Type) {
        DispatchQueue.main.async {
            get(type) { results in
                results.forEach { delete(object: $0) }
            }
        }
    }
    
    static func delete<T: Object>(object: T) {
        DispatchQueue.main.async {
            do {
                try defaultRealm.safeWrite {
                    defaultRealm.delete(object)
                }
            } catch { print(error) }
        }
    }
    
    static func deleteAll() {
        DispatchQueue.main.async {
            do {
                try defaultRealm.safeWrite {
                    defaultRealm.deleteAll()
                }
            } catch { print(error) }
        }
    }
}

extension Realm {
    func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
