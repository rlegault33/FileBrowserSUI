# FileBrowserSUI
![FileBrowserSUI - iOS File Finder Swift Package in SwiftUI](https://raw.github.com/rlegault33/FileBrowserSUI/main/README.assets/FileBrowserSUI_Title.png)

The failing tag is incorrect, until SPM Testing is able to access Resource files the CI tests will continue to fail.</br>
![Swift](https://github.com/rlegault33/FileBrowserSUI/workflows/Swift/badge.svg?branch=main)
<!--[![Build Status](https://travis-ci.com/rlegault33/FileBrowserSUI.svg?branch=main)](https://travis-ci.com/rlegault33/FileBrowserSUI) -->
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/rlegault33/FileBrowserSUI)

![GitHub](https://img.shields.io/github/license/rlegault33/FileBrowserSUI)

[![swift-version](https://img.shields.io/badge/swift-5.3-brightgreen.svg)](https://github.com/apple/swift)
[![swiftui-version](https://img.shields.io/badge/swiftui-2.0-brightgreen)](https://developer.apple.com/documentation/swiftui)
[![xcode-version](https://img.shields.io/badge/xcode-12.3-brightgreen)](https://developer.apple.com/xcode/)



# File Browser SUI
iOS File Browser supporting Swift Packages. Use the default View or create your own and pass it on init to handle file selection. You can specify the starting path and include or exclude file types.

:flags: |  Features
--------------------------|----------------------------
:iphone: | Browse and select files and folders with a familiar UI on iOS.
:eyeglasses: | Quickview most file types.
:pencil: | Edit/delete files.
:gear: | Fully customizable.
:ballot_box_with_check: | Each file has the option to allow the develop to specify text descriptors that the user can select from, from a drop down menu
:mag: | Thumbnail image for MP4 files

## Usage
XCODE Select Project</br>
File->Swift Package->Add Package Dependancy</br>
Copy the following link into Choose Package Repository Search Field</br>
[http://github.com/rlegault33/FileBrowserSUI](http://github.com/rlegault33/FileBrowserSUI)

## Specify a file view
You can create your own File handler view that you pass into the FileBrowserSUI on creation. When the user selects a file it will use the view you specify. The view must have a URL variable that will contain the URL of the selected file.

```swift
struct AppFileSelectedView: View {
    let url: URL
    var body: some View {
        Text("Show File \(url.lastPathComponent)")
    }
}
```

Pass View to the package on init by adding a closure to the init call. 
```swift
NavigationView {
    FileBrowserSUI(initialPath: initPath) { value in
        AppFileSelectedView(url:value)
    }
}
```




If you do not supply a view enclosure then you must instantiate the FileBrowserSUI with FileBroswerSUIPreview like so.

Usage Example:
```swift
NavigationView {
    FileBrowserSUIPreview(initialPath: initPath,
                       xInfo0: FileExtraInfo(get: fileMapInfo.get0, list: fileMapInfo.list0, set: fileMapInfo.set0, delete: fileMapInfo.delete),
                       xInfo1: FileExtraInfo(get: fileMapInfo.get1, list: fileMapInfo.list1, set: fileMapInfo.set1, delete: fileMapInfo.delete))
}
```
### IMPORTANT
You must make sure that FileBrowserSUI* is inside a NavigationView for the NavigationLinks to work.

### FUTURE:
If no closure is provided it will use the iOS Quickview functionality. (Still trying to figure this out.)

## Descriptor text
For each check mark you must provide a instance of **FileExtraInfo** that you supply 
* get(URL) -> Int  // Index into list array that is currently selected, if value is out of range then it will default to 0
* list(URL) -> [String]
* set(URL, Int) -> Void
* delete(URL) -> Void
 
It is the developer responsiblity to store the information by its URL as required by your app and supply it via the get() and update it via the set() and delete it from your storage.

See the xcode project **Example_FileBrowser_SUI** in the FileBrowserSUI package for the full example code.


![FileBrowserSUI - screen shot](https://raw.github.com/rlegault33/FileBrowserSUI/main/README.assets/FileBrowserSUI_Shot_5.0.0.png)

