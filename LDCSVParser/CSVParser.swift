//
//  CSVParser.swift
//  CSVParser
//
//  Created by App Center on 7/11/18.
//  Copyright © 2018 L. Davis Development. All rights reserved.
//

import Foundation
import UIKit

class CSVParser {
    /// The number of columns in the data
    private let columnCount: Int
    /// The headers from the data, an Array of String
    public let headers: [String]
    /// An array of Dictionaries with the values of each row keyed to the header
    public let keyedRows: [[String: String]]?
    // An Array of the rows in an Array of String form, equivalent to keyedRows, but without the keys
    public let rows: [[String]]
    
    
    /// Creates an array of custom objects by decoding the CSV to the custom object type
    ///
    /// - Important: The completion handler MUST have a specified type, which should be 'YourClass.self' that conforms to the Codeable protocol
    ///
    /// - Parameters:
    ///   - KeyedRows: An array of Dictionaries with the values of each row keyed to the header
    ///   - completion: Hands back an initialized array of custom objects
    public func build<T: Codable>(with KeyedRows: [[String: String]], completion: ([T])->()) throws {
        guard let _ = T.self as? Codable else {
            let fullName: String = String(describing: T.self)
            throw CSVErrors.isNotCodeable(type: fullName)
        }
        var objs: [T] = []
        for item in KeyedRows {
            let json = try! JSONEncoder().encode(item)
            do {
                let obj = try JSONDecoder().decode(T.self, from: json)
                objs.append(obj)
            } catch {
                print(error.localizedDescription)
            }
        }
        completion(objs)
    }
    
    
    /// Creates an instance containing the data extracted from the `with` String
    /// - Parameter with: The String obtained from reading the csv file.
    /// - Parameter separator: The separator used in the csv file, defaults to ","
    /// - Parameter headers: The array of headers from the file. If not included, it will be populated with the ones from the first line
    
    public init(with string: String, separator: String = ",", headers: [String]? = nil) {
        var parsedLines = CSVParser.records(from: string.replacingOccurrences(of: "\r\n", with: "\n")).map {
            CSVParser.cells(forRow: $0, separator: separator)
        }
        self.headers = headers ?? parsedLines.removeFirst()
        rows = parsedLines
        columnCount = self.headers.count
        
        let tempHeaders = self.headers
        keyedRows = rows.map { field -> [String: String] in
            var row = [String: String]()
            // Only store value which are not empty
            for (index, value) in field.enumerated() where value.isNotEmptyOrWhitespace {
                if index < tempHeaders.count {
                    row[tempHeaders[index]] = value
                }
            }
            return row
        }
    }
    
    /// Creates an instance containing the data extracted from the `with` String
    /// - Parameter with: The string obtained from reading the csv file.
    /// - Parameter headers: The array of headers from the file. I f not included, it will be populated with the ones from the first line
    /// - Attention: In this conveniennce initializer, we assume that the separator between fields is ","
    public convenience init(with string: String, headers: [String]?) {
        self.init(with: string, separator:",", headers:headers)
    }
    
    /// Analizes a row and tries to obtain the different cells contained as an Array of String
    /// - Parameter forRow: The string corresponding to a row of the data matrix
    /// - Parameter separator: The string that delimites the cells or fields inside the row. Defaults to ","
    internal static func cells(forRow string: String, separator: String = ",") -> [String] {
        return CSVParser.split(separator, string: string).map { element in
            if let first = element.first, let last = element.last, first == "\"" && last == "\"" {
                let range = element.index(after: element.startIndex)..<element.index(after: element.endIndex)
                let s = String(element[range])
                return s
            }
            return element
        }
    }
    
    /// Analizes the CSV data as an String, and separates the different rows as an individual String each.
    /// - Parameter forRow: The string corresponding the whole data
    /// - Attention: Assumes "\n" as row delimiter, needs to filter string for "\r\n" first
    internal static func records(from string: String) -> [String] {
        return CSVParser.split("\n", string: string).filter { $0.isNotEmptyOrWhitespace }
    }
    
    /// Tries to preserve the parity between open and close characters for different formats. Analizes the escape character count to do so
    private static func split(_ separator: String, string: String) -> [String] {
        func oddNumberOfQuotes(_ string: String) -> Bool {
            return string.components(separatedBy: "\"").count % 2 == 0
        }
        
        let initial = string.components(separatedBy: separator)
        var merged = [String]()
        for newString in initial {
            guard let record = merged.last , oddNumberOfQuotes(record) == true else {
                merged.append(newString)
                continue
            }
            merged.removeLast()
            let lastElem = record + separator + newString
            merged.append(lastElem)
        }
        return merged
    }
    
    
}

private enum CSVErrors: Error {
    case isNotCodeable(type: String)
}

extension CSVErrors: LocalizedError {
    public var isNotCodeable: String {
        switch self {
        case .isNotCodeable(type: let type):
            let str = NSLocalizedString("The Class '\(type)' does not conform to the Codable Protocol", comment: "")
            return str
        }
    }
}
