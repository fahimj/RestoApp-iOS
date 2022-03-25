//
//  JsonDtoMapperTest.swift
//
//  Created by Fahim Jatmiko on 17/03/22.
//

import XCTest
@testable import RestoApp_iOS

class JsonDtoMapperTests: XCTestCase {
    func test_map_throwsErrorOnEmptyData() {
        let sut = JsonDtoMapper()
        do {
            let _ = try sut.map(data: Data())
        } catch {
            return
        }
        
        XCTFail()
    }
    
//    func test_mapToPrice_throwsErrorOnInvalidData() {
//        let sut = JsonDtoMapper()
//        do {
//            let _ = try sut.mapToPrice(jsonData: "any data".data(using: .ascii)!)
//        } catch is DecodingError {
//            return
//        } catch {
//            print(error.localizedDescription)
//            XCTFail("Should catch decoding json error")
//        }
//        
//        XCTFail("Should catch decoding json error")
//    }
//    
//    func test_mapToPrice_returns3Items() {
//        let data = getSampleJsonData()
//        let sut = JsonDtoMapper()
//        do {
//            let result = try sut.mapToPrice(jsonData: data)
//            XCTAssertTrue(result.count == 3)
//        } catch {
//            XCTFail("Should catch no error")
//        }
//    }
    
    // MARK: Helpers
    
    private func getSampleJsonData() -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "home", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
}
