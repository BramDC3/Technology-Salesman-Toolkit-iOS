//
//  Instruction.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 11/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import Foundation

struct Instruction {
    let id: String
    let title: String
    let description: String
    let content: String
    let image: String
}

extension Instruction {
    init?(dictionary: [String : Any], id: String) {
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let content = dictionary["content"] as? String,
            let image = dictionary["image"] as? String
            else { return nil }
        
        self.init(
            id: id,
            title: title,
            description: description,
            content: content,
            image: image
        )
    }
}
