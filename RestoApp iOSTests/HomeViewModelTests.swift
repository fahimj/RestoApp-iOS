//
//  HomeViewModelTests.swift
//  RestoApp-iOSTests
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import XCTest
import RxSwift
import RxRelay
@testable import RestoApp_iOS

class HomeViewModelTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_init_doesntLoadAnyItem() {
        let sut = HomeViewModel()
        expect(sut, toCompleteWithCategoriesStates: [[]], when: {})
        expect(sut, toCompleteWithCategoryHeadersStates: [[]], when: {})
    }
    
    //MARK: Helpers
    
    private func expect(_ sut: HomeViewModel, toCompleteWithCategoriesStates expectedCategoriesStates:[[CategoryViewModel]], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectationFullfillmentCount = expectedCategoriesStates.count
        let disposeBag = DisposeBag()
        var capturedCategoryResults:[[CategoryViewModel]] = []
        let exp = expectation(description: "wait for getting states")
        exp.expectedFulfillmentCount = expectationFullfillmentCount
        sut.categoryViewModels.subscribe(onNext: {items in
            capturedCategoryResults.append(items)
            exp.fulfill()
        }, onError: {error in
            XCTFail("unexpected error \(error)")
        }).disposed(by: disposeBag)
        wait(for: [exp], timeout: 1.0)
        
        action()
        
        //assertion
        XCTAssertEqual(capturedCategoryResults.count, expectedCategoriesStates.count)
    }
    
    private func expect(_ sut: HomeViewModel, toCompleteWithCategoryHeadersStates expectedCategoriesStates:[[CategoryHeaderViewModel]], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectationFullfillmentCount = expectedCategoriesStates.count
        let disposeBag = DisposeBag()
        var capturedCategoryResults:[[CategoryHeaderViewModel]] = []
        let exp = expectation(description: "wait for getting states")
        exp.expectedFulfillmentCount = expectationFullfillmentCount
        sut.categoryHeaderViewModels.subscribe(onNext: {items in
            capturedCategoryResults.append(items)
            exp.fulfill()
        }, onError: {error in
            XCTFail("unexpected error \(error)")
        }).disposed(by: disposeBag)
        wait(for: [exp], timeout: 1.0)
        
        action()
        
        //assertion
        XCTAssertEqual(capturedCategoryResults.count, expectedCategoriesStates.count)
    }
}
