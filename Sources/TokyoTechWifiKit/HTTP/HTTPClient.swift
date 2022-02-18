import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol HTTPClient {
    func send(_ request: HTTPRequest) async throws -> (html: String, responseUrl: URL?)
}

struct HTTPClientImpl: HTTPClient {
    private let urlSession: URLSession
    private let urlSessionDelegate: URLSessionTaskDelegate

    init(urlSession: URLSession) {
        self.urlSession =  urlSession
        self.urlSessionDelegate = HTTPClientDelegate()
    }

    func send(_ request: HTTPRequest) async throws -> (html: String, responseUrl: URL?) {
        let (data, response) = try await urlSession.data(
            for: request.generate(cookies: []),
               delegate: urlSessionDelegate
        )

        return (
            String(data: data, encoding: .utf8) ?? "",
            (response as? HTTPURLResponse)?.url
        )
    }
}

struct HTTPClientMock: HTTPClient {
    func send(_ request: HTTPRequest) async throws -> (html: String, responseUrl: URL?) {
        ("", URL(string: "https://example.com")!)
    }
}

class HTTPClientDelegate: URLProtocol, URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Swift.Void
    ) {
        #if DEBUG
            print("")
            print("\(response.statusCode) \(task.currentRequest?.httpMethod ?? "") \(task.currentRequest?.url?.absoluteString ?? "")")
            print("  requestHeader: \(task.currentRequest?.allHTTPHeaderFields ?? [:])")
            print("  requestBody: \(String(data: task.originalRequest?.httpBody ?? Data(), encoding: .utf8) ?? "")")
            print("  responseHeader: \(response.allHeaderFields)")
            print("  redirect -> \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
            print("")
        #endif
        
        completionHandler(request)
    }

    func urlSession(_: URLSession, task: URLSessionTask, didFinishCollecting _: URLSessionTaskMetrics) {
        #if DEBUG
            print("")
            print("200 \(task.currentRequest!.httpMethod!) \(task.currentRequest!.url!.absoluteString)")
            print("  requestHeader: \(task.currentRequest!.allHTTPHeaderFields ?? [:])")
            print("  requestBody: \(String(data: task.originalRequest!.httpBody ?? Data(), encoding: .utf8) ?? "")")
            print("")
        #endif
    }
}
