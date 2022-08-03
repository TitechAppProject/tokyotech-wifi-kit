import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct WlanauthNocTitechLoginPageRequest: HTTPRequest {
    let method: HTTPMethod = .get

    let url: URL

    let headerFields: [String: String]? = [
        "Connection": "keep-alive",
        "User-Agent": WlanauthNocTitechLoginPageRequest.userAgent,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Encoding": "br, gzip, deflate",
        "Accept-Language": "ja-jp",
        "Referer": "http://captive.apple.com"
    ]

    let body: [String: String]? = nil
    
    init(url: URL) {
        self.url = url
    }
}

struct WlanauthNocTitechLoginSubmitRequest: HTTPRequest {
    let method: HTTPMethod = .post

    let url: URL = URL(string: "https://wlanauth.noc.titech.ac.jp/login.html")!

    let headerFields: [String: String]?

    let body: [String: String]?
    
    init(inputs: [HTMLInput], referer: URL) {
        headerFields = [
            "Host": "wlanauth.noc.titech.ac.jp",
            "Connection": "keep-alive",
            "User-Agent": WlanauthNocTitechLoginSubmitRequest.userAgent,
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Encoding": "br, gzip, deflate",
            "Accept-Language": "ja-jp",
            "Referer": referer.absoluteString,
            "Origin": "https://wlanauth.noc.titech.ac.jp",
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        body = inputs.reduce(into: [String: String]()) { result, input in
            result[input.name] = input.value
        }
    }
}

struct WlanauthNocTitechLogoutRequest: HTTPRequest {
    let method: HTTPMethod = .post

    let url: URL = URL(string: "https://wlanauth.noc.titech.ac.jp/logout.html")!

    let headerFields: [String: String]? = [
        "Host": "wlanauth.noc.titech.ac.jp",
        "Connection": "keep-alive",
        "User-Agent": userAgent,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Encoding": "br, gzip, deflate",
        "Accept-Language": "ja-jp",
        "Referer": "http://captive.apple.com",
        "Origin": "https://wlanauth.noc.titech.ac.jp",
        "Content-Type": "application/x-www-form-urlencoded"
    ]

    let body: [String: String]? = [
        "userStatus": "1",
        "err_flag": "0",
        "err_msg": ""
        
    ]
}
