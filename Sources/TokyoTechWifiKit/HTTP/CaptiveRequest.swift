import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct CaptiveRequest: HTTPRequest {
    let method: HTTPMethod = .get

    let url: URL = URL(string: "http://captive.apple.com")!

    let headerFields: [String: String]? = [
        "User-Agent": userAgent,
    ]

    let body: [String: String]? = nil
}
