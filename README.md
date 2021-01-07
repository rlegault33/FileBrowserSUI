# FileBrowserSUI
![FileBrowserSUI - iOS File Finder Swift Package in SwiftUI](https://raw.github.com/rlegault33/FileBrowserSUI/main/README.assets/FileBrowserSUI_Title.png)

[![Build Status](https://travis-ci.com/rlegault33/FileBrowserSUI.svg?branch=main)](https://travis-ci.com/rlegault33/FileBrowserSUI) 
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/rlegault33/FileBrowserSUI)

![GitHub](https://img.shields.io/github/license/rlegault33/FileBrowserSUI)

[![swift-version](https://img.shields.io/badge/swift-5.3-brightgreen.svg)](https://github.com/apple/swift)
[![swiftui-version](https://img.shields.io/badge/swiftui-2.0-brightgreen)](https://developer.apple.com/documentation/swiftui)
[![xcode-version](https://img.shields.io/badge/xcode-12.3-brightgreen)](https://developer.apple.com/xcode/)



# File Browser SUI
iOS File Browser supporting Swift Packages. Use the default View or create your own and pass it on init to handle file selection. You can specify the starting path and include or exclude file types.

:can:                |  Features
--------------------------|----------------------------
:iphone: | Browse and select files and folders with a familiar UI on iOS.
:eyeglasses: | Quickview most file types.
:pencil: | Edit/delete files.
:gear: | Fully customizable.
:ballot_box_with_check: | Each file has the option to allow the user to flag files via (up to 2) check boxes.

## Usage
XCODE Select Project</br>
File->Swift Package->Add Package Dependancy</br>
Copy the following link into Choose Package Repository Search Field</br>
[http://github.com/rlegault33/FileBrowserSUI](http://github.com/rlegault33/FileBrowserSUI)

## Specify a file view
You can create your own File handler view that you pass into the FileBrowserSUI on creation. When the user selects a file ti will use the view you specify. The view must have a variable url:URL that will contain the URL of the selected file.

```swift
struct AppFileSelectedView: View {
    let url: URL
    var body: some View {
        Text("Show File \(url.lastPathComponent)")
    }
}
```

Pass View to the package on init by adding a closure to the init call. If no closure is provided it will use the iOS Quickview functionality
```swift
FileBrowserSUI(initialPath: initPath) { value in
    AppFileSelectedView(url:value)
}
```

## Check mark 
For each check mark you must provide a instance of **FileExtraInfo** that you supply 
* title: String
* set(URL, Bool) -> Void
* get(URL) -> Bool
* delete(URL) -> Bool 
 
It is your responsiblity to store the information by its URL as required by your app and supply it via the get() and update it via the set() and delete it from your storage.

Usage Example:
```swift
FileBrowserGeneric(initialPath: initPath,
                   xInfo0: FileExtraInfo(title: "Offense", get: fileMapInfo.get0, set: fileMapInfo.set0, delete: fileMapInfo.delete),
                   xInfo1: FileExtraInfo(title: "Defense", get: fileMapInfo.get1, set: fileMapInfo.set1, delete: fileMapInfo.delete))
```

See the xcode project **Example_FileBrowser_SUI** in the FileBrowserSUI package for the full code.


![FileBrowserSUI - screen shot](https://raw.github.com/rlegault33/FileBrowserSUI/main/README.assets/FileBrowserSUI_Shot1.png)

