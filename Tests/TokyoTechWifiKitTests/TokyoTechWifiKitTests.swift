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
}
