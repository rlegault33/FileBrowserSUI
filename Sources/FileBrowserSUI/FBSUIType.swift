//
//  File.swift
//  
//
//  Created by Richard Legault on 2020-12-19.
//

import Foundation
import UIKit
import QuickLookThumbnailing

public enum ExInfoId: Int, CaseIterable {
    case EXINFO1 = 0
    case EXINFO2 = 1
    var idx: Int {
        switch self {
        case .EXINFO1:
            return ExInfoId.EXINFO1.rawValue
        case .EXINFO2:
            return ExInfoId.EXINFO2.rawValue
        }
    }
}
public typealias FileExtraInfoDelete = (URL) -> Void
public typealias FileExtraInfoGet = (URL) -> Int
// Int is the index of the [String] that is selected in FileExtraInfoList
public typealias FileExtraInfoSet = (URL, Int) -> Void
public typealias FileExtraInfoList = (URL) -> [String]
public struct  FileExtraInfo {
    public let get: FileExtraInfoGet
    public let set: FileExtraInfoSet
    public let list: FileExtraInfoList
    public let delete: FileExtraInfoDelete
    
    public init(get: @escaping FileExtraInfoGet, list: @escaping FileExtraInfoList, set: @escaping FileExtraInfoSet, delete: @escaping FileExtraInfoDelete) {
        self.get = get
        self.list = list // drop down select list
        self.set = set
        self.delete = delete
    }
}

/// FBFile is a class representing a file in FileBrowser
public class FBFile: ObservableObject, Hashable, Identifiable {

    public static func == (lhs: FBFile, rhs: FBFile) -> Bool {
       return(lhs.id == rhs.id)
    }
    
    public var id = UUID()
    var hasValue: Int {
        return id.hashValue
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(filePath)
    }
    /// Display name. String.
    public let displayName: String
    // is Directory. Bool.
    public let isDirectory: Bool
    /// File extension.
    public let fileExtension: String?
    /// File attributes (including size, creation date etc).
    public let fileAttributes: NSDictionary?
    /// NSURL file path.
    public let filePath: URL
    // FBFileType
    public let type: FBFileType
    
    public var fileExInfo0: FileExtraInfo?
    public var fileExInfo1: FileExtraInfo?
    
    // stores the selected index selected from the list
    @Published var fileExInfo0Value: Int {
        didSet {
            if let fileExInfo = fileExInfo0 {
                fileExInfo.set(filePath, fileExInfo0Value)
            }
        }
    }
    @Published var fileExInfo1Value: Int {
        didSet {
            if let fileExInfo = fileExInfo1 {
                fileExInfo.set(filePath, fileExInfo1Value)
            }
        }
    }
    
    func generateImage(completion: @escaping(UIImage?)->Void) {
        
        if self.type != .MP4 {
            completion(self.type.image())
            return
        }
        
        // Create a thumbnail for MP4 files
        let size = CGSize(width: 60, height: 90)
        let scale = UIScreen.main.scale
        
        let request = QLThumbnailGenerator.Request(
            fileAt: self.filePath,
            size: size,
            scale: scale,
            representationTypes: .all)
   
        let generator = QLThumbnailGenerator.shared

        generator.generateBestRepresentation(for: request) { thumbnail, error in
            if let thumbnail = thumbnail {
                completion(thumbnail.uiImage)
            } else if let error = error {
                // Handle error
                print(error)
            }
        
        }
    }
    
    open func delete()
    {
        do
        {
            try FileManager.default.removeItem(at: self.filePath)
        }
        catch
        {
            print("An error occured when trying to delete file:\(self.filePath) Error:\(error)")
        }
    }
    
    /**
     Initialize an FBFile object with a filePath
     
     - parameter filePath: NSURL filePath
     
     - returns: FBFile object.
     */
    init(filePath: URL, xInfo0: FileExtraInfo?, xInfo1: FileExtraInfo?) {
        self.filePath = filePath
        let isDirectory = checkDirectory(filePath)
        self.isDirectory = isDirectory
        if self.isDirectory {
            self.fileAttributes = nil
            self.fileExtension = nil
            self.type = .Directory
        }
        else {
            self.fileAttributes = getFileAttributes(self.filePath)
            self.fileExtension = filePath.pathExtension
            if let fileExtension = fileExtension {
                self.type = FBFileType(rawValue: fileExtension) ?? .Default
            }
            else {
                self.type = .Default
            }
        }
        self.displayName = filePath.lastPathComponent
        if let xInfo0 = xInfo0 {
            fileExInfo0 = xInfo0
            self.fileExInfo0Value = xInfo0.get(filePath)
        } else {
            self.fileExInfo0Value = 0
        }
        
        if let xInfo1 = xInfo1 {
            fileExInfo1 = xInfo1
            self.fileExInfo1Value = xInfo1.get(filePath)
        } else {
            self.fileExInfo1Value = 0
        }
    }
    
    func getExInfo() -> [FileExtraInfo] {
        var array = [FileExtraInfo]()
        if let info = fileExInfo0 {
            array.append(info)
        }
        if let info = fileExInfo1 {
            array.append(info)
        }
        return array
    }
}


/**
 FBFile type
 */
public enum FBFileType: String {
    /// Directory
    case Directory = "directory"
    /// GIF file
    case GIF = "gif"
    /// JPG file
    case JPG = "jpg"
    /// PLIST file
    case JSON = "json"
    /// PDF file
    case PDF = "pdf"
    /// PLIST file
    case PLIST = "plist"
    /// PNG file
    case PNG = "png"
    /// ZIP file
    case ZIP = "zip"
    /// mp4
    case MP4 = "mp4"
    /// Any file
    case Default = "file"
    
    /**
     Get representative image for file type
     
     - returns: UIImage for file type
     */
    
    public func image() -> UIImage {
        //let bundle =  Bundle(for: FileParser.self)
        var fileExtName: String
        switch self {
        case .Directory: fileExtName = "folder"
        case .JPG, .PNG, .GIF: fileExtName = "image"
        case .PDF: fileExtName = "pdf"
        case .ZIP: fileExtName = "zip"
        case .MP4: fileExtName = "image"
        default: fileExtName = "file"
        }
        let uiImage = UIImage(named: fileExtName, in: Bundle.module, compatibleWith: nil)
        return uiImage!
    }
}

/**
 Check if file path NSURL is directory or file.
 
 - parameter filePath: NSURL file path.
 
 - returns: isDirectory Bool.
 */
func checkDirectory(_ filePath: URL) -> Bool {
    var isDirectory = false
    do {
        var resourceValue: AnyObject?
        try (filePath as NSURL).getResourceValue(&resourceValue, forKey: URLResourceKey.isDirectoryKey)
        if let number = resourceValue as? NSNumber , number == true {
            isDirectory = true
        }
    }
    catch { }
    return isDirectory
}

func getFileAttributes(_ filePath: URL) -> NSDictionary? {
    let path = filePath.path
    let fileManager = FileParser.sharedInstance.fileManager
    do {
        let attributes = try fileManager.attributesOfItem(atPath: path) as NSDictionary
        return attributes
    } catch {}
    return nil
}


import class Foundation.Bundle
private class BundleFinder {}
extension Foundation.Bundle {
        /// Returns the resource bundle associated with the current Swift module.
        static var current: Bundle = {
                // This is your `target.path` (located in your `Package.swift`) by replacing all the `/` by the `_`.
                let bundleName = "FileBrowserSUITests"
                let candidates = [
                        // Bundle should be present here when the package is linked into an App.
                        Bundle.main.resourceURL,
                        // Bundle should be present here when the package is linked into a framework.
                        Bundle(for: BundleFinder.self).resourceURL,
                        // For command-line tools.
                        Bundle.main.bundleURL,
                ]
                for candidate in candidates {
                        let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
                        if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                                return bundle
                        }
                }
                
                return Bundle(for: BundleFinder.self)
        }()
}
