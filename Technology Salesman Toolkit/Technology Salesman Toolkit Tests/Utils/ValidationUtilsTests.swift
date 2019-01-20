import XCTest
@testable import Technology_Salesman_Toolkit

class ValidationUtilsTests: XCTestCase {
    
    func testValidateEmail_EmailIsInvalid() {
        XCTAssertFalse(ValidationUtils.isEmailValid("ThisIsNotAValidEmailAddress"))
        XCTAssertFalse(ValidationUtils.isEmailValid("ThisIsAlsoNotAValid@EmailAddress"))
    }
    
    func testValidateEmail_EmailIsValid() {
        XCTAssertTrue(ValidationUtils.isEmailValid("info@bramdeconinck.com"))
    }
    
    func testValidateFields_NotEveryFieldHasValue() {
        XCTAssertFalse(ValidationUtils.everyFieldHasValue(["this", "is", "", "a", "test"]))
        XCTAssertFalse(ValidationUtils.everyFieldHasValue([""]))
        XCTAssertFalse(ValidationUtils.everyFieldHasValue([String]()))
    }
    
    func testValidateFields_EveryFieldHasValue() {
        XCTAssertTrue(ValidationUtils.everyFieldHasValue(["this", "is", "a", "test"]))
    }

}
