import Foundation
import RealmSwift

struct DatabaseTestUtils {
    
    static func getRealm() -> Realm {
        return try! Realm(configuration: Realm.Configuration(fileURL: nil, inMemoryIdentifier: "service-dao-tests", syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 0, migrationBlock: nil, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil))
    }
    
}
