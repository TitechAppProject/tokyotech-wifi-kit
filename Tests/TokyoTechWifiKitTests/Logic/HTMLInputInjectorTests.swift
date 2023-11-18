import Kanna
import XCTest

@testable import TokyoTechWifiKit

final class HTMLInputInjectorTests: XCTestCase {
    func testInject() throws {
        let injected = try HTMLInputInjector.inject(
            [
                HTMLInput(name: "utf8", type: HTMLInputType.hidden, value: "✓"),
                HTMLInput(name: "email", type: HTMLInputType.text, value: ""),
                HTMLInput(name: "password", type: HTMLInputType.password, value: ""),
                HTMLInput(name: "commit", type: HTMLInputType.submit, value: "ログイン"),
            ],
            username: "00B00000",
            password: "pass"
        )

        XCTAssertEqual(injected[1].name, "email")
        XCTAssertEqual(injected[1].value, "00B00000")
        XCTAssertEqual(injected[1].type, .text)

        XCTAssertEqual(injected[2].name, "password")
        XCTAssertEqual(injected[2].value, "pass")
        XCTAssertEqual(injected[2].type, .password)
    }

    func testInject_Error() {
        do {
            _ = try HTMLInputInjector.inject(
                [
                    HTMLInput(name: "utf8", type: HTMLInputType.hidden, value: "✓"),
                    HTMLInput(name: "commit", type: HTMLInputType.submit, value: "ログイン"),
                ],
                username: "00B00000",
                password: "pass"
            )
            XCTFail()
        } catch {
            XCTAssertEqual(error as! TokyoTechWifiError, TokyoTechWifiError.injectUsernameOrPasswordFailed)
        }
    }
}
