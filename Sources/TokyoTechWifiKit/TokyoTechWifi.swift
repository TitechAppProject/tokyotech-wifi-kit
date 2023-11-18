import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Kanna

public enum TokyoTechWifiError: Error, Equatable {
    case alreadyConnected
    case otherCaptiveWiFi
    case parseHtmlFailed
    case parsePostUrlFailed
    case injectUsernameOrPasswordFailed
}

public struct TokyoTechWifi {
    private let httpClient: HTTPClient

    public init(urlSession: URLSession) {
        self.httpClient = HTTPClientImpl(urlSession: urlSession)
    }
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    public func loginIfNeed(username: String, password: String) async throws {
        let captiveResult = try await httpClient.send(CaptiveRequest())
        let captiveHTMLDocument = try HTMLDocumentParser.parse(html: captiveResult.html)
        let captivePageTitle = captiveHTMLDocument.title ?? ""
        
        if captivePageTitle.contains("Success") {
            throw TokyoTechWifiError.alreadyConnected
        }
        
        if (captivePageTitle.contains("TokyoTech") || captivePageTitle.contains("SciTokyo")), let responseUrl = captiveResult.responseUrl {
            let postUrl = try PostURLParser.parse(htmlDoc: captiveHTMLDocument)
            let captivePageInputs = HTMLInputParser.parse(htmlDoc: captiveHTMLDocument)
            let injectedCaptivePageInputs = try HTMLInputInjector.inject(captivePageInputs, username: username, password: password)
            
            _ = try await httpClient.send(CiscoMerakiHeadRequest(url: responseUrl))
            
            _ = try await httpClient.send(CiscoMerakiLoginRequest(
                url: postUrl,
                inputs: injectedCaptivePageInputs,
                referer: responseUrl
            ))
        } else {
            throw TokyoTechWifiError.otherCaptiveWiFi
        }
    }
}
