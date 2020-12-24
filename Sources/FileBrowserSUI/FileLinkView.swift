//
//  SwiftUIView.swift
//  
//
//  Created by Richard Legault on 2020-12-23.
//

import SwiftUI

struct FileLinkView: View {
    var item:FBFile
    var body: some View {
        if (item.isDirectory) {
            FileBrowserSUI(initialPath: item.filePath, xInfo0: item.fileExInfo0, xInfo1: item.fileExInfo1)
        } else {
            PreviewController(url:item.filePath)
        }
        
    }
}



let file=FBFile(filePath: URL(string:"TEST URL")!, xInfo0: nil, xInfo1: nil)
struct FileLinkView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        FileLinkView(item: file)
    }
}
