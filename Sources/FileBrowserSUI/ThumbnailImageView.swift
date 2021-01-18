//
//  ThumbnailImageView.swift
//  
//
//  Created by Richard Legault on 2021-01-17.
//

import SwiftUI

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
                }
            }
        }
    }
}

//struct ThumbnailImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        //ThumbnailImageView(fbFile: <#FBFile#>)
//    }
//}

