import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct CiscoMerakiHeadRequest: HTTPRequest {
    let method: HTTPMethod = .head

    let url: URL

    let headerFields: [String: String]?

    var body: [String: String]?

    init(url: URL) {
        self.url = url
        headerFields = [
            "Host": url.host ?? "",
            "Connection": "keep-alive",
            "User-Agent": CiscoMerakiHeadRequest.userAgent,
            "Accept": "*/*",
            "Accept-Encoding": "gzip, deflate, br",
            "Accept-Language": "ja,en-US;q=0.9,en;q=0.8,ja-JP;q=0.7p",
            "Referer": url.absoluteString,
            "X-Requested-With": "XMLHttpRequest",
        ]
    }
}

struct CiscoMerakiLoginRequest: HTTPRequest {
    let method: HTTPMethod = .post

    let url = URL(string: "https://n513.network-auth.com/TokyoTech/hi/U4Ce4dpf/login?continue_url=https%3A%2F%2Fwww.google.com")!

    let headerFields: [String: String]?

    let body: [String: String]?

    init(inputs: [HTMLInput], referer: URL) {
        headerFields = [
            "Host": url.host ?? "",
            "Connection": "keep-alive",
            "User-Agent": CiscoMerakiLoginRequest.userAgent,
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "Accept-Encoding": "gzip, deflate, br",
            "Accept-Language": "ja,en-US;q=0.9,en;q=0.8,ja-JP;q=0.7p",
            "Referer": referer.absoluteString,
            "Origin": "https://" + (url.host ?? ""),
            "Content-Type": "application/x-www-form-urlencoded",
        ]

        body = inputs.reduce(into: [String: String]()) { result, input in
            result[input.name] = input.value
        }
    }
}
