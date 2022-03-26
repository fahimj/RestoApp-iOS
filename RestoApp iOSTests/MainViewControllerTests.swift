//
//  MainViewControllerTests.swift
//  RestoApp-iOSTests
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import XCTest
@testable import RestoApp_iOS

class MainViewControllerTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }
    
    func test_initViewController() {
        let sut = makeSut()
        sut.loadViewIfNeeded()
//        let jsonData = getSampleJsonData()
//        URLProtocolStub.stub(data: jsonData, response: anyHTTPURLResponse(), error: nil)
//        XCTAssertEqual(sut.tableView.numberOfSections, 5)
    }
    
    //MARK: Helpers
    private func makeSut() -> MainViewController {
        let vm = makeHomeViewModel()
        let sut = MainViewController(viewModel: vm)
        return sut
    }
    
    private func makeHomeViewModel() -> HomeViewModel {
        let menuLoader = makeRemoteMenuLoader()
        let vm = HomeViewModel(menuLoader: menuLoader)
        return vm
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
}
