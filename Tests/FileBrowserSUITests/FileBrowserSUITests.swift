import XCTest
import ViewInspector

@testable import FileBrowserSUI

extension extraInfoView1: Inspectable {}

final class FileBrowserSUITests: XCTestCase {

    static var allTests = [
        ("testJpgFBFileParse", testJpgFBFileParse),
        ("testGifFileParse", testGifFileParse),
        ("testExtraInfo0", testExtraInfo0)
    ]

    func testJpgFBFileParse() {
        let bundlePath = getBundleTestRoot()
        let resourceFile = bundlePath.appendingPathComponent("Baymax.jpg")
        
        let displayInfo = resourceFile.lastPathComponent.split(separator: ".")
        
        let file = FBFile(filePath: resourceFile, xInfo0: nil, xInfo1: nil)
        XCTAssertEqual(file.filePath, resourceFile)
        XCTAssertFalse(file.isDirectory)
        XCTAssertEqual(file.type, FBFileType.JPG)
        XCTAssertEqual(file.fileExtension, "jpg")
        XCTAssertEqual(file.fileExtension, String(displayInfo[1]))
        XCTAssertEqual(file.displayName, resourceFile.lastPathComponent)
        XCTAssertNil(file.fileExInfo0)
        XCTAssertNil(file.fileExInfo1)
    }
    
    func testGifFileParse() {
        let bundlePath = getBundleTestRoot()
        let resourceFile = bundlePath.appendingPathComponent("3crBxeO.gif")
        
        let displayInfo = resourceFile.lastPathComponent.split(separator: ".")
        
        let file = FBFile(filePath: resourceFile, xInfo0: nil, xInfo1: nil)
        XCTAssertEqual(file.filePath, resourceFile)
        XCTAssertFalse(file.isDirectory)
        XCTAssertEqual(file.type, FBFileType.GIF)
        XCTAssertEqual(file.fileExtension, "gif")
        XCTAssertEqual(file.fileExtension, String(displayInfo[1]))
        XCTAssertEqual(file.displayName, resourceFile.lastPathComponent)
        XCTAssertNil(file.fileExInfo0)
        XCTAssertNil(file.fileExInfo1)
    }
    
    func testExtraInfo0() {
        var info0:Bool = false
        var fileName0: URL?
        var info1:Bool = false
        var fileName1: URL?
        var deleteCnt = 0
        let bundlePath = getBundleTestRoot()
        let resourceFile = bundlePath.appendingPathComponent("3crBxeO.gif")
        
        let accessor0 = FileExtraInfo(title: "test0", get: { filename in
            return info0
        }, set: { (filename, value) in
            info0=value;
            fileName0 = filename
        }, delete: { (filename) -> Bool in
            fileName0 = filename
            return true
        })
        
        let accessor1 = FileExtraInfo(title: "test1", get: { filename in
            return info1
        }, set: { (filename, value) in
            info1=value;
            fileName1 = filename
        }, delete: { (filename) -> Bool in
            fileName1 = filename
            deleteCnt += 1
            return true
        })
        
        
        let file = FBFile(filePath: resourceFile, xInfo0: accessor0, xInfo1: accessor1)
        XCTAssertFalse(info0)
        XCTAssertFalse(info1)
        let view = extraInfoView1(file:file)
        do {
           try view.inspect().hStack().hStack(0).image(1).callOnTapGesture()
        } catch {
            print(error)
        }
        XCTAssertTrue(info0)
        XCTAssertFalse(info1)
        XCTAssertNotNil(fileName0)
        XCTAssertTrue(fileName0 == resourceFile )
        fileName0 = nil
        do {
           try view.inspect().hStack().hStack(0).image(1).callOnTapGesture()
        } catch {
            print(error)
        }
        XCTAssertFalse(info0)
        XCTAssertFalse(info1)
        XCTAssertNotNil(fileName0)
        XCTAssertTrue(fileName0 == resourceFile )
        fileName0 = nil
        do {
           try view.inspect().hStack().hStack(1).image(1).callOnTapGesture()
        } catch {
            print(error)
        }
        XCTAssertFalse(info0)
        XCTAssertTrue(info1)
        XCTAssertNotNil(fileName1)
        XCTAssertTrue(fileName1 == resourceFile )
        fileName1 = nil
        do {
           try view.inspect().hStack().hStack(1).image(1).callOnTapGesture()
        } catch {
            print(error)
        }
        XCTAssertFalse(info0)
        XCTAssertFalse(info1)
        XCTAssertNotNil(fileName1)
        XCTAssertTrue(fileName1 == resourceFile )
        fileName1 = nil
        do {
           try view.inspect().hStack().hStack(1).image(1).callOnTapGesture()
           try view.inspect().hStack().hStack(0).image(1).callOnTapGesture()
        } catch {
            print(error)
        }
        XCTAssertTrue(info0)
        XCTAssertTrue(info1)
        XCTAssertNotNil(fileName0)
        XCTAssertTrue(fileName0 == resourceFile )
        fileName0 = nil
        XCTAssertNotNil(fileName1)
        XCTAssertTrue(fileName1 == resourceFile )
        fileName1 = nil
        do {
           try view.inspect().hStack().hStack(1).image(1).callOnTapGesture()
           try view.inspect().hStack().hStack(0).image(1).callOnTapGesture()
        } catch {
            print(error)
        }
        XCTAssertFalse(info0)
        XCTAssertFalse(info1)
        XCTAssertNotNil(fileName0)
        XCTAssertTrue(fileName0 == resourceFile )
        fileName0 = nil
        XCTAssertNotNil(fileName1)
        XCTAssertTrue(fileName1 == resourceFile )
        fileName1 = nil
    }
    

}
