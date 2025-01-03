import Foundation
import Kanna

enum PostURLParser {
    static func parse(htmlDoc: HTMLDocument) throws -> URL {
        if let action = htmlDoc.at_css("form")?["action"], let url = URL(string: action) {
            return url
        } else {
            throw TokyoTechWifiError.parsePostUrlFailed
        }
    }
}
