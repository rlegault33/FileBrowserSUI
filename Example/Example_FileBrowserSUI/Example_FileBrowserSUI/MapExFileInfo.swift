//
//  MapExFileInfo.swift
//  FileBrowserSUI_Dev
//
//  Created by Richard Legault on 2020-12-21.
//

import Foundation
struct FileExSettings{
   var setting:[Bool]=[false,false]
}

class MapExFileInfo {
   var fileDict = [String:FileExSettings]()
   func get0(file:URL)->Bool
   {
       return getValue(file: file,idx: 0)
   }
   func get1(file:URL)->Bool
   {
       return getValue(file: file,idx: 1)
   }
   
   func set0(file:URL, value:Bool) {
       setValue(file:file, value:value, idx:0)
   }
   func set1(file:URL, value:Bool) {
       setValue(file:file, value:value, idx:1)
   }
   
   private func setValue(file:URL, value:Bool, idx: Int) {
        if let _ = fileDict[file.path] {
        } else {
            let _ = getValue(file: file, idx: idx)
        }
        fileDict[file.path]!.setting[idx] = value
   }
    
    private func getValue(file:URL, idx:Int) -> Bool {
        if let value = fileDict[file.path] {
            return value.setting[idx]
        } else {
            fileDict[file.path]=FileExSettings()
            return fileDict[file.path]!.setting[idx]
        }
    }
    
    func delete(file:URL) -> Bool {
        fileDict.removeValue(forKey: file.path)
        return true
    }
}
