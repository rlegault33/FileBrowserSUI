import XCTest
import ViewInspector

@testable import FileBrowserSUI

extension FileLinkView: Inspectable {}
extension PreviewController: Inspectable {}
extension FileBrowserSUI: Inspectable {}

final class FileLinkViewTests: XCTestCase {

    static var allTests = [
        ("testListPreviewFile", testListPreviewFile),
        ("testListFileBrowserSUI", testListFileBrowserSUI),
        ("testFileBrowserSUIView_NoAccessors", testFileBrowserSUIView_NoAccessors),
        ("testFileBrowserSUIView_Accessors", testFileBrowserSUIView_Accessors)
        
    ]

    
    func testListPreviewFile() {
        let bundlePath = getBundleTestRoot()
        let resourceFile = bundlePath.appendingPathComponent("Baymax.jpg")
        let item = FBFile(filePath: resourceFile, xInfo0: nil, xInfo1: nil)
        //let fileList = getBundleFileList()
        
        let view = FileLinkView(item:item)
        XCTAssertNoThrow( try view.inspect().view(PreviewController.self))
        
    }
    
    func testListFileBrowserSUI() {
        let bundlePath = getBundleTestRoot()
        let resourceFile = bundlePath.appendingPathComponent("_CodeSignature")
        let item = FBFile(filePath: resourceFile, xInfo0: nil, xInfo1: nil)
        //let fileList = getBundleFileList()
        
        let view = FileLinkView(item:item)
        XCTAssertThrowsError( try view.inspect().view(FileBrowserSUI.self))
        
    }
    
    func testFileBrowserSUIView_NoAccessors() {
        print ("*** START ***")
        let bundlePath = getBundleTestRoot()
        let fileList = getBundleFileList()
        var fbsView = FileBrowserSUI(initialPath: bundlePath, xInfo0: nil, xInfo1: nil)
        do {
            try fbsView.inspect().callOnAppear()
            let exp = fbsView.on(\.didAppear) { view in
                XCTAssertEqual(try view.actualView().fileList.count, fileList.count)
                for f in try view.actualView().fileList {
                    XCTAssertTrue(fileList.contains(f.filePath))
                }
                let fileFB = try view.actualView().fileList.first
                try view.actualView().handleFilePress(selected:fileFB!)
                try fbsView.inspect().callOnAppear()
                XCTAssertEqual(try view.actualView().fileList.count, fileList.count - 1)
                XCTAssertFalse(try view.actualView().fileList.contains(fileFB!))
            }
            ViewHosting.host(view:fbsView)
            wait(for: [exp], timeout: 0.1)
            
        } catch {
            print("\(error)")
        }
    }
    
    func testFileBrowserSUIView_Accessors() {
        print ("*** START ***")
        let bundlePath = getBundleTestRoot()
        let fileList = getBundleFileList()
        let dataStore = MapExFileInfo()
        var fbsView = FileBrowserSUI(initialPath: bundlePath, xInfo0: FileExtraInfo(title: "ExInfo0", get:dataStore.get0, set: dataStore.set0, delete: dataStore.delete), xInfo1: FileExtraInfo(title: "ExInfo0", get:dataStore.get0, set: dataStore.set0, delete: dataStore.delete))
        do {
            try fbsView.inspect().callOnAppear()
            let exp = fbsView.on(\.didAppear) { view in
                XCTAssertEqual(try view.actualView().fileList.count, fileList.count)
                for f in try view.actualView().fileList {
                    XCTAssertTrue(fileList.contains(f.filePath))
                }
                
                let fbFile = try view.actualView().fileList[1]
                
                let lview = try view.hStack().list(1)
                
                let extraView = try lview.hStack(1)
                XCTAssertTrue(try extraView.hStack(0).text(0).string() == fbFile.displayName)
                
                var startValueEx0 = dataStore.get0(file: fbFile.filePath)
                var startValueEx1 = dataStore.get1(file: fbFile.filePath)
                try extraView.hStack(0).image(0).callOnTapGesture()
                XCTAssertTrue(startValueEx0 != dataStore.get0(file: fbFile.filePath))
                XCTAssertTrue(startValueEx1 == dataStore.get1(file: fbFile.filePath))
                
                startValueEx0 = dataStore.get0(file: fbFile.filePath)
                startValueEx1 = dataStore.get1(file: fbFile.filePath)
                try extraView.hStack(0).image(1).callOnTapGesture()
                XCTAssertTrue(startValueEx0 == dataStore.get0(file: fbFile.filePath))
                XCTAssertTrue(startValueEx1 != dataStore.get1(file: fbFile.filePath))
                
                startValueEx0 = dataStore.get0(file: fbFile.filePath)
                startValueEx1 = dataStore.get1(file: fbFile.filePath)
                try extraView.hStack(0).image(0).callOnTapGesture()
                XCTAssertTrue(startValueEx0 != dataStore.get0(file: fbFile.filePath))
                XCTAssertTrue(startValueEx1 == dataStore.get1(file: fbFile.filePath))
                
                let fileFB = try view.actualView().fileList.first
                XCTAssertNotNil(dataStore.fileDict[fileFB!.filePath.absoluteString])
                try view.actualView().handleFilePress(selected:fileFB!)
                try fbsView.inspect().callOnAppear()
                XCTAssertEqual(try view.actualView().fileList.count, fileList.count - 1)
                XCTAssertFalse(try view.actualView().fileList.contains(fileFB!))
                
                XCTAssertNil(dataStore.fileDict[fileFB!.filePath.absoluteString])
                
            }
            ViewHosting.host(view:fbsView)
            wait(for: [exp], timeout: 0.1)
            
        } catch {
            print("\(error)")
        }
    }
}
