//
//  SwiftUIView.swift
//  
//
//  Created by Richard Legault on 2021-03-28.
//

import SwiftUI

@available(iOS 14.0, *)
struct DropDownDescriptionView: View {
    @State private var idx: Int
    var fileExtraInfo: FileExtraInfo
    var fileUrl : URL
    
    init(idx test: Int,  fileExtraInfo: FileExtraInfo,  fileUrl: URL) {
        
        self.fileExtraInfo = fileExtraInfo
        self.fileUrl = fileUrl
        let i = DropDownDescriptionView.testIdx(test: test, list: fileExtraInfo.list(fileUrl) )
        _idx = State(initialValue: i)
    }
    var body: some View {
        VStack() {
            VStack() {
                let list = fileExtraInfo.list(fileUrl)
                Text(list[idx]).fontWeight(.bold).foregroundColor(.black)
                Picker(fileExtraInfo.dropDownTitle, selection: $idx) {
                    ForEach(list.indices, id: \.self){ (index: Int) in
                        Text(list[index])
                    }
                }.pickerStyle(MenuPickerStyle())
                .onChange(of: idx, perform: { value in
                    print("\(fileUrl.lastPathComponent) value=\(value)")
                    fileExtraInfo.set(fileUrl, value)
                })
            }
        }
    }
    static func testIdx (test:Int, list: [String]) -> Int {
        return test < 0 || test >= list.count ? 0 : test;
    }
}

@available(iOS 14.0, *)
struct DropDownDescriptionView_Previews: PreviewProvider {
    static private var testValue = 0
    static func testget(file _: URL)->Int {
        return testValue
    }
    static func testset(file _: URL, value: Int) {
        testValue = value
    }

    static func testlist(file _: URL)->[String] {
        return ["0", "1", "2", "3"]
    }
    static func testdelete(file _: URL) {
        return
    }
    static var previews: some View {
        let fileExtraInfo = FileExtraInfo(dropDownTitle: "test1", get: testget, list: testlist, set: testset, delete: testdelete)
        DropDownDescriptionView(idx: testValue, fileExtraInfo: fileExtraInfo, fileUrl: URL(string: "test")!)
    }
}

