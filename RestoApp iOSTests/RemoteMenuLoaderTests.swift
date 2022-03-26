//
//  RemoteMenuLoaderTests.swift
//  RestoApp-iOSTests
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import XCTest
import RxSwift
@testable import RestoApp_iOS

class RemoteMenuLoaderTests: XCTestCase {
    typealias Category = RestoApp_iOS.Category
    func test_initSut_returnsNoError() {
        let _ = RemoteMenuLoader()
    }
    
    func test_getMenu_ReturnsValidData() {
        let disposeBag = DisposeBag()
        var results:[[Category]] = []
        let sut = RemoteMenuLoader()
        let exp = expectation(description: "wait for getting menus")
        
        sut.getMenu().subscribe(onNext: {result in
            results.append(result)
            XCTAssertEqual(results.count, 1)
            XCTAssertEqual(results.first!.count, 0)
            exp.fulfill()
        }, onError: {error in
            XCTFail("got an error: \(error)")
        }).disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
}
