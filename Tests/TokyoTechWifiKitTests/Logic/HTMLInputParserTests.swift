import XCTest
import Kanna
@testable import TokyoTechWifiKit

final class HTMLInputParserTests: XCTestCase {
    func testParse_TokyoTechWiFi() {
        let html = try! String(contentsOf: Bundle.module.url(forResource: "TokyoTechWiFiLoginPage", withExtension: "html")!)
        let inputs = HTMLInputParser.parse(htmlDoc: try! HTML(html: html, encoding: .utf8))

        XCTAssertEqual(inputs[0].name, "utf8")
        XCTAssertEqual(inputs[0].value, "✓")
        XCTAssertEqual(inputs[0].type, .hidden)
        
        XCTAssertEqual(inputs[1].name, "email")
        XCTAssertEqual(inputs[1].value, "")
        XCTAssertEqual(inputs[1].type, .text)
        
        XCTAssertEqual(inputs[2].name, "password")
        XCTAssertEqual(inputs[2].value, "")
        XCTAssertEqual(inputs[2].type, .password)
        
        XCTAssertEqual(inputs[3].name, "commit")
        XCTAssertEqual(inputs[3].value, "ログイン")
        XCTAssertEqual(inputs[3].type, .submit)
    }
    
    func testParse_SciTokyoWiFi() throws {
        let html = try! String(contentsOf: Bundle.module.url(forResource: "SciTokyoWiFiLoginPage", withExtension: "html")!)
        let inputs = HTMLInputParser.parse(htmlDoc: try! HTML(html: html, encoding: .utf8))

        XCTAssertEqual(inputs[0].name, "utf8")
        XCTAssertEqual(inputs[0].value, "✓")
        XCTAssertEqual(inputs[0].type, .hidden)
        
        XCTAssertEqual(inputs[1].name, "email")
        XCTAssertEqual(inputs[1].value, "")
        XCTAssertEqual(inputs[1].type, .text)
        
        XCTAssertEqual(inputs[2].name, "password")
        XCTAssertEqual(inputs[2].value, "")
        XCTAssertEqual(inputs[2].type, .password)
        
        XCTAssertEqual(inputs[3].name, "commit")
        XCTAssertEqual(inputs[3].value, "ログイン")
        XCTAssertEqual(inputs[3].type, .submit)
    }
}
