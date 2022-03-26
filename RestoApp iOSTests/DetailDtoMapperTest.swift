//
//  DetailDtoMapperTest.swift
//  RestoApp-iOSTests
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import XCTest
@testable import RestoApp_iOS

class DetailDtoMapperTest: XCTestCase {
    typealias sut = DetailDtoMapper
    
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
            XCTAssertEqual(result.id, "6176686afc13ae4e76000004")
            XCTAssertEqual(result.price, 3)
            XCTAssertEqual(result.tags.count, 6)
            XCTAssertEqual(result.variants.count, 3)
            XCTAssertEqual(result.addOnCategories.count, 3)
            
            let allAddonItems = result.addOnCategories.flatMap{$0.addons}
            XCTAssertEqual(allAddonItems.count, 6)
            XCTAssertEqual(allAddonItems.first!.id, "addon_sauce_a")
            XCTAssertEqual(allAddonItems.last!.id, "addon_esdb_b")
        } catch {
            XCTFail("Should catch no error, but found and error: \(error)")
        }
    }
    
    // MARK: Helpers
    
    private func getSampleJsonData() -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "detail", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }

}
