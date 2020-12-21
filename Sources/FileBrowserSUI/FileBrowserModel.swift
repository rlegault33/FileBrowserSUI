//
//  File.swift
//  
//
//  Created by Richard Legault on 2020-12-20.
//

import Foundation

class FileBrowserModel {
    private let parser = FileParser.sharedInstance
    
    public convenience init(initialPath: URL? = nil, allowEditing: Bool = false, showCancelButton: Bool = true){
        _ = initialPath ?? FileParser.sharedInstance.documentsURL()
        self.init()
        
        
    }
    
}
