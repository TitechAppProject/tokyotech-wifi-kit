import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol HTTPClient {
    func send(_ request: HTTPRequest) async throws -> (html: String, responseUrl: URL?)
}

struct HTTPClientImpl: HTTPClient {
    private let urlSession: URLSession
    #if !canImport(FoundationNetworking)
    private let urlSessionDelegate: URLSessionTaskDelegate
    #endif

    init(urlSession: URLSession) {
        self.urlSession = urlSession
        #if !canImport(FoundationNetworking)
        self.urlSessionDelegate = HTTPClientDelegate()
        #endif
    }

    func send(_ request: HTTPRequest) async throws -> (html: String, responseUrl: URL?) {
        let (data, response) = try await fetchData(request: request.generate(cookies: []))

        return (
            String(data: data, encoding: .utf8) ?? "",
            (response as? HTTPURLResponse)?.url
        )
    }

    func fetchData(request: URLRequest) async throws -> (Data, URLResponse) {
        #if canImport(FoundationNetworking)
        return try await withCheckedThrowingContinuation { continuation in
            urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: (data ?? Data(), response!))
                }
            }.resume()
        }
        #else
        return try await urlSession.data(for: request, delegate: urlSessionDelegate)
        #endif
    }
}

struct HTTPClientMock: HTTPClient {
    let html: String
    let responseUrl: URL?

    func send(_ request: HTTPRequest) async throws -> (html: String, responseUrl: URL?) {
        (html, responseUrl)
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
