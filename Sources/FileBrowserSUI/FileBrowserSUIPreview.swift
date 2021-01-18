//
//  File.swift
//  
//
//  Created by Richard Legault on 2021-01-17.
//

import Foundation
import SwiftUI

public struct FileBrowserSUIPreview: View {
    @State var fileList:[FBFile] = []
    internal var didAppear: ((Self) -> Void)?
    let validInitialPath: URL
    let extraInfo0: FileExtraInfo?
    let extraInfo1: FileExtraInfo?
    
    public var body: some View {
        FileBrowserSUI(initialPath: validInitialPath,
                       xInfo0: extraInfo0, xInfo1: extraInfo1) {
            fileUrl in
               PreviewController(url: fileUrl)
        }
    }
    
    public init(initialPath: URL?, xInfo0:FileExtraInfo?, xInfo1: FileExtraInfo?) {
        validInitialPath = initialPath ?? FileParser.sharedInstance.documentsURL()
        extraInfo0 = xInfo0
        extraInfo1 = xInfo1
        
    }
    public init() {
        validInitialPath = FileParser.sharedInstance.documentsURL()
        extraInfo0 = nil
        extraInfo1 = nil
       
    }
}
