//
//  DetailViewModelTests+Specs.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import Foundation
import XCTest
import RxSwift
@testable import RestoApp_iOS

extension DetailViewModelTests {
    
    func expect(_ sut: DetailViewModel, toCompleteWithItemStates expectedItemStates:[ItemViewModel], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
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
    
    func expect(_ sut: DetailViewModel, toCompleteWithVariantStates expectedItemStates:[[Variant]], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectationFullfillmentCount = expectedItemStates.count
        let disposeBag = DisposeBag()
        var capturedResults:[[Variant]] = []
        let exp = expectation(description: "wait for getting states")
        exp.expectedFulfillmentCount = expectationFullfillmentCount
        sut.variant.variants.subscribe(onNext: {items in
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
            result.map{$0.id}
        }, expectedItemStates.map{result in
            result.map{$0.id}
        })
        XCTAssertEqual(capturedResults.map{result in
            result.map{$0.name}
        }, expectedItemStates.map{result in
            result.map{$0.name}
        })
    }
    
    func expect(_ sut: DetailViewModel, toCompleteWithSelectedVariantStates expectedStates:[Variant?], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectationFullfillmentCount = expectedStates.count
        let disposeBag = DisposeBag()
        var capturedResults:[Variant?] = []
        let exp = expectation(description: "wait for getting states")
        exp.expectedFulfillmentCount = expectationFullfillmentCount
        sut.variant.selectedVariant.subscribe(onNext: {items in
            capturedResults.append(items)
            exp.fulfill()
        }, onError: {error in
            XCTFail("unexpected error \(error)")
        }).disposed(by: disposeBag)
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        //assertion
        XCTAssertEqual(capturedResults.count, expectedStates.count)
        XCTAssertEqual(capturedResults.map{result in
            result?.name
        }, expectedStates.map{result in
            result?.name
        })
        XCTAssertEqual(capturedResults.map{result in
            result?.id
        }, expectedStates.map{result in
            result?.id
        })
    }
    
    func expect(_ sut: DetailViewModel, toCompleteWithAddonCategoryStates expectedStates:[[AddonCategoryViewModel]], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectationFullfillmentCount = expectedStates.count
        let disposeBag = DisposeBag()
        var capturedResults:[[AddonCategoryViewModel]] = []
        let exp = expectation(description: "wait for getting states")
        exp.expectedFulfillmentCount = expectationFullfillmentCount
        sut.addonCategories.subscribe(onNext: {items in
            capturedResults.append(items)
            exp.fulfill()
        }, onError: {error in
            XCTFail("unexpected error \(error)")
        }).disposed(by: disposeBag)
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        //assertion
        XCTAssertEqual(capturedResults.count, expectedStates.count)
        XCTAssertEqual(capturedResults.map{result in
            result.map{$0.name}
        }, expectedStates.map{result in
            result.map{$0.name}
        })
        XCTAssertEqual(capturedResults.map{result in
            result.map{$0.addons.value.count}
        }, expectedStates.map{result in
            result.map{$0.addons.value.count}
        })
    }
    
    func expect(_ sut: DetailViewModel, toCompleteWithSelectedTextNoteStates expectedStates:[String], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectationFullfillmentCount = expectedStates.count
        let disposeBag = DisposeBag()
        var capturedResults:[String] = []
        let exp = expectation(description: "wait for getting states")
        exp.expectedFulfillmentCount = expectationFullfillmentCount
        
        sut.notes.noteText.subscribe(onNext: {items in
            capturedResults.append(items)
            exp.fulfill()
        }, onError: {error in
            XCTFail("unexpected error \(error)")
        }).disposed(by: disposeBag)
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        //assertion
        XCTAssertEqual(capturedResults.count, expectedStates.count)
        XCTAssertEqual(capturedResults,expectedStates)
    }
    
    func expect(_ sut: DetailViewModel, toCompleteWithCharCountStates expectedStates:[String], when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let expectationFullfillmentCount = expectedStates.count
        let disposeBag = DisposeBag()
        var capturedResults:[String] = []
        let exp = expectation(description: "wait for getting states")
        exp.expectedFulfillmentCount = expectationFullfillmentCount
        
        sut.notes.charCountDisplay.subscribe(onNext: {items in
            capturedResults.append(items)
            exp.fulfill()
        }, onError: {error in
            XCTFail("unexpected error \(error)")
        }).disposed(by: disposeBag)
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        //assertion
        XCTAssertEqual(capturedResults.count, expectedStates.count)
        XCTAssertEqual(capturedResults,expectedStates)
    }
}
