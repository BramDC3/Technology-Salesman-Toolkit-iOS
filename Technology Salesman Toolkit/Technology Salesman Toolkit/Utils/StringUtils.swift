import Foundation
import RealmSwift

/// Utilities used by functions that need to manipulate strings.
struct StringUtils {
    
    /**
     Retrieving the first name of a full name.
     
     - Parameter fullname: Full name of the user.
     
     - Returns: First name of the user.
     */
    static func getFirstname(from fullname: String?) -> String {
        if let fullname = fullname, let index = fullname.firstIndex(of: " ") {
            let firstname = String(fullname[..<index])
            return firstname
        }
        return ""
    }
    
    /**
     Retrieving the last name of a full name.
     
     - Parameter fullname: Full name of the user.
     
     - Returns: Last name of the user.
     */
    static func getLastname(from fullname: String?) -> String {
        if let fullname = fullname, let index = fullname.firstIndex(of: " ") {
            let lastname = String(fullname[index...]).trimmingCharacters(in: .whitespaces)
            return lastname
        }
        return ""
    }
    
    /**
     Formatting a list of strings to a single string.
     Used to format the content of an instruction.
     
     - Parameter content: List of steps of an instruction.
     
     - Returns: Formatted string with the all values from content.
     */
    static func formattingInstructionsList(with content: List<String>) -> String {
        var string = ""
        for (index, instruction) in content.enumerated() {
            string += "\(index + 1). \(instruction)\n\n"
        }
        return string
    }
    
    /**
     Formatting a double to look more like a price.
     Used to format the price of a service.
     
     - Parameter price: Price of a service.
     
     - Returns: Formatted price in Euro format.
     */
    static func formatPrice(_ price: Double) -> String {
        return String(format: "€ %.2f", price)
    }
    
}
