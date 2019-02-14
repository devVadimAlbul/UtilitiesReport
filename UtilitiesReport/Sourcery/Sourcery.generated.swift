// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT




// MARK: - AutoEquatable for classes, protocols, structs

// MARK: - AutoEquatable for Enums

// swiftlint:disable all


// MARK: - AutoHashable for classes, protocols, structs

// MARK: - AutoHashable for Enums

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif













class DefaultsStorageMock: DefaultsStorage {

    //MARK: - saveValue

    var saveValueForKeyThrowableError: Error?
    var saveValueForKeyCallsCount = 0
    var saveValueForKeyCalled: Bool {
        return saveValueForKeyCallsCount > 0
    }
    var saveValueForKeyReceivedArguments: (value: String?, key: String)?
    var saveValueForKeyClosure: ((String?, String) throws -> Void)?

    func saveValue(_ value: String?, forKey key: String) throws {
        if let error = saveValueForKeyThrowableError {
            throw error
        }
        saveValueForKeyCallsCount += 1
        saveValueForKeyReceivedArguments = (value: value, key: key)
        try saveValueForKeyClosure?(value, key)
    }

    //MARK: - saveData

    var saveDataForKeyThrowableError: Error?
    var saveDataForKeyCallsCount = 0
    var saveDataForKeyCalled: Bool {
        return saveDataForKeyCallsCount > 0
    }
    var saveDataForKeyReceivedArguments: (data: Data?, key: String)?
    var saveDataForKeyClosure: ((Data?, String) throws -> Void)?

    func saveData(_ data: Data?, forKey key: String) throws {
        if let error = saveDataForKeyThrowableError {
            throw error
        }
        saveDataForKeyCallsCount += 1
        saveDataForKeyReceivedArguments = (data: data, key: key)
        try saveDataForKeyClosure?(data, key)
    }

    //MARK: - getValue

    var getValueForKeyThrowableError: Error?
    var getValueForKeyCallsCount = 0
    var getValueForKeyCalled: Bool {
        return getValueForKeyCallsCount > 0
    }
    var getValueForKeyReceivedKey: String?
    var getValueForKeyReturnValue: String?
    var getValueForKeyClosure: ((String) throws -> String?)?

    func getValue(forKey key: String) throws -> String? {
        if let error = getValueForKeyThrowableError {
            throw error
        }
        getValueForKeyCallsCount += 1
        getValueForKeyReceivedKey = key
        return try getValueForKeyClosure.map({ try $0(key) }) ?? getValueForKeyReturnValue
    }

    //MARK: - getData

    var getDataForKeyThrowableError: Error?
    var getDataForKeyCallsCount = 0
    var getDataForKeyCalled: Bool {
        return getDataForKeyCallsCount > 0
    }
    var getDataForKeyReceivedKey: String?
    var getDataForKeyReturnValue: Data?
    var getDataForKeyClosure: ((String) throws -> Data?)?

    func getData(forKey key: String) throws -> Data? {
        if let error = getDataForKeyThrowableError {
            throw error
        }
        getDataForKeyCallsCount += 1
        getDataForKeyReceivedKey = key
        return try getDataForKeyClosure.map({ try $0(key) }) ?? getDataForKeyReturnValue
    }

    //MARK: - removeObject

    var removeObjectForKeyCallsCount = 0
    var removeObjectForKeyCalled: Bool {
        return removeObjectForKeyCallsCount > 0
    }
    var removeObjectForKeyReceivedKey: String?
    var removeObjectForKeyClosure: ((String) -> Void)?

    func removeObject(forKey key: String) {
        removeObjectForKeyCallsCount += 1
        removeObjectForKeyReceivedKey = key
        removeObjectForKeyClosure?(key)
    }

}
class UserDefaultsDescribingMock: UserDefaultsDescribing {

    //MARK: - set

    var setForKeyCallsCount = 0
    var setForKeyCalled: Bool {
        return setForKeyCallsCount > 0
    }
    var setForKeyReceivedArguments: (value: Any?, defaultName: String)?
    var setForKeyClosure: ((Any?, String) -> Void)?

    func set(_ value: Any?, forKey defaultName: String) {
        setForKeyCallsCount += 1
        setForKeyReceivedArguments = (value: value, defaultName: defaultName)
        setForKeyClosure?(value, defaultName)
    }

    //MARK: - value

    var valueForKeyCallsCount = 0
    var valueForKeyCalled: Bool {
        return valueForKeyCallsCount > 0
    }
    var valueForKeyReceivedKey: String?
    var valueForKeyReturnValue: Any?
    var valueForKeyClosure: ((String) -> Any?)?

    func value(forKey key: String) -> Any? {
        valueForKeyCallsCount += 1
        valueForKeyReceivedKey = key
        return valueForKeyClosure.map({ $0(key) }) ?? valueForKeyReturnValue
    }

    //MARK: - synchronize

    var synchronizeCallsCount = 0
    var synchronizeCalled: Bool {
        return synchronizeCallsCount > 0
    }
    var synchronizeReturnValue: Bool!
    var synchronizeClosure: (() -> Bool)?

    func synchronize() -> Bool {
        synchronizeCallsCount += 1
        return synchronizeClosure.map({ $0() }) ?? synchronizeReturnValue
    }

    //MARK: - removeObject

    var removeObjectForKeyCallsCount = 0
    var removeObjectForKeyCalled: Bool {
        return removeObjectForKeyCallsCount > 0
    }
    var removeObjectForKeyReceivedDefaultName: String?
    var removeObjectForKeyClosure: ((String) -> Void)?

    func removeObject(forKey defaultName: String) {
        removeObjectForKeyCallsCount += 1
        removeObjectForKeyReceivedDefaultName = defaultName
        removeObjectForKeyClosure?(defaultName)
    }

}
class UserProfileLocalStorageGatewayMock: UserProfileLocalStorageGateway {

    //MARK: - getEntity

    var getEntityByCallsCount = 0
    var getEntityByCalled: Bool {
        return getEntityByCallsCount > 0
    }
    var getEntityByReceivedIdentifier: String?
    var getEntityByReturnValue: Result<UserProfile?>!
    var getEntityByClosure: ((String) -> Result<UserProfile?>)?

    func getEntity(by identifier: String) -> Result<UserProfile?> {
        getEntityByCallsCount += 1
        getEntityByReceivedIdentifier = identifier
        return getEntityByClosure.map({ $0(identifier) }) ?? getEntityByReturnValue
    }

    //MARK: - fetchBooks

    var fetchBooksCompletionHandlerCallsCount = 0
    var fetchBooksCompletionHandlerCalled: Bool {
        return fetchBooksCompletionHandlerCallsCount > 0
    }
    var fetchBooksCompletionHandlerReceivedCompletionHandler: (FetchEntitiesCompletionHandler)?
    var fetchBooksCompletionHandlerClosure: ((@escaping FetchEntitiesCompletionHandler) -> Void)?

    func fetchBooks(completionHandler: @escaping FetchEntitiesCompletionHandler) {
        fetchBooksCompletionHandlerCallsCount += 1
        fetchBooksCompletionHandlerReceivedCompletionHandler = completionHandler
        fetchBooksCompletionHandlerClosure?(completionHandler)
    }

    //MARK: - add

    var addParametersCompletionHandlerCallsCount = 0
    var addParametersCompletionHandlerCalled: Bool {
        return addParametersCompletionHandlerCallsCount > 0
    }
    var addParametersCompletionHandlerReceivedArguments: (parameters: UserProfile, completionHandler: AddEntityCompletionHandler)?
    var addParametersCompletionHandlerClosure: ((UserProfile, @escaping AddEntityCompletionHandler) -> Void)?

    func add(parameters: UserProfile, completionHandler: @escaping AddEntityCompletionHandler) {
        addParametersCompletionHandlerCallsCount += 1
        addParametersCompletionHandlerReceivedArguments = (parameters: parameters, completionHandler: completionHandler)
        addParametersCompletionHandlerClosure?(parameters, completionHandler)
    }

    //MARK: - delete

    var deleteEntityCompletionHandlerCallsCount = 0
    var deleteEntityCompletionHandlerCalled: Bool {
        return deleteEntityCompletionHandlerCallsCount > 0
    }
    var deleteEntityCompletionHandlerReceivedArguments: (entity: UserProfile, completionHandler: DeleteEntityCompletionHandler)?
    var deleteEntityCompletionHandlerClosure: ((UserProfile, @escaping DeleteEntityCompletionHandler) -> Void)?

    func delete(entity: UserProfile, completionHandler: @escaping DeleteEntityCompletionHandler) {
        deleteEntityCompletionHandlerCallsCount += 1
        deleteEntityCompletionHandlerReceivedArguments = (entity: entity, completionHandler: completionHandler)
        deleteEntityCompletionHandlerClosure?(entity, completionHandler)
    }

}
