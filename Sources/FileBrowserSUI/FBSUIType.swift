//
//  File.swift
//  
//
//  Created by Richard Legault on 2020-12-19.
//

import Foundation
import UIKit
import QuickLookThumbnailing
public enum TitleMarkId: Int, CaseIterable {
    case TITLE1 = 0
    case TITLE2 = 1
    var idx: Int {
        switch self {
        case .TITLE1:
            return TitleMarkId.TITLE1.rawValue
        case .TITLE2:
            return TitleMarkId.TITLE1.rawValue
        }
    }
}

typealias FileExtraInfoGet = (URL) -> Bool
typealias FileExtraInfoSet = (URL, Bool) -> Void

struct FileExtraInfo: Identifiable {
    var id = UUID()
    var title: String
    var get: FileExtraInfoGet
    var set: FileExtraInfoSet
}

/// FBFile is a class representing a file in FileBrowser
class FBFile: Identifiable {
    /// Display name. String.
    let id = UUID()
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
    
    // stores ability to get/set store bool info about the file
    // 2 Bool values
    var fileExInfo: [FileExtraInfo] = []

    
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
    init(filePath: URL) {
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
    }

    func addTitle(titleMarkId: TitleMarkId, title:String, set:@escaping FileExtraInfoSet, get:@escaping FileExtraInfoGet) {
        if fileExInfo.isEmpty {
            fileExInfo.append(FileExtraInfo(title: title, get: get, set: set))
        }

        else if fileExInfo.count == 1 {
            fileExInfo.insert(FileExtraInfo(title: title, get: get, set: set), at: titleMarkId.idx)
        } else {
            fileExInfo[titleMarkId.idx] = FileExtraInfo(title: title, get: get, set: set)
        }
    }
    
    func getExInfo(titleMarkId: TitleMarkId) -> Bool {
        if (titleMarkId.idx >= fileExInfo.count) {
            return false
        }
        return fileExInfo[titleMarkId.idx].get(filePath.standardizedFileURL)
    }
    
    func setExInfo(titleMarkId: TitleMarkId, value: Bool) {
        if (titleMarkId.idx < fileExInfo.count) {
            fileExInfo[titleMarkId.idx].set(filePath.standardizedFileURL, value)
        }
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
        let uiImage = UIImage(named: fileExtName, in: .module, compatibleWith: nil)
        return uiImage!
    }
    
    func generateImage(fileName:URL, completion: @escaping(UIImage?)->Void) {
        
        if self != .MP4 {
            completion(self.image())
            return
        }
        // Create a thumbnail for MP4 files
        if #available(iOS 13.0, *) {
            let size = CGSize(width: 60, height: 90)
            let scale = UIScreen.main.scale
            
            let request = QLThumbnailGenerator.Request(
                fileAt: fileName,
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
        } else {
            completion(self.image())
        }
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

