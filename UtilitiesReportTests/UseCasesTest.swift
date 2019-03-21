//
//  UseCasesTest.swift
//  UtilitiesReportTests
//
//  Created by Vadim Albul on 2/13/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import XCTest
@testable import UtilitiesReport

class UseCasesTest: XCTestCase {
    
    let storage = UserProfileLocalStorageGatewayMock()
    
    override func setUp() {
        
    }
    
    func test_save_user_profile_use_case_success() {
        let useCase = SaveUserProfileUseCaseImpl(storage: storage)
        let testSetValue = getTestUserProfile()
        storage.addParametersCompletionHandlerClosure = { data, completion in
            XCTAssertEqual(data, testSetValue)
            completion(.success(testSetValue))
        }
        
        useCase.save(user: testSetValue) { (result) in
            self.assertThrow(result)
            XCTAssertNotNil(try? result.dematerialize())
        }
        
        XCTAssertTrue(self.storage.addParametersCompletionHandlerCalled)
        XCTAssertEqual(self.storage.addParametersCompletionHandlerCallsCount, 1)
    }
    
    func test_lead_user_profile_use_case_success() {
        let useCase = LoadUserProfileUseCaseImpl(storage: storage)
        let testSetValue = getTestUserProfile()
        
        storage.loadEntityCompletionHandlerClosure = { (completion) in
            completion(.success(testSetValue))
        }
        
        useCase.load { (result) in
            self.assertThrow(result)
            let value = try! result.dematerialize()
            XCTAssertNotNil(value)
            XCTAssertEqual(value, testSetValue)
        }
        
        XCTAssertTrue(self.storage.loadEntityCompletionHandlerCalled)
        XCTAssertEqual(self.storage.loadEntityCompletionHandlerCallsCount, 1)
    }
    
    private func getTestUserProfile() -> UserProfile {
        return UserProfile(firstName: "test",
                           lastName: "test",
                           email: "test@gmail.com",
                           phoneNumber: "333333",
                           city: "test",
                           street: "test",
                           house: "test",
                           apartment: "109")
    }
    
    func assertThrow<T>(_ result: Result<T>, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNoThrow(try result.dematerialize(), file: file, line: line)
    }
}
