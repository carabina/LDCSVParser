//
//  Person.swift
//  Tests
//
//  Created by App Center on 7/11/18.
//  Copyright © 2018 L. Davis Development. All rights reserved.
//

import Foundation

class Person: Codable {
    let name: String
    let age: String
    let id: String
}

class Alien {
    let name: String
    let age: String
    let id: String
    
    init(name: String, age: String, id: String) {
        self.name = name
        self.age = age
        self.id = id
    }
}
