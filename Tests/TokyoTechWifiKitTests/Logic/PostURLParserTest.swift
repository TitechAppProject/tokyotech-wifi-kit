import Kanna
import XCTest

@testable import TokyoTechWifiKit

final class PostURLParserTest: XCTestCase {
    func testParse_TokyoTechWiFi() throws {
        let html = try! String(contentsOf: Bundle.module.url(forResource: "TokyoTechWiFiLoginPage", withExtension: "html")!)
        let postUrl = try PostURLParser.parse(htmlDoc: try! HTML(html: html, encoding: .utf8))

        XCTAssertEqual(
            postUrl,
            URL(string: "https://n513.network-auth.com/TokyoTech/hi/aHH98cpf/login?continue_url=https%3A%2F%2Fwww.google.com")!
        )
    }

    func testParse_SciTokyoWiFi() throws {
        let html = try! String(contentsOf: Bundle.module.url(forResource: "SciTokyoWiFiLoginPage", withExtension: "html")!)
        let postUrl = try PostURLParser.parse(htmlDoc: try! HTML(html: html, encoding: .utf8))

        XCTAssertEqual(
            postUrl,
            URL(string: "https://n513.network-auth.com/SciTokyo/hi/U4Ce4dpf/login?continue_url=https%3A%2F%2Fwww.google.com")!
        )
    }
    
    func testParse_ScienceTokyoWiFi() throws {
        let html = try! String(contentsOf: Bundle.module.url(forResource: "ScienceTokyoWiFiLoginPage", withExtension: "html")!)
        let postUrl = try PostURLParser.parse(htmlDoc: try! HTML(html: html, encoding: .utf8))

        XCTAssertEqual(
            postUrl,
            URL(string: "https://n513.network-auth.com/ScienceTokyo/hi/U4Ce4dpf/login?continue_url=https%3A%2F%2Fwww.google.com")!
        )
    }

    func testParse_Error() {
        let html = try! String(contentsOf: Bundle.module.url(forResource: "Example", withExtension: "html")!)
        do {
            _ = try PostURLParser.parse(htmlDoc: try! HTML(html: html, encoding: .utf8))
            XCTFail()
        } catch {
            XCTAssertEqual(error as! TokyoTechWifiError, TokyoTechWifiError.parsePostUrlFailed)
        }
    }
}
