//
//  Instruction.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 11/12/2018.
//  Copyright © 2018 Bram De Coninck. All rights reserved.
//

import Foundation
import RealmSwift

class Instruction {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var description: String = ""
    @objc dynamic var content: [String] = []
    @objc dynamic var image: String = ""
    @objc dynamic var serviceId: String = ""
    @objc dynamic var index: Int = 0
    
    convenience init(id: String, title: String, description: String, content: [String], image: String, serviceId: String, index: Int) {
        self.init()
        self.id = id
        self.title = title
        self.description = description
        self.content = content
        self.image = image
        self.serviceId = serviceId
        self.index = index
    }
    
    convenience init?(dictionary: [String : Any], id: String) {
        guard let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let content = dictionary["content"] as? [String],
            let image = dictionary["image"] as? String,
            let serviceId = dictionary["serviceId"] as? String,
            let index = dictionary["index"] as? Int
            else { return nil }
        
        self.init(id: id, title: title, description: description, content: content, image: image, serviceId: serviceId, index: index)
    }
}
