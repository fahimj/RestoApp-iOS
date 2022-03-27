//
//  DetailViewModelTests.swift
//  RestoApp-iOSTests
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import XCTest
import RxSwift
@testable import RestoApp_iOS

class DetailViewModelTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }
    
    func test_load_ItemStateUpdated(){
        let sut = makeSut()
        let expectedNewItemViewModel = ItemViewModel(id: "6176686afc13ae4e76000004", name: "Rosemary and bacon cupcakes", imageUrl: "https://i.picsum.photos/id/292/3852/2556.jpg?hmac=cPYEh0I48Xpek2DPFLxTBhlZnKVhQCJsbprR-Awl9lo", description: "Crumbly cupcakes made with dried rosemary and back bacon", tags: [
            "flour",
            "butter",
            "egg",
            "sugar",
            "rosemary",
            "bacon"
        ], price: "SGD 3")
        
        expect(sut, toCompleteWithItemStates: [makeItemViewModel(), expectedNewItemViewModel], when: {
            let jsonData = getSampleJsonData()
            URLProtocolStub.stub(data: jsonData, response: anyHTTPURLResponse(), error: nil)
            sut.load()
        })
    }
    
    //MARK: Helpers
    private func makeSut() -> DetailViewModel {
        let itemDetailLoader = makeRemoteItemDetailLoader()
        let itemViewModel = makeItemViewModel()
        let sut = DetailViewModel(itemDetailLoader: itemDetailLoader, menuItem: itemViewModel)
        return sut
    }
    
    private func makeItemViewModel() -> ItemViewModel {
        ItemViewModel(id: "6176686afc13ae4e76000004", name: "Rosemary and bacon cupcakes", imageUrl: "https://picsum.photos/id/1000/5626/3635", description: "Crumbly cupcakes made with dried rosemary and back bacon", tags: ["any","tags"], price: "3 SGD")
    }
    
    private func makeRemoteItemDetailLoader(file: StaticString = #filePath, line: UInt = #line) -> RemoteItemDetailLoader {
        let httpClient = makeHttpClient()
        let remoteMenuLoader = RemoteItemDetailLoader(httpClient: httpClient)
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
        let path = bundle.path(forResource: "detail", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
    
    private func expect(_ sut: DetailViewModel, toCompleteWithItemStates expectedItemStates:[ItemViewModel], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectationFullfillmentCount = expectedItemStates.count
        let disposeBag = DisposeBag()
        var capturedResults:[ItemViewModel] = []
        let exp = expectation(description: "wait for getting states")
        exp.expectedFulfillmentCount = expectationFullfillmentCount
        sut.item.subscribe(onNext: {items in
            capturedResults.append(items)
            exp.fulfill()
        }, onError: {error in
            XCTFail("unexpected error \(error)")
        }).disposed(by: disposeBag)
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        //assertion
        XCTAssertEqual(capturedResults.count, expectedItemStates.count)
        XCTAssertEqual(capturedResults.map{result in
            result.name
        }, expectedItemStates.map{result in
            result.name
        })
        XCTAssertEqual(capturedResults.map{result in
            result.id
        }, expectedItemStates.map{result in
            result.id
        })
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
        XCTAssertEqual(capturedCategoryResults.map{result in
            result.map{$0.name}
        }, expectedCategoriesStates.map{result in
            result.map{$0.name}
        })
    }
    
    private func anyCategoryViewModel() -> CategoryViewModel {
        CategoryViewModel(name: "anything", items: [])
    }
    
    private func anyCategoryHeaderViewModel() -> CategoryHeaderViewModel {
        CategoryHeaderViewModel(name: "anything")
    }
}
