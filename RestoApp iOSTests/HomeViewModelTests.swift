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
        let sut = makeSut()
        expect(sut, toCompleteWithCategoriesStates: [[]], when: {})
        expect(sut, toCompleteWithCategoryHeadersStates: [[]], when: {})
    }
    
    func test_load_loaded5Items() {
        let jsonData = getSampleJsonData()
        URLProtocolStub.stub(data: jsonData, response: anyHTTPURLResponse(), error: nil)
        let sut = makeSut()
        
        let expectedStates:[[CategoryViewModel]] = [
            [],
            [anyCategoryViewModel(), anyCategoryViewModel(), anyCategoryViewModel(), anyCategoryViewModel(), anyCategoryViewModel()]
        ]
        expect(sut, toCompleteWithCategoriesStates: expectedStates, when: {
            sut.load()
        })
    }
    
    //MARK: Helpers
    private func makeSut() -> HomeViewModel {
        let menuLoader = makeRemoteMenuLoader()
        let sut = HomeViewModel(menuLoader: menuLoader)
        return sut
    }
    
    private func makeRemoteMenuLoader(file: StaticString = #filePath, line: UInt = #line) -> RemoteMenuLoader {
        let httpClient = makeHttpClient()
        let remoteMenuLoader = RemoteMenuLoader(httpClient: httpClient)
        trackForMemoryLeaks(remoteMenuLoader, file: file, line: line)
        return remoteMenuLoader
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
        let path = bundle.path(forResource: "home", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
    
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
        
        action()
        wait(for: [exp], timeout: 1.0)
        
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
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        //assertion
        XCTAssertEqual(capturedCategoryResults.count, expectedCategoriesStates.count)
    }
    
    private func anyCategoryViewModel() -> CategoryViewModel {
        CategoryViewModel(name: "anything", items: [])
    }
}
