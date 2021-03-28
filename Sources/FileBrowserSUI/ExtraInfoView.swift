//
//  SwiftUIView.swift
//  
//
//  Created by Richard Legault on 2021-03-28.
//

import SwiftUI

@available(iOS 14.0, *)
struct ExtraInfoView: View {
    @ObservedObject var file: FBFile
    @State private var pickerVisible0 = false
    @State private var pickerVisible1 = false
    @State private var selection0 = 0
    @State private var selection1 = 0
    @State var list0 = []
    @State var list1 = []
    var body: some View {
        HStack(alignment:.bottom) {
            if let exInfo = file.fileExInfo0 {
                HStack {
                    DropDownDescriptionView(idx: exInfo.get(file.filePath), fileExtraInfo: exInfo, fileUrl: file.filePath)
                }
            }
            if let exInfo = file.fileExInfo1 {
                HStack {
                    DropDownDescriptionView(idx: exInfo.get(file.filePath), fileExtraInfo: exInfo, fileUrl: file.filePath)
                }
            }
        }
    }
}
