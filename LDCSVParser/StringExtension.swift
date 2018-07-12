//
//  String Extension.swift
//  CSVParser
//
//  Created by App Center on 7/11/18.
//  Copyright © 2018 L. Davis Development. All rights reserved.
//

import Foundation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        return isEmpty || trimmingCharacters(in: .whitespaces) == ""
    }
    
    var isNotEmptyOrWhitespace: Bool {
        return !isEmptyOrWhitespace
    }
    
}
