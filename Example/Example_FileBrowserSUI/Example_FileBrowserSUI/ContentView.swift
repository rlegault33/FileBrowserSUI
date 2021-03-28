//
//  ContentView.swift
//  Example_FileBrowserSUI
//
//  Created by Richard Legault on 2020-12-29.
//

import SwiftUI
import FileBrowserSUI

// Pass in a view that will handle the file selection.
struct AppFileSelectedView: View {
    let url: URL
    var body: some View {
        Text("Show File \(url.lastPathComponent)")
    }
}

// This is an example of the application specifying the view to use
// when the fie is selected.

struct ContentView : View {
    @State var showSheet = false
    //let fileSelectedView: (URL)->FileSelectedView
    
    var initPath: URL
    var fileMapInfo: MapExFileInfo
    var body: some View {
        VStack {
            Text("Use App Supplied File View").padding([.top, .leading, .trailing])
            Button(action: {
                showSheet.toggle()
            }, label: {
                Text("Browse Files")
            }).padding(.bottom)
        }.border(Color.red, width:4)
        .sheet(isPresented: $showSheet, content: {
            
            NavigationView{
                FileBrowserSUI(initialPath: initPath,
                               xInfo0: FileExtraInfo(get: fileMapInfo.get0, list: fileMapInfo.getList0, set: fileMapInfo.set0, delete: fileMapInfo.delete),
                               xInfo1: FileExtraInfo(get: fileMapInfo.get1, list: fileMapInfo.getListA, set: fileMapInfo.set1, delete: fileMapInfo.delete))
                {
                 value in
                        AppFileSelectedView(url:value)
                }.navigationBarTitle(initPath.lastPathComponent)
            }
                
        })
    }
}

// This is an example of using the FileBrowserGeneric View, the
// FileBrowser uses its built in QuickView when file selected.
struct ContentViewFBSUI_QuickView : View {
    @State var showSheet = false
    //let fileSelectedView: (URL)->FileSelectedView
    
    var initPath: URL
    var fileMapInfo: MapExFileInfo
    var body: some View {
        VStack {
            Text("Use QuickView supplied by Package").padding([.top, .leading, .trailing])
            Button(action: {
                showSheet.toggle()
            }, label: {
                Text("Browse Files")
            }).padding(.bottom)
        }.border(Color.red, width: 4)
        .sheet(isPresented: $showSheet, content: {
            
            NavigationView{
                FileBrowserSUIPreview(
                    initialPath: initPath,
                    xInfo0: FileExtraInfo(
                        get: fileMapInfo.get0,
                        list: fileMapInfo.getList0,
                        set: fileMapInfo.set0,
                        delete: fileMapInfo.delete),
                    xInfo1: FileExtraInfo(
                        get: fileMapInfo.get1,
                        list: fileMapInfo.getListA,
                        set: fileMapInfo.set1,
                        delete: fileMapInfo.delete))
                .navigationBarTitle(initPath.lastPathComponent)
            }
                
        })
    }
}

func handleFile(file:FBFile) {
    print("Handler got file \(file.displayName)")
}

var  mapInfo: MapExFileInfo? = MapExFileInfo()
fileprivate func previewInit() {
    mapInfo = MapExFileInfo()
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(initPath: FileManager.default.getDocumentsDirectory().appendingPathComponent("cameraStreams/__201220"), fileMapInfo: mapInfo!)
    }
    init() {
        previewInit()
    }
    
}
