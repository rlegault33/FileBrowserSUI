//
//  SwiftUIView.swift
//  
//
//  Created by Richard Legault on 2020-12-19.
//
import Foundation
import SwiftUI




@available(iOS 13.0, *)
struct FileListView: View {
    public var fileList: [FBFile] = []
    var body: some View {
        HStack {
            List(fileList) { file in
                HStack {
                    Image(uiImage: file.type.image())
                    VStack {
                        Text(file.displayName).font(.body)
                        translateDateString(from: file.fileAttributes?.fileCreationDate() ?? Date()).font(.footnote)
                    }
                    Spacer()
                    extraInfoView(file:file)
                }
            }
        }
    }
    
    init (fileList: [FBFile]) {
        self.fileList = fileList
    }
    @available(iOS 13.0, *)
    func translateDateString(from:Date) -> Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        return Text(dateFormatter.string(from: from))
    }
    
}

@available(iOS 13.0, *)
struct extraInfoView: View {
    let file: FBFile
    
    var body: some View {
        HStack {
            ForEach(file.fileExInfo) { exInfo in
                HStack {
                    Text(exInfo.title)
                    Button(action: {
                        var markBool = exInfo.get(file.filePath)
                        markBool.toggle()
                        exInfo.set(file.filePath, markBool)
                    }) {
                        Image(systemName: exInfo.get(file.filePath) ? "checkmark.square" : "square")
                    }
                }
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    @available(iOS 13.0, *)
    static var previews: some View {
        let fileList = FileParser.sharedInstance.filesForDirectory(FileParser.sharedInstance.documentsURL())
        FileListView(fileList: fileList)
    }
    
    init() {
        
    }
}
