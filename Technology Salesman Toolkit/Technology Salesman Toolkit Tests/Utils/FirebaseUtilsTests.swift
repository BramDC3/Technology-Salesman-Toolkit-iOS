import XCTest
@testable import Technology_Salesman_Toolkit

class FirebaseUtilsTests: XCTestCase {
    
    func testConvertToCategory_ReturnsCategory() {
        XCTAssertEqual(FirebaseUtils.convertToCategory(0), Category.windows)
        XCTAssertEqual(FirebaseUtils.convertToCategory(1), Category.android)
        XCTAssertEqual(FirebaseUtils.convertToCategory(2), Category.apple)
        
        let number = Int.random(in: 3 ... 100)
        XCTAssertEqual(FirebaseUtils.convertToCategory(number), Category.other)
    }
    
    func testConvertToList_ReturnsList() {
        let array = ["this", "is", "a", "test"]
        let list = FirebaseUtils.convertToList(array)
        XCTAssertEqual(list.count, 4)
    }

}
