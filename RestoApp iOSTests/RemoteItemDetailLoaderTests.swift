//
//  RemoteItemDetailLoaderTests.swift
//  RestoApp-iOSTests
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import XCTest

import XCTest
import RxSwift
@testable import RestoApp_iOS

class RemoteItemDetailLoaderTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    typealias Category = RestoApp_iOS.Category
    func test_initSut_returnsNoError() {
        let _ = makeSUT()
    }
    
    func test_getMenu_ReturnsValidData() {
        let disposeBag = DisposeBag()
        var results:[MenuItem] = []
        let jsonData = getSampleJsonData()
        let sut = makeSUT()
        URLProtocolStub.stub(data: jsonData, response: anyHTTPURLResponse(), error: nil)

        let exp = expectation(description: "wait for getting menus")
        
        sut.getItemDetail().subscribe(onNext: {result in
            results.append(result)
            XCTAssertEqual(results.count, 1)
            exp.fulfill()
        }, onError: {error in
            XCTFail("got an error: \(error)")
        }).disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> RemoteItemDetailLoader {
        let httpClient = makeHttpClient()
        let remoteItemDetailLoader = RemoteItemDetailLoader(httpClient: httpClient)
        trackForMemoryLeaks(remoteItemDetailLoader, file: file, line: line)
        return remoteItemDetailLoader
    }
    
    private func makeHttpClient(file: StaticString = #filePath, line: UInt = #line) -> HttpClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = UrlSessionHttpClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    
    private func getSampleJsonData() -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "detail", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
}
