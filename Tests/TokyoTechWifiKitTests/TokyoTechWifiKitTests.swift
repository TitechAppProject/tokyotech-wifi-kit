import XCTest
@testable import TokyoTechWifiKit

final class TokyoTechWifiTests: XCTestCase {    
    func testLoginIfNeed_Success_TokyoTechWiFi() async throws {
        let html = try String(contentsOf: Bundle.module.url(forResource: "TokyoTechWiFiLoginPage", withExtension: "html")!)
        let tokyoTechWiFi = TokyoTechWifi(
            httpClient: HTTPClientMock(
                html: html,
                responseUrl: URL(string: "http://captive.apple.com")
            )
        )

        try await tokyoTechWiFi.loginIfNeed(username: "", password: "")
        XCTAssert(true)
    }
    
    func testLoginIfNeed_Success_SciTokyoWiFi() async throws {
        let html = try String(contentsOf: Bundle.module.url(forResource: "SciTokyoWiFiLoginPage", withExtension: "html")!)
        let tokyoTechWiFi = TokyoTechWifi(
            httpClient: HTTPClientMock(
                html: html,
                responseUrl: URL(string: "http://captive.apple.com")
            )
        )

        try await tokyoTechWiFi.loginIfNeed(username: "", password: "")
        XCTAssert(true)
    }

    func testLoginIfNeed_AlreadyConnectedError() async {
        let tokyoTechWiFi = TokyoTechWifi(
            httpClient: HTTPClientMock(
                html: """
                <HTML>
                <HEAD>
                    <TITLE>Success</TITLE>
                </HEAD>
                <BODY>Success</BODY>
                </HTML>
                """,
                responseUrl: URL(string: "http://captive.apple.com")
            )
        )

        do {
            try await tokyoTechWiFi.loginIfNeed(username: "", password: "")
            XCTFail()
        } catch {
            XCTAssertEqual(error as! TokyoTechWifiError, TokyoTechWifiError.alreadyConnected)
        }
    }
    
    func testLoginIfNeed_OtherCaptiveWiFiError() async {
        let tokyoTechWiFi = TokyoTechWifi(
            httpClient: HTTPClientMock(
                html: """
                <HTML>
                <HEAD>
                    <TITLE>Need Login!!!</TITLE>
                </HEAD>
                <BODY></BODY>
                </HTML>
                """,
                responseUrl: URL(string: "http://captive.apple.com")
            )
        )

        do {
            try await tokyoTechWiFi.loginIfNeed(username: "", password: "")
            XCTFail()
        } catch {
            XCTAssertEqual(error as! TokyoTechWifiError, TokyoTechWifiError.otherCaptiveWiFi)
        }
    }
}
