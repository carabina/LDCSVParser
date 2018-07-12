
# CSVParser

[![Build Status](https://travis-ci.org/russell-davis/LDCSVParser.svg?branch=master)](https://travis-ci.org/russell-davis/CSVParser)
[![GitHub version](https://badge.fury.io/gh/russell-davis%2FLDCSVParser.svg)](https://badge.fury.io/gh/russell-davis%2FCSVParser)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)




___


## Installation
Clone the repo, open the project, and run. After successful run, navigate to the 'Products' folder and click and drag the framework to your projects directory.

```swift
import LDCSVParser
```


## The Parser
#### Create an instance of the parser using a string
``` swift
let csv = "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20"
let parser = CSVParser(with: csv)
```

#### Create an instance of the parser using a string, and custom headers
``` swift
let csv = "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20"
parser = CSVParser(with: csv, headers: headers)
```

#### Create an instance of the parser using a string, a custom separator, and custom headers
``` swift
let csv = "id,name,age\n1,Alice,18\n2,Bob,19\n3,Charlie,20"
parser = CSVParser(with: csv, separator: separator, headers: header)
```
#### Useful Properties
``` swift
parser.headers // The headers from the data, an Array of String
parser.keyedRows // An array of Dictionaries with the values of each row keyed to the header
parser.rows // An Array of Arrays of the values
```


## Object Creation

Creating objects from the csv data is easy. The parser has the method to take the keyedrows and create individual objects from them.

NOTE: the .build method is is a generic, and as such, the completion handler must be provided a class that conforms to Codeable.

Consider the Following class:
``` swift 
class Person: Codable {
    let name: String
    let age: String
    let id: String
}

class SomeViewController {
  func someMethond() {
  
    if let keyed = parser.keyedRows {
      
      // build an object with the keyed rows using the Person class
      parser.build(with: keyed) { (people: [Person]) in
        for person in people {
          print(person.name)
        }
      }
    }
    
  }
}
```
