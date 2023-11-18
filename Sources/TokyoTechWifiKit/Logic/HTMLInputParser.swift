import Foundation
import Kanna

enum HTMLInputParser {
    static func parse(htmlDoc: HTMLDocument) -> [HTMLInput] {
        htmlDoc.css("input").map {
            HTMLInput(
                name: $0["name"] ?? "",
                type: HTMLInputType(rawValue: $0["type"] ?? "") ?? .text,
                value: $0["value"] ?? ""
            )
        }
    }
}
