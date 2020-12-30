//
//  Example_FileBrowserSUIApp.swift
//  Example_FileBrowserSUI
//
//  Created by Richard Legault on 2020-12-29.
//

import SwiftUI

let fileDataMap = MapExFileInfo()

@main
struct Example_FileBrowserSUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(initPath: FileManager.default.getDocumentsDirectory(), fileMapInfo: fileDataMap)
            ContentViewFBSUI_QuickView(initPath: FileManager.default.getDocumentsDirectory(), fileMapInfo: fileDataMap)
        }
    }
    
    init() {

        for dest:String in ["Images.zip", "Baymax.jpg", "BB8.jpg", "Stitch.jpg", "cameraStreams/__201220/hl_P1_M00S00_D15.mp4", "cameraStreams/__201220/hl_P1_M00S00_D15-0.mp4"] {
            let src:String = dest.split(separator: "/").last.map{String($0)}!
    
            copyFileToDocumentsFolder(nameForFile: src, extForFile: "", destForFile: dest)
        }
    }
    
    func copyFileToDocumentsFolder(nameForFile: String, extForFile: String, destForFile: String) {

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent(destForFile).appendingPathExtension(extForFile)
        guard let sourceURL = Bundle.main.url(forResource: nameForFile, withExtension: extForFile)
            else {
                print("Source File not found.")
                return
        }
            let fileManager = FileManager.default
        
            let _ = fileManager.createDirectoryIfNecessary(subdirectory: destURL.deletingLastPathComponent())

            do {
                try fileManager.copyItem(at: sourceURL, to: destURL)
            } catch {
                print("Unable to copy file \(error.localizedDescription)")
            }
    }
}
