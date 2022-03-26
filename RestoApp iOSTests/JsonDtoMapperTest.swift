//
//  JsonDtoMapperTest.swift
//
//  Created by Fahim Jatmiko on 17/03/22.
//

import XCTest
@testable import RestoApp_iOS

class JsonDtoMapperTests: XCTestCase {
    typealias sut = HomeDtoMapper
    
    func test_map_throwsErrorOnEmptyData() {
        do {
            let _ = try sut.map(data: Data())
        } catch {
            return
        }
        
        XCTFail()
    }
    
    func test_map_throwsErrorOnInvalidData() {
        do {
            let _ = try sut.map(data: "any data".data(using: .ascii)!)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        XCTFail("Should catch decoding json error")
    }
    
    func test_map_returnsCorrectData() {
        let data = getSampleJsonData()
        do {
            let result = try sut.map(data: data)
            XCTAssertTrue(result.count == 5)
            XCTAssertEqual(result.first!.items.count, 10)
            XCTAssertEqual(result.first!.items.first!.imageUrl, "https://picsum.photos/id/0/5616/3744")
            
            XCTAssertEqual(result[1].id, "appetizer")
            XCTAssertEqual(result[1].items.first!.name, "Tofu and sweetcorn gyoza")
        } catch {
            XCTFail("Should catch no error, but found and error: \(error)")
        }
    }
    
    // MARK: Helpers
    
    private func getSampleJsonData() -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "home", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
}
