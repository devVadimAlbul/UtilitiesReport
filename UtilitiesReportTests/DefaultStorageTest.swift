//
//  DefaultStorageTest.swift
//  UtilitiesReportTests
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import XCTest
@testable import UtilitiesReport

class DefaultStorageTest: XCTestCase {
    
    let describing = UserDefaultsDescribingMock()
    var storage: DefaultsStorage!

    override func setUp() {
        super.setUp()
        storage = DefaultsStorageImpl(describing: describing)
    }
    
    func test_save_value_success() {
        let valueToResult = "Test"
        let keyToResult = "TestKey"
        describing.synchronizeReturnValue = true
        do {
            try storage.saveValue(valueToResult, forKey: keyToResult)
        } catch {
            XCTFail("Not save value")
        }
        
        XCTAssertEqual(describing.setForKeyCallsCount, 1)
        XCTAssertEqual(describing.synchronizeCallsCount, 1)
        XCTAssertNotNil(describing.setForKeyReceivedArguments)
        XCTAssertNotNil(describing.setForKeyReceivedArguments!.value as? String)
        XCTAssertEqual(describing.setForKeyReceivedArguments!.defaultName, keyToResult)
        XCTAssertEqual(describing.setForKeyReceivedArguments!.value as! String, valueToResult)
    }
    
    func test_save_data_success() {
        let valueToResult = "Test".data(using: .utf8)
        let keyToResult = "TestKey"
        describing.synchronizeReturnValue = true
        do {
            try storage.saveData(valueToResult, forKey: keyToResult)
        } catch {
            XCTFail("Not save data")
        }
        
        XCTAssertEqual(describing.setForKeyCallsCount, 1)
        XCTAssertEqual(describing.synchronizeCallsCount, 1)
        XCTAssertNotNil(describing.setForKeyReceivedArguments)
        XCTAssertNotNil(describing.setForKeyReceivedArguments!.value as? Data)
        XCTAssertEqual(describing.setForKeyReceivedArguments!.defaultName, keyToResult)
        XCTAssertEqual(describing.setForKeyReceivedArguments!.value as? Data, valueToResult)
    }
    
    func test_get_value_succcess() {
        let valueToResult = "Test"
        let keyToResult = "TestKey"
        describing.valueForKeyReturnValue = valueToResult
        var returnValue: String? = nil
        do {
            returnValue = try storage.getValue(forKey: keyToResult)
        } catch {
            XCTFail("Not get value")
        }
        
        XCTAssert(describing.valueForKeyCalled)
        XCTAssertEqual(describing.valueForKeyCallsCount, 1)
        XCTAssertEqual(describing.synchronizeCallsCount, 0)
        XCTAssertNotNil(returnValue)
        XCTAssertEqual(returnValue!, valueToResult)
        XCTAssertEqual(describing.valueForKeyReceivedKey, keyToResult)
    }
    
    func test_get_data_succcess() {
        let valueToResult = "Test".data(using: .utf8)
        let keyToResult = "TestKey"
        describing.valueForKeyReturnValue = valueToResult
        var returnValue: Data? = nil
        do {
            returnValue = try storage.getData(forKey: keyToResult)
        } catch {
            XCTFail("Not get data")
        }
        
        XCTAssert(describing.valueForKeyCalled)
        XCTAssertEqual(describing.valueForKeyCallsCount, 1)
        XCTAssertEqual(describing.synchronizeCallsCount, 0)
        XCTAssertNotNil(returnValue)
        XCTAssertEqual(returnValue!, valueToResult)
        XCTAssertEqual(describing.valueForKeyReceivedKey, keyToResult)
    }
    
    func test_remove_data_success() {
        let keyToResult = "TestKey"
        describing.synchronizeReturnValue = true
       
        storage.removeObject(forKey: keyToResult)

        XCTAssert(describing.removeObjectForKeyCalled)
        XCTAssertEqual(describing.removeObjectForKeyCallsCount, 1)
        XCTAssertEqual(describing.synchronizeCallsCount, 1)
        XCTAssertEqual(describing.removeObjectForKeyReceivedDefaultName, keyToResult)
    }
}
