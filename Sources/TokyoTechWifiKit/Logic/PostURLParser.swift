import Foundation
import Kanna

enum PostURLParser {
    static func parse(htmlDoc: HTMLDocument) throws -> URL {
        if let url = URL(string: htmlDoc.at_css("form")?["action"] ?? "") {
            return url
        } else {
            throw TokyoTechWifiError.parsePostUrlFailed
        }
    }
}
