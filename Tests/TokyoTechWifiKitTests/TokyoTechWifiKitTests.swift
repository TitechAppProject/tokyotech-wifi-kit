import XCTest
@testable import TokyoTechWifiKit

final class TokyoTechWifiTests: XCTestCase {
    func testParseTitle() throws {
        let tokyoTechWiFi = TokyoTechWifi(urlSession: .shared)
        
        let title = try tokyoTechWiFi.parseTitle(html:
        """
        <HTML>
        <HEAD>
            <TITLE>Success</TITLE>
        </HEAD>
        <BODY>Success</BODY>
        </HTML>
        """
        )
        
        XCTAssertEqual(title, "Success")
    }
    
    func testCiscoMerakiWiFiPageParseHTMLInput() throws {
        let html = try! String(contentsOf: Bundle.module.url(forResource: "CiscoMerakiWiFiPage", withExtension: "html")!)
        
        let tokyoTechWiFi = TokyoTechWifi(urlSession: .shared)
        
        let inputs = try tokyoTechWiFi.parseHTMLInput(html: html)
        
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
    
    func testCiscoMerakiWiFiPageParsePostURL() throws {
        let html = try! String(contentsOf: Bundle.module.url(forResource: "CiscoMerakiWiFiPage", withExtension: "html")!)
        
        let tokyoTechWiFi = TokyoTechWifi(urlSession: .shared)
        
        let postUrl = try tokyoTechWiFi.parsePostURL(html: html)
        
        XCTAssertEqual(postUrl, URL(string: "https://n513.network-auth.com/TokyoTech/hi/aHH98cpf/login?continue_url=https%3A%2F%2Fwww.google.com")!)
    }
}
