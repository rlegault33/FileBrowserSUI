import SwiftUI
import Foundation

@available(iOS 13.0.0, *)
public struct FileBrowserSUI: View {
    var fileList: [FBFile] = []
    var extraInfo0: FileExtraInfo?
    var extraInfo1: FileExtraInfo?
    
    public var body: some View {
        FileListView(fileList: fileList)
    }
    public init(initialPath: URL?, xInfo0:FileExtraInfo?, xInfo1: FileExtraInfo?) {
        let validInitialPath = initialPath ?? FileParser.sharedInstance.documentsURL()
        fileList = FileParser.sharedInstance.filesForDirectory(validInitialPath, xInfo0: xInfo0, xInfo1: xInfo1)
    }
    public init() {
        fileList = FileParser.sharedInstance.filesForDirectory(FileParser.sharedInstance.documentsURL(), xInfo0: nil, xInfo1: nil)
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
                               })
    extraInfo0 = FileExtraInfo(title: "test0",
                               get: {_ in
                                return false
                               }, set: {file, value in
                                return
                               })
}

@available(iOS 13.0, *)
struct FileBrowserSUI_Previews: PreviewProvider {
    static var previews: some View {
        let paths = NSSearchPathForDirectoriesInDomains(
                        FileManager.SearchPathDirectory.applicationSupportDirectory,
            .userDomainMask, true).first
        return FileBrowserSUI(initialPath: URL(string:paths!), xInfo0: extraInfo0, xInfo1: extraInfo1 )
    }
    
    init() {
        previewInit()
    }
}

