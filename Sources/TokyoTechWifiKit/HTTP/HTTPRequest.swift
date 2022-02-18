import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case head = "HEAD"
}

protocol HTTPRequest {
    var url: URL { get }

    var method: HTTPMethod { get }

    var headerFields: [String: String]? { get }

    var body: [String: String]? { get }
}

extension HTTPRequest {
    static var userAgent: String {
        "Mozilla/5.0 (iPhone; CPU iPhone OS 15_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Mobile/15E148 Safari/604.1"
    }

    func generate(cookies: [HTTPCookie]) -> URLRequest {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        switch method {
        case .get, .head:
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.httpShouldHandleCookies = true
            request.allHTTPHeaderFields = headerFields ?? [:]
            request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)
            return request
        case .post:
            guard let url = components.url else {
                fatalError("Could not get url")
            }

            let allowedCharacterSet = CharacterSet(charactersIn: "!'();:@&=+$,/?%#[]").inverted

            components.queryItems = body?.map {
                URLQueryItem(name: String($0), value: String($1).addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)?.replacingOccurrences(of: " ", with: "+") ?? "")
            }

            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.httpShouldHandleCookies = true
            request.httpBody = (components.query ?? "").data(using: String.Encoding.utf8)
            request.allHTTPHeaderFields = headerFields ?? [:]
            request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)

            return request
        }
    }
}

