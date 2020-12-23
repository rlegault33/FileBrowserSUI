
//
//  FileParser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 13/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

class FileParser {
    
    static let sharedInstance = FileParser()
    
    var sortByCreateTime: Bool = false
    
    var _excludesFileExtensions = [String]()
    
    ///
    var _includeFileExtensions = [String]()
    /// Mapped for case insensitivity
    var excludesFileExtensions: [String]? {
        get {
            return _excludesFileExtensions.map({$0.lowercased()})
        }
        set {
            if let newValue = newValue {
                _excludesFileExtensions = newValue
            }
        }
    }
    
    var includeFileExtensions: [String]? {
        get {
            return _includeFileExtensions.map({$0.lowercased()})
        }
        set {
            if let newValue = newValue {
                _includeFileExtensions = newValue
            }
        }
    }
    
    var excludesFilepaths: [URL]?
    var includeFilepaths: [URL]?
    
    let fileManager = FileManager.default
    
    func documentsURL() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    }
    
    func filesForDirectory(_ directoryPath: URL, xInfo0:FileExtraInfo?, xInfo1: FileExtraInfo?) -> [FBFile]  {
        var files = [FBFile]()
        var filePaths = [URL]()
        // Get contents
        do  {
            filePaths = try self.fileManager.contentsOfDirectory(at: directoryPath, includingPropertiesForKeys: [], options: [.skipsHiddenFiles])
        } catch {
            return files
        }
        // Parse
        for filePath in filePaths {
            let file = FBFile(filePath: filePath, xInfo0: xInfo0, xInfo1: xInfo1)
            if let excludesFilepaths = excludesFilepaths , excludesFilepaths.contains(file.filePath) {
                continue
            }
            
            if let includesFileExtension = includeFileExtensions, includesFileExtension.isEmpty == false {
                if let fileExtension = file.fileExtension, includesFileExtension.contains(fileExtension) == false {
                    continue
                }
            } else if let excludesFileExtensions = excludesFileExtensions, let fileExtensions = file.fileExtension , excludesFileExtensions.contains(fileExtensions) {
                    continue
            }
        
            if file.displayName.isEmpty == false {
                files.append(file)
            }
        }
        // Sort
        if sortByCreateTime {
            files = files.sorted(){
                if let aCreate = $0.fileAttributes!.fileCreationDate(), let bCreate =  $1.fileAttributes!.fileCreationDate() {
                    if aCreate != bCreate {
                        return aCreate < bCreate
                    }
                }
                return $0.displayName < $1.displayName
            }
        } else {
            files = files.sorted(){$0.displayName < $1.displayName}
        }
        return files
    }

}
