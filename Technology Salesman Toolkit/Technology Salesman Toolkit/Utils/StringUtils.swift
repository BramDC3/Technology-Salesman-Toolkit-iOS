import Foundation
import RealmSwift

struct StringUtils {
    
    static func getFirstname(from fullname: String?) -> String {
        if let fullname = fullname, let index = fullname.firstIndex(of: " ") {
            let firstname = String(fullname[..<index])
            return firstname
        }
        return ""
    }
    
    static func getLastname(from fullname: String?) -> String {
        if let fullname = fullname, let index = fullname.firstIndex(of: " ") {
            let lastname = String(fullname[index...]).trimmingCharacters(in: .whitespaces)
            return lastname
        }
        return ""
    }
    
    static func formattingInstructionsList(with content: List<String>) -> String {
        var string = ""
        for (index, instruction) in content.enumerated() {
            string += "\(index + 1). \(instruction)\n\n"
        }
        return string
    }
    
    static func formatPrice(_ price: Double) -> String {
        return String(format: "€ %.2f", price)
    }
    
}
