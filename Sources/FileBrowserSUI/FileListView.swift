//
//  SwiftUIView.swift
//  
//
//  Created by Richard Legault on 2020-12-19.
//
import Foundation
import SwiftUI

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
                    if !file.isDirectory {
                        Spacer()
                        extraInfoView1(file:file)
                    }
                }
            }.buttonStyle(BorderlessButtonStyle())
        }
    }
    
    init (fileList: [FBFile]) {
        self.fileList = fileList
    }
    
    func translateDateString(from:Date) -> Text {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        return Text(dateFormatter.string(from: from))
    }
    
}



struct extraInfoView1: View {
    @ObservedObject var file: FBFile

    var body: some View {
        HStack {
            if let exInfo = file.fileExInfo0 {
                HStack {
                    Text(exInfo.title)
                    Image(systemName: file.fileExInfo0Value ? "checkmark.square" : "square").onTapGesture {
                        file.fileExInfo0Value.toggle()
                    }
                }
            }
            if let exInfo = file.fileExInfo1 {
                HStack {
                    Text(exInfo.title)
                    Image(systemName: file.fileExInfo1Value ? "checkmark.square" : "square").onTapGesture {
                        file.fileExInfo1Value.toggle()
                    }
                }
                
            }
        }
    }
}





@available(iOS 13.0, *)
struct SwiftUIView_Previews: PreviewProvider {

    static var previews: some View {
        let fileList = FileParser.sharedInstance.filesForDirectory(FileParser.sharedInstance.documentsURL(), xInfo0: nil, xInfo1: nil)
        FileListView(fileList: fileList)
    }
    
    init() {
        
    }
}
