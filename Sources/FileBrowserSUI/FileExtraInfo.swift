//
//  FileExtraInfo.swift
//  rtmpCameraWolf
//
//  Created by Richard Legault on 2021-03-28.
//

import Foundation

public typealias FileExtraInfoDelete = (URL) -> Void
public typealias FileExtraInfoGet = (URL) -> Int
// Int is the index of the [String] that is selected in FileExtraInfoList
public typealias FileExtraInfoSet = (URL, Int) -> Void
public typealias FileExtraInfoList = (URL) -> [String]


public struct  FileExtraInfo {
    public let get: FileExtraInfoGet
    public let set: FileExtraInfoSet
    public let list: FileExtraInfoList
    public let delete: FileExtraInfoDelete
    public let dropDownTitle: String
    
    public init(dropDownTitle: String, get: @escaping FileExtraInfoGet, list: @escaping FileExtraInfoList, set: @escaping FileExtraInfoSet, delete: @escaping FileExtraInfoDelete) {
        self.dropDownTitle = dropDownTitle
        self.get = get
        self.list = list // drop down select list
        self.set = set
        self.delete = delete
    }
}
