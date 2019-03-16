import Foundation
import RealmSwift

protocol RealmManagerProtocol {
    func remove(_ object: Object, cascading: Bool) throws
    func remove<S: Sequence>(_ objects: S, cascading: Bool) throws where S.Element: Object
    func remove<S: Object>(_ objects: Results<S>, cascading: Bool) throws
    func allEntities<T: Object>(withType type: T.Type) -> Results<T>
    func allEntities<T>(withType type: T.Type, predicate: NSPredicate) -> Results<T> where T: Object
    func getEntity<T: Object, KeyType>(withType type: T.Type, for primaryKey: KeyType) -> T?
    func save<T: Object>(_ object: T, update: Bool, completion: (() -> Void)?) throws
    func save<S: Sequence>(_ objects: S, update: Bool, completion: (() -> Void)?) throws where S.Element: Object
}

// swiftlint:disable force_try
class RealmManager: RealmManagerProtocol {

    // MARK: property
    static var nameDataBase: String = "UtilitiReport"
    private static var defaultConfiguration: Realm.Configuration {
        var config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { (_, _) in
                
            }
        )
        
        let url = config.fileURL!.deletingLastPathComponent()
        config.fileURL = url.appendingPathComponent("\(nameDataBase).realm")
        return config
    }
    
    var realm: Realm {
        return try! Realm()
    }
    
    // MARK: - set configuration
    static func setConfiguration(_ config: Realm.Configuration = defaultConfiguration) {
        #if DEBUG
            print("Realm DataBase config fileURL", config.fileURL ?? "")
        #endif
        Realm.Configuration.defaultConfiguration = config
    }

    // MARK: - remove
    func remove(_ object: Object, cascading: Bool = false) throws {
        try realm.write {
            self.realm.delete(object, cascading: cascading)
        }
    }
    
    func remove<S: Sequence>(_ objects: S, cascading: Bool = false) throws where S.Element: Object {
        try realm.write {
            if cascading {
                self.realm.delete(objects, cascading: cascading)
            } else {
                self.realm.delete(objects)
            }
        }
    }
    
    func remove<S: Object>(_ objects: Results<S>, cascading: Bool = false) throws {
        try realm.write {
            if cascading {
                self.realm.delete(objects, cascading: cascading)
            } else {
                self.realm.delete(objects)
            }
        }
    }
    
    // MARK: get
    func allEntities<T: Object>(withType type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func allEntities<T>(withType type: T.Type, predicate: NSPredicate) -> Results<T> where T: Object {
        return realm.objects(type).filter(predicate)
    }
    
    func getEntity<T: Object, KeyType>(withType type: T.Type, for primaryKey: KeyType) -> T? {
        return realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    // MARK: save
    func save<T: Object>(_ object: T, update: Bool = true, completion: (() -> Void)? = nil) throws {
        try realm.write {
            self.realm.add(object, update: update)
            completion?()
        }
    }
    
    func save<S: Sequence>(_ objects: S, update: Bool = true,
                           completion: (() -> Void)? = nil) throws where S.Element: Object {
        try realm.write {
            self.realm.add(objects, update: update)
        }
    }
}
