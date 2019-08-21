import Foundation

protocol UserProfileLocalStorageGateway: UserProfileGateway {
  func deleteAll(completionHandler: @escaping (Result<Void, Error>) -> Void)
}

// sourcery:begin: AutoMockable
extension UserProfileLocalStorageGateway {}
// sourcery:end

class UserProfileLocalStorageGatewayImpl: UserProfileLocalStorageGateway {
  
  fileprivate let storage: RealmManagerProtocol
  
  init(storage: RealmManagerProtocol = RealmManager()) {
    self.storage = storage
  }
  
  
  func load(completionHandler: @escaping (Result<UserProfile, Error>) -> Void) {
    if let object = storage.allEntities(withType: RealmUserProfile.self).first {
      completionHandler(.success(object.userProfileModel))
    } else {
      completionHandler(.failure(URError.userNotCreated))
    }
  }
  
  func save(parameters: UserProfile, completionHandler: @escaping (Result<UserProfile, Error>) -> Void) {
    do {
      let object = RealmUserProfile(profile: parameters)
      try storage.save(object, update: true) {
        completionHandler(.success(object.userProfileModel))
      }
    } catch {
      completionHandler(.failure(error))
    }
  }
  
  func delete(entity: UserProfile, completionHandler: @escaping (Result<Void, Error>) -> Void) {
    if let object = storage.getEntity(withType: RealmUserProfile.self, for: entity.identifier) {
      do {
        try storage.remove(object, cascading: true)
        completionHandler(.success(()))
      } catch {
        completionHandler(.failure(error))
      }
    } else {
      completionHandler(.success(()))
    }
  }
  
  func deleteAll(completionHandler: @escaping (Result<Void, Error>) -> Void) {
    let objects = storage.allEntities(withType: RealmUserProfile.self)
    do {
      try storage.remove(objects, cascading: true)
      completionHandler(.success(()))
    } catch {
      completionHandler(.failure(error))
    }
  }
}
