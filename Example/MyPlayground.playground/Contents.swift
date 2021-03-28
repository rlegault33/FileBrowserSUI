import UIKit

var str = "Hello, playground"

enum list0: String, CaseIterable {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    
    
}

let v = list0.allCases

print(v)

print(v[1])
