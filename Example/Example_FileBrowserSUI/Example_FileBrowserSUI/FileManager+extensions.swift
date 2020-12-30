//
//  FileManager+extensions.swift
//  benchReplay
//
//  Created by Richard Legault on 2020-09-13.
//  Copyright © 2020 Richard Legault. All rights reserved.
//

import Foundation

/// A wrapper around a temporary file in a temporary directory. The directory
/// has been especially created for the file, so it's safe to delete when you're
/// done working with the file.
///
/// Call `deleteDirectory` when you no longer need the file.
struct TemporaryFile {
    let directoryURL: URL
    let fileURL: URL
    /// Deletes the temporary directory and all files in it.
    let deleteDirectory: () throws -> Void

    /// Creates a temporary directory with a unique name and initializes the
    /// receiver with a `fileURL` representing a file named `filename` in that
    /// directory.
    ///
    /// - Note: This doesn't create the file!
    init(creatingTempDirectoryForFilename filename: String) throws {
        let (directory, deleteDirectory) = try FileManager.default
            .urlForUniqueTemporaryDirectory()
        self.directoryURL = directory
        self.fileURL = directory.appendingPathComponent(filename)
        self.deleteDirectory = deleteDirectory
    }
}

extension FileManager {
    /// Creates a temporary directory with a unique name and returns its URL.
    ///
    /// - Returns: A tuple of the directory's URL and a delete function.
    ///   Call the function to delete the directory after you're done with it.
    ///
    /// - Note: You should not rely on the existence of the temporary directory
    ///   after the app is exited.
    func urlForUniqueTemporaryDirectory(preferredName: String? = nil) throws
        -> (url: URL, deleteDirectory: () throws -> Void)
    {
        let basename = preferredName ?? UUID().uuidString

        var counter = 0
        var createdSubdirectory: URL? = nil
        repeat {
            do {
                let subdirName = counter == 0 ? basename : "\(basename)-\(counter)"
                let subdirectory = temporaryDirectory
                    .appendingPathComponent(subdirName, isDirectory: true)
                try createDirectory(at: subdirectory, withIntermediateDirectories: true)
                createdSubdirectory = subdirectory
            } catch CocoaError.fileWriteFileExists {
                // Catch file exists error and try again with another name.
                // Other errors propagate to the caller.
                counter += 1
            }
        } while createdSubdirectory == nil

        let directory = createdSubdirectory!
        let deleteDirectory: () throws -> Void = {
            try self.removeItem(at: directory)
        }
        return (directory, deleteDirectory)
    }
    
    func getModifiedVideoSortedUrls(at directoryURL: URL, direction: ComparisonResult = ComparisonResult.orderedDescending ) -> [URL?] {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys:[.contentModificationDateKey], options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
                .filter {
                    $0.lastPathComponent.hasSuffix(".avi") ||
                        $0.lastPathComponent.hasSuffix(".mp4")
                }.sorted(by: {
                   let date0 = try $0.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
                   let date1 = try $1.promisedItemResourceValues(forKeys:[.contentModificationDateKey]).contentModificationDate!
                   return date0.compare(date1) == direction
                })
            print(directoryContents)
            return directoryContents
        } catch {
            print(error)
            return [nil]
        }
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func createDirectoryIfNecessary(subdirectory: URL) -> URL? {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: subdirectory.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                return subdirectory
            }
            do {
                // Not a directory, delete file
                try FileManager.default.removeItem(atPath: subdirectory.path)
            } catch {
                print("\(#function):\(#line)")
                print(error)
                return nil
            }
        }

        do {
            try FileManager.default.createDirectory(at: subdirectory, withIntermediateDirectories: true)
        } catch {
            print("\(#function):\(#line)")
            print (error)
            return nil
        }
        return subdirectory
    }
    
    // If the app doc directory does not exist, create it. Return URL to the directory
    func getAppDocDirectory() -> URL? {
        let subdirName = ""
        let subdirectory = FileManager.default.getDocumentsDirectory().appendingPathComponent(subdirName, isDirectory: true)
        return createDirectoryIfNecessary(subdirectory: subdirectory)
        
        
    }
}
