//
//  MapExFileInfo.swift
//  FileBrowserSUI_Dev
//
//  Created by Richard Legault on 2020-12-21.
//

import Foundation
struct FileExSettings{
   var setting:[Int]=[-1,-1]
}

enum list0: String, CaseIterable {
    case zero = ""
    case one = "desc mpg"
    case two = "desc gif"
    case three = "desc zip"
    case four = "desc jpg"
    
    init?(id:Int) {
        switch id {
        case 0: self = .zero
        case 1: self = .one
        case 2: self = .two
        case 3: self = .three
        case 4: self = .four
        default: return nil
        }
    }
}

enum listA: String, CaseIterable {
    case zero = ""
    case one = "small"
    case two = "med"
    case three = "large"

    
    init?(id:Int) {
        switch id {
        case 0: self = .zero
        case 1: self = .one
        case 2: self = .two
        case 3: self = .three
        default: return nil
        }
    }
}

class MapExFileInfo {
    var fileDict = [String:FileExSettings]()
    
    
    func getList0(file:URL)->[String] {
        var v :[String] = []
        for value in list0.allCases {
            v.append(value.rawValue)
        }
        return v
    }
    
    func getListA(file:URL)->[String] {
        var v :[String] = []
        for value in listA.allCases {
            v.append(value.rawValue)
        }
        return v
    }
    func get0(file:URL)->Int
   {
       return getValue(file: file,idx: 0)
   }
   func get1(file:URL)->Int
   {
       return getValue(file: file,idx: 1)
   }
   
   func set0(file:URL, value:Int) {
       setValue(file:file, value:value, idx:0)
   }
   func set1(file:URL, value:Int) {
       setValue(file:file, value:value, idx:1)
   }
   
   private func setValue(file:URL, value:Int, idx: Int) {
        if let _ = fileDict[file.path] {
        } else {
            let _ = getValue(file: file, idx: idx)
        }
        fileDict[file.path]!.setting[idx] = value
   }
    
    private func getValue(file:URL, idx:Int) -> Int {
        if let value = fileDict[file.path] {
            return value.setting[idx]
        } else {
            fileDict[file.path]=FileExSettings()
            return fileDict[file.path]!.setting[idx]
        }
    }
    
    func delete(file:URL) {
        fileDict.removeValue(forKey: file.path)
    }
}
