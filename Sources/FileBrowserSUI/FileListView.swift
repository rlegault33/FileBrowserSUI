//
//  SwiftUIView.swift
//  
//
//  Created by Richard Legault on 2020-12-19.
//
import Foundation
import SwiftUI

struct FileListView: View {
    @State var fileList:[FBFile] = []
    let validInitialPath: URL
    let xInfo0: FileExtraInfo?
    let xInfo1: FileExtraInfo?
    var body: some View {
        HStack {
            List {
                ForEach(fileList, id: \.self) { file in
                    HStack {
                        Image(uiImage: file.type.image())
                        VStack {
                            Text(file.displayName).font(.body)
                            translateDateString(from: file.fileAttributes?.fileCreationDate() ?? Date()).font(.footnote)
                        }.onTapGesture {
                            print("Tap")
                            
                        }
                        if !file.isDirectory {
                            Spacer()
                            extraInfoView1(file:file)
                        }
                    }
                }.onDelete( perform: deleteFile)
                    
                
            }
        }.onAppear() {
            let tmp =  FileParser.sharedInstance.filesForDirectory(validInitialPath, xInfo0: xInfo0, xInfo1: xInfo1)
            fileList.append(contentsOf: tmp)
        }
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
        FileListView(validInitialPath: FileParser.sharedInstance.documentsURL(), xInfo0: nil, xInfo1: nil)
    }
}
