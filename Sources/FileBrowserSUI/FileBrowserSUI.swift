import SwiftUI
import Foundation

@available(iOS 13.0.0, *)
public struct FileBrowserSUI: View {
    var fileList: [FBFile] = []
    public var body: some View {
        FileListView(fileList: fileList)
    }
    public init(initialPath: URL?) {
        let validInitialPath = initialPath ?? FileParser.sharedInstance.documentsURL()
        fileList = FileParser.sharedInstance.filesForDirectory(validInitialPath)
    }
    public init() {
        fileList = FileParser.sharedInstance.filesForDirectory(FileParser.sharedInstance.documentsURL())
    }
}
