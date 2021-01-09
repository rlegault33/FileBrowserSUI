import SwiftUI
import Foundation

@available(iOS 13.0.0, *)

public struct FileBrowserGeneric: View {
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


public struct ThumbnailImageView: View {
    let fbFile: FBFile

    @State private var thumbnail: UIImage? = nil
    
    public var body: some View {

        if thumbnail != nil {
            Image(uiImage: self.thumbnail!)
        } else {
            Image(uiImage: fbFile.type.image()).onAppear() {
                self.fbFile.generateImage() { image in
                        self.thumbnail = image
                    print("thumbnail for \(self.fbFile.displayName)")
                }
            }
        }
    }
}

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
                                extraInfoView(file:file)
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

struct extraInfoView: View {
    @ObservedObject var file: FBFile

    var body: some View {
        HStack {
            if let exInfo = file.fileExInfo0 {
                HStack {
                    Text(exInfo.title)
                    Image(systemName: file.fileExInfo0Value ? "checkmark.square" : "square"
                    ).onTapGesture {
                        file.fileExInfo0Value.toggle()
                    }.accessibility(identifier: "ExInfo0Select")
                }
            }
            if let exInfo = file.fileExInfo1 {
                HStack {
                    Text(exInfo.title)
                    Image(systemName: file.fileExInfo1Value ? "checkmark.square" : "square"
                    )
                    .onTapGesture {
                        file.fileExInfo1Value.toggle()
                    }
                    .accessibility(identifier: "ExInfo1Select")
                }
                
            }
        }
    }
}
