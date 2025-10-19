//
//  SwiftUIDay2DayTests.swift
//  SwiftUIDay2DayTests
//
//  Created by Abdallah Edres on 15/10/2025.
//

import XCTest
@testable import SwiftUIDay2Day

final class SwiftUIDay2DayTests: XCTestCase {
    
    func testLibraryVersion() {
        XCTAssertEqual(SwiftUIDay2Day.version, "1.0.0")
    }
    
    func testTextStyles() {
        let titleLarge = AppTextStyle.titleLarge
        let bodyRegular = AppTextStyle.bodyRegular
        let caption = AppTextStyle.caption
        
        XCTAssertNotNil(titleLarge.font)
        XCTAssertNotNil(bodyRegular.font)
        XCTAssertNotNil(caption.font)
    }
    
    func testOptionalStringExtension() {
        let emptyString: String? = ""
        let nilString: String? = nil
        let validString: String? = "Hello"
        
        XCTAssertTrue(emptyString.isNilOrEmpty)
        XCTAssertTrue(nilString.isNilOrEmpty)
        XCTAssertFalse(validString.isNilOrEmpty)
    }
    
    func testOptionalArrayExtension() {
        let emptyArray: [Int]? = []
        let nilArray: [Int]? = nil
        let validArray: [Int]? = [1, 2, 3]
        
        XCTAssertTrue(emptyArray.isNilOrEmpty)
        XCTAssertTrue(nilArray.isNilOrEmpty)
        XCTAssertFalse(validArray.isNilOrEmpty)
    }
    
    func testCountryEntity() {
        let country = CountryEntity(
            id: 1,
            name: "Saudi Arabia",
            callingCode: "+966",
            flag: "🇸🇦"
        )
        
        XCTAssertEqual(country.id, 1)
        XCTAssertEqual(country.name, "Saudi Arabia")
        XCTAssertEqual(country.callingCode, "+966")
        XCTAssertTrue(country.title.contains("+966"))
    }
}
