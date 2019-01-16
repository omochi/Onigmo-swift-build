import XCTest
import Onigmo

let _initOnigmoToken = {
    onig_init()
}

func initOnigmo() {
    _ = _initOnigmoToken
}

var onigmoUTF8 = OnigEncodingUTF_8

class OnigmoTests: XCTestCase {
    func test1() {
        initOnigmo()
        
        var regex: OnigRegex? = nil
        
        let pattern = "([0-9]+)-([0-9]+)"
        
        let syntax: UnsafePointer<OnigSyntaxType> = OnigDefaultSyntax
        var errorInfo: OnigErrorInfo = OnigErrorInfo()
        
        let st: CInt = pattern.utf8CString.withUnsafeBufferPointer { (pattern) in
            pattern.withMemoryRebound(to: OnigUChar.self) { (pattern: UnsafeBufferPointer<OnigUChar>) in
                let patternStart = pattern.baseAddress
                let patternEnd = pattern.baseAddress?.advanced(by: pattern.count - 1)
                return onig_new(&regex,
                                patternStart, patternEnd,
                                ONIG_OPTION_NONE,
                                &onigmoUTF8,
                                syntax,
                                &errorInfo)
            }
        }
        XCTAssertEqual(st, 0)
        defer { onig_free(regex) }

        let string = "123-456-789"
        let region: UnsafeMutablePointer<OnigRegion> = onig_region_new()
        defer { onig_region_free(region, 1) }

        let position: OnigPosition = string.utf8CString.withUnsafeBufferPointer { (string: UnsafeBufferPointer<CChar>) in
            string.withMemoryRebound(to: OnigUChar.self) { (string: UnsafeBufferPointer<OnigUChar>) in
                let stringStart = string.baseAddress
                let stringEnd = string.baseAddress?.advanced(by: string.count - 1)
                return onig_search(regex,
                                   stringStart, stringEnd,
                                   stringStart, stringEnd,
                                   region,
                                   ONIG_OPTION_NONE)
                
            }
        }
        
        XCTAssertEqual(position, 0)
        
        XCTAssertEqual(region.pointee.num_regs, 3)
        
        XCTAssertEqual(region.pointee.beg.pointee, 0)
        XCTAssertEqual(region.pointee.end.pointee, 7)
        
        XCTAssertEqual(region.pointee.beg.advanced(by: 1).pointee, 0)
        XCTAssertEqual(region.pointee.end.advanced(by: 1).pointee, 3)
        
        XCTAssertEqual(region.pointee.beg.advanced(by: 2).pointee, 4)
        XCTAssertEqual(region.pointee.end.advanced(by: 2).pointee, 7)
    }
}
