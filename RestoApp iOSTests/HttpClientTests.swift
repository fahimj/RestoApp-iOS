//
//  HttpClientTests.swift
//  RestoApp-iOSTests
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import XCTest
import RxSwift
@testable import RestoApp_iOS

class HttpClientTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_load_returnsAnyData() {
        let disposeBag = DisposeBag()
        var results:[Data] = []
        
        let expectation = expectation(description: "wait async")
        let sut = makeSUT()
        URLProtocolStub.stub(data: anyData(), response: anyHTTPURLResponse(), error: nil)
        
        sut.load(urlString: anyURL().absoluteString).subscribe(onNext: {data in
            results.append(data)
            XCTAssertEqual(results, [anyData()])
            expectation.fulfill()
        }, onError: {error in
            XCTFail("should not expect error \(error)")
        }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
    }
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HttpClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = UrlSessionHttpClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }

}
