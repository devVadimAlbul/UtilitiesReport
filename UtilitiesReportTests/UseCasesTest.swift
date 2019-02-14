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
        
        storage.fetchBooksCompletionHandlerClosure = { (completion) in
            completion(.success([testSetValue]))
        }
        
        useCase.load { (result) in
            self.assertThrow(result)
            let value = try! result.dematerialize()
            XCTAssertNotNil(value)
            XCTAssertEqual(value!, testSetValue)
        }
        
        XCTAssertTrue(self.storage.fetchBooksCompletionHandlerCalled)
        XCTAssertEqual(self.storage.fetchBooksCompletionHandlerCallsCount, 1)
    }
    
    func test_get_user_profile_use_case_success() {
        let useCase = GetSavedUserProfileUseCaseImpl(storage: storage)
        let testSetValue = getTestUserProfile()
        let testIdentifier = "test"
        let expectedResult: Result<UserProfile?> = .success(testSetValue)
        storage.getEntityByReturnValue = expectedResult
        var result: UserProfile?
        do {
            result = try useCase.getUserProfile(identifier: testIdentifier)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertTrue(self.storage.getEntityByCalled)
        XCTAssertEqual(self.storage.getEntityByCallsCount, 1)
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, testSetValue)
        XCTAssertEqual(storage.getEntityByReceivedIdentifier, testIdentifier)
    }
    
    private func getTestUserProfile() -> UserProfile {
        return UserProfile(
            firstName: "test",
            lastName: "test",
            city: "testCity",
            street: "testStreat",
            house: "3",
            apartment: "2",
            phoneNumber: "093333333"
        )
    }
    
    func assertThrow<T>(_ result: Result<T>, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNoThrow(try result.dematerialize(), file: file, line: line)
    }
}
