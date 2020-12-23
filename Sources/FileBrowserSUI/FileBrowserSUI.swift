import SwiftUI
import Foundation

@available(iOS 13.0.0, *)
public struct FileBrowserSUI: View {
    let validInitialPath: URL
    let extraInfo0: FileExtraInfo?
    let extraInfo1: FileExtraInfo?
    
    public var body: some View {
        FileListView(validInitialPath: validInitialPath, xInfo0: extraInfo0, xInfo1: extraInfo1)
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

var extraInfo0: FileExtraInfo?
var extraInfo1: FileExtraInfo?
func previewInit() {
    extraInfo0 = FileExtraInfo(title: "test0",
                               get: {_ in
                                return true
                               }, set: {file, value in
                                return
                               }, delete: {_ in
                                return true
                               })
    extraInfo0 = FileExtraInfo(title: "test0",
                               get: {_ in
                                return false
                               }, set: {file, value in
                                return
                               }, delete: {_ in
                                return true
                               })
}

@available(iOS 13.0, *)
struct FileBrowserSUI_Previews: PreviewProvider {
    static var previews: some View {
        let paths = NSSearchPathForDirectoriesInDomains(
                        FileManager.SearchPathDirectory.applicationSupportDirectory,
            .userDomainMask, true).first
        return FileBrowserSUI(initialPath: URL(string: paths!)!, xInfo0: extraInfo0, xInfo1: extraInfo1 )
    }
    
    init() {
        previewInit()
    }
}

