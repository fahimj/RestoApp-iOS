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
    
    func test_loadAndSelect_variantsStateUpdated() {
        let sut = makeSut()
        let expectedNewVariantsState = [
            Variant(id: "varian_1", name: "Mashed Potato"),
            Variant(id: "varian_2", name: "French Fries"),
            Variant(id: "varian_3", name: "Potato Wedges")
        ]
        
        expect(sut, toCompleteWithVariantStates: [[],expectedNewVariantsState], when: {
            let jsonData = getSampleJsonData()
            URLProtocolStub.stub(data: jsonData, response: anyHTTPURLResponse(), error: nil)
            sut.load()
        })
        
        let expectedSelectedVariant = Variant(id: "varian_2", name: "French Fries")
        expect(sut, toCompleteWithSelectedVariantStates: [nil, expectedSelectedVariant, nil], when: {
            sut.selectVariant(id: "varian_2")
            sut.selectVariant(id: "")
        })
    }
    
    func test_load_AddonStateUpdated() {
        let expectedAddonStates:[[AddonCategoryViewModel]] = [
            [],
            [AddonCategoryViewModel.createModel(from: AddonCategory(id: "sauce", name: "Sauce", addons: [anyAddon(),anyAddon()])),
             AddonCategoryViewModel.createModel(from: AddonCategory(id: "extra_side_dish_a", name: "Extra Side Dish", addons: [anyAddon(),anyAddon()])),
             AddonCategoryViewModel.createModel(from: AddonCategory(id: "extra_side_dish_b", name: "Extra Side Dish", addons: [anyAddon(),anyAddon()]))
            ]
        ]
        let sut = makeSut()
        expect(sut, toCompleteWithAddonCategoryStates: expectedAddonStates, when: {
            let jsonData = getSampleJsonData()
            URLProtocolStub.stub(data: jsonData, response: anyHTTPURLResponse(), error: nil)
            sut.load()
        })
    }
    
    func test_addNote_textNoteStateUpdate() {
        let sut = makeSut()
        
        let stringWith200Chars = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu"
        let stringWith201Chars = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qux"
        let expectedTextNoteStates = [
            "",
            "tes 1 2 3",
            "tes 1 2 3 4",
            stringWith200Chars
        ]
        expect(sut, toCompleteWithSelectedTextNoteStates: expectedTextNoteStates, when: {
            sut.notes.update(text: "tes 1 2 3")
            sut.notes.update(text: "tes 1 2 3 4")
            sut.notes.update(text: stringWith201Chars)
        })
    }
    
    func test_addNote_charCountStateUpdate() {
        let sut = makeSut()
        
        let stringWith200Chars = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qu"
        let stringWith201Chars = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec qux"
        
        expect(sut, toCompleteWithCharCountStates: [
            "0 / 200",
            "9 / 200",
            "200 / 200",
            "200 / 200"
        ], when: {
            sut.notes.update(text: "tes 1 2 3")
            sut.notes.update(text: stringWith200Chars)
            sut.notes.update(text: stringWith201Chars)
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
    
    private func wait(for duration: TimeInterval) {
        let waitExpectation = expectation(description: "Waiting")
        
        let when = DispatchTime.now() + duration
        DispatchQueue.main.asyncAfter(deadline: when) {
            waitExpectation.fulfill()
        }
        
        // We use a buffer here to avoid flakiness with Timer on CI
        waitForExpectations(timeout: duration + 0.5)
    }
    private func anyAddon() -> Addon {
        Addon(id: "any addon", name: "any addon", additionalPrice: 1)
    }
}
