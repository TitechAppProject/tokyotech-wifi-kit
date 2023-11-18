import Foundation
import Kanna

enum HTMLDocumentParser {
    static func parse(html: String) throws -> HTMLDocument {
        do {
            return try HTML(html: html, encoding: .utf8)
        } catch {
            throw TokyoTechWifiError.parseHtmlFailed
        }
    }
}
