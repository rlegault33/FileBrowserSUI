import SwiftUI
import Foundation

@available(iOS 13.0.0, *)
public struct FileBrowserSUI<LinkView: View>: View {
 
    
    
    let linkView:(URL)->LinkView
    
    @State var fileList:[FBFile] = []
    internal var didAppear: ((Self) -> Void)?
    let validInitialPath: URL
    let extraInfo0: FileExtraInfo?
    let extraInfo1: FileExtraInfo?
    
    public var body: some View {
        HStack {
            List {
                ForEach(fileList, id: \.self) { file in
                    
                    NavigationLink(destination: FileLinkView(item:file) { filePath in
                        linkView(filePath)
                    }) {
                        HStack  {
                            HStack {
                                //Image(uiImage: file.type.image())
                                ThumbnailImageView(fbFile: file)
                                VStack {
                                    Text(file.displayName).font(.body).accessibility(identifier: "displayName")
                                    translateDateString(from: file.fileAttributes?.fileCreationDate() ?? Date()).font(.footnote)
                                }
                            }
                            Spacer()
                            if !file.isDirectory {
                                if #available(iOS 14.0, *) {
                                    ExtraInfoView(file:file)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                        }
                    }.navigationBarTitle(validInitialPath.lastPathComponent)
                }.onDelete( perform: deleteFile)
            }
        }.onAppear {
            let tmp =  FileParser.sharedInstance.filesForDirectory(validInitialPath, xInfo0: extraInfo0, xInfo1: extraInfo1)
            fileList.removeAll()
            fileList.append(contentsOf: tmp)
            self.didAppear?(self)
        }

        
    }
    public init(initialPath: URL?, xInfo0:FileExtraInfo?, xInfo1: FileExtraInfo?, @ViewBuilder linkView: @escaping (URL)->LinkView) {
        validInitialPath = initialPath ?? FileParser.sharedInstance.documentsURL()
        extraInfo0 = xInfo0
        extraInfo1 = xInfo1
        self.linkView = linkView
    }
    public init(@ViewBuilder linkView: @escaping (URL)->LinkView) {
        validInitialPath = FileParser.sharedInstance.documentsURL()
        extraInfo0 = nil
        extraInfo1 = nil
        self.linkView = linkView
    }
    
    
    func deleteFile(at offsets: IndexSet) {
        offsets.forEach({index in
            if let exInfo = fileList[index].fileExInfo0 {
                let _ = exInfo.delete(fileList[index].filePath)
            } else if let exInfo = fileList[index].fileExInfo0 {
                let _ = exInfo.delete(fileList[index].filePath)
            }
           fileList[index].delete()
           fileList.remove(at: index)
        })
    }
    
    func translateDateString(from:Date) -> Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        return Text(dateFormatter.string(from: from))
    }
    
    func handleFilePress (selected:FBFile) {
        if selected.isDirectory {
            
        }
    }
    

}

var extraInfo0: FileExtraInfo?
var extraInfo1: FileExtraInfo?
func previewInit() {
    func getList(url:URL) ->[String] {
        return ["Test", "1", "2"]
    }
    extraInfo0 = FileExtraInfo(
                               get: {_ in
                                return 0
                               }, list: getList, set: {file, value in
                                return
                               }, delete: {_ in
                                return
                               })
    extraInfo0 = FileExtraInfo(
                               get: {_ in
                                return 0
                               }, list: getList, set: {file, value in
                                return
                               }, delete: {_ in
                                return
                               })
}

//struct FileBrowserSUI_Previews: PreviewProvider {
//    static var previews: some View {
//        let paths = NSSearchPathForDirectoriesInDomains(
//                        FileManager.SearchPathDirectory.applicationSupportDirectory,
//            .userDomainMask, true).first
//        return FileBrowserSUI(initialPath: URL(string: paths!)!, xInfo0: extraInfo0, xInfo1: extraInfo1 )
//    }
//
//    init() {
//        previewInit()
//    }
//}








