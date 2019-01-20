import XCTest
@testable import Technology_Salesman_Toolkit

class StringUtilsTests: XCTestCase {

    var firstname = "Bram"
    var lastname = "De Coninck"
    var fullname = "Bram De Coninck"
    var invalidFullname = "ThisStringContainsNoSpaces"
    
    func testGetFirstName_ReturnsFirstName() {
        XCTAssertEqual(StringUtils.getFirstname(from: fullname), firstname)
    }
    
    func testGetFirstName_ReturnsEmptyString() {
        XCTAssertEqual(StringUtils.getFirstname(from: invalidFullname), "")
    }
    
    func testGetLastName_ReturnsLastName() {
        XCTAssertEqual(StringUtils.getLastname(from: fullname), lastname)
    }
    
    func testGetLastName_ReturnsEmptyString() {
        XCTAssertEqual(StringUtils.getLastname(from: invalidFullname), "")
    }
    
    func testFormatPrice_ReturnsFormattedPrice() {
        XCTAssertEqual(StringUtils.formatPrice(12.34), "€ 12.34")
    }

}
