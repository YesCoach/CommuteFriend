//
//  RealmStorage.swift
//  CommuteFriend
//
//  Created by 박태현 on 2023/10/15.
//

import Foundation
import RealmSwift

final class RealmStorage {

    enum RealmError: Error {
        case invalidInitialize
    }

    static let shared = RealmStorage()

    private let realm = {
        try? Realm()
    }()

    private init() { }
}

extension RealmStorage {

    func checkSchemaVersion() {
        guard let realm,
              let fileURL = realm.configuration.fileURL
        else { return }
        do {
            let version = try schemaVersionAtURL(fileURL)
            print("Schema Version: \(version)")
            print("Schema direction: \(fileURL)")
            print("realm \(realm.configuration.fileURL)")
        } catch {
            print(error)
        }
    }

    // MARK: - CRUD

    func createData<T: Object>(data: T) {
        guard let realm else { return }

        do {
            try realm.write {
                realm.add(data, update: .all)
                print("Realm create completed")
            }
        } catch {
            debugPrint(error)
        }
    }

    func readData<T: Object>(_ object: T.Type) throws -> Results<T> {
        guard let realm else { throw RealmError.invalidInitialize }
        return realm
            .objects(object)
    }

    func readData<T: Object>(_ object: T.Type, primaryKey: String) throws -> T? {
        guard let realm else { throw RealmError.invalidInitialize }
        return realm.object(ofType: object, forPrimaryKey: primaryKey)
    }

    func deleteData<T: Object>(data: T) {
        guard let realm else { return }
        do {
            try realm.write {
                realm.delete(data)
                print("Realm delete completed")
            }
        } catch {
            debugPrint(error)
        }
    }

    func deleteData<T: Object>(data: T, completion: (Realm, T) -> Void) {
        guard let realm else { return }
        do {
            try realm.write {
                completion(realm, data)
                realm.delete(data)
                print("Realm delete completed")
            }
        } catch {
            debugPrint(error)
        }
    }

    func updateData<T: Object>(data: T, completion: ((T) -> Void)) {
        guard let realm else { return }
        do {
            try realm.write {
                completion(data)
                print("Realm update completed")
            }
        } catch {
            debugPrint(error)
        }
    }

    func updateData<T: Object>(data: T, completion: ((Realm, T) -> Void)) {
        guard let realm else { return }
        do {
            try realm.write {
                completion(realm, data)
                print("Realm update completed")
            }
        } catch {
            debugPrint(error)
        }
    }

}
