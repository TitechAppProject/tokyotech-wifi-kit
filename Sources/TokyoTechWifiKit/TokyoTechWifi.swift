import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Kanna

public enum TokyoTechWifiError: Error {
    case alreadyConnected
    case otherCaptiveWiFi
}

public struct TokyoTechWifi {
    private let httpClient: HTTPClient

    public init(urlSession: URLSession) {
        self.httpClient = HTTPClientImpl(urlSession: urlSession)
    }

    public func loginIfNeed(username: String, password: String) async throws {
        let captiveResult = try await httpClient.send(CaptiveRequest())
        
        let captivePageTitle = try parseTitle(html: captiveResult.html)
        
        if captivePageTitle.contains("Success") {
            throw TokyoTechWifiError.alreadyConnected
        }
        
        if captiveResult.html.contains("TokyoTech"), let responseUrl = captiveResult.responseUrl {
            try await loginCiscoMerakiWiFi(
                username: username,
                password: password,
                captiveHtml: captiveResult.html,
                responseUrl: responseUrl
            )
        } else if captivePageTitle.contains("Web Authentication Redirect") {
            try await loginWlanauthNocWiFi(
                username: username,
                password: password,
                captiveHtml: captiveResult.html
            )
        } else {
            throw TokyoTechWifiError.otherCaptiveWiFi
        }
    }
    
    public func loginCiscoMerakiWiFiIfNeed(username: String, password: String) async throws {
        let captiveResult = try await httpClient.send(CaptiveRequest())
        
        let captivePageTitle = try parseTitle(html: captiveResult.html)
        
        if captivePageTitle.contains("Success") {
            throw TokyoTechWifiError.alreadyConnected
        }
        
        if captiveResult.html.contains("TokyoTech"), let responseUrl = captiveResult.responseUrl {
            try await loginCiscoMerakiWiFi(
                username: username,
                password: password,
                captiveHtml: captiveResult.html,
                responseUrl: responseUrl
            )
        } else {
            throw TokyoTechWifiError.otherCaptiveWiFi
        }
    }
    
    public func loginWlanauthNocWiFiIfNeed(username: String, password: String) async throws {
        let captiveResult = try await httpClient.send(CaptiveRequest())
        
        let captivePageTitle = try parseTitle(html: captiveResult.html)
        
        if captivePageTitle.contains("Success") {
            throw TokyoTechWifiError.alreadyConnected
        }
        
        if captivePageTitle.contains("Web Authentication Redirect") {
            try await loginWlanauthNocWiFi(
                username: username,
                password: password,
                captiveHtml: captiveResult.html
            )
        } else {
            throw TokyoTechWifiError.otherCaptiveWiFi
        }
    }
    
    public func logoutWlanauthNocWiFi() async throws {
        _ = try await httpClient.send(WlanauthNocTitechLogoutRequest())
    }
    
    func loginCiscoMerakiWiFi(username: String, password: String, captiveHtml: String, responseUrl: URL) async throws {
        guard let postUrl = try parsePostURL(html: captiveHtml) else {
            return
        }
        let captivePageInputs = try parseHTMLInput(html: captiveHtml)
        let injectedCaptivePageInputs = inject(captivePageInputs, username: username, password: password)
        
        _ = try await httpClient.send(CiscoMerakiHeadRequest(url: responseUrl))
        
        _ = try await httpClient.send(CiscoMerakiLoginRequest(
            url: postUrl,
            inputs: injectedCaptivePageInputs,
            referer: responseUrl
        ))
    }
    
    func loginWlanauthNocWiFi(username: String, password: String, captiveHtml: String) async throws {
        let redirectUrl = try parseMetaRedirectURL(html: captiveHtml)
        guard let redirectUrl = redirectUrl else {
            return
        }
        let (loginPageHtml, _) = try await httpClient.send(WlanauthNocTitechLoginPageRequest(url: redirectUrl))
        
        let inputs = try parseHTMLInput(html: loginPageHtml)
        let injectedInputs = inject(inputs, username: username, password: password)
        
        _ = try await httpClient.send(WlanauthNocTitechLoginSubmitRequest(
            inputs: injectedInputs,
            referer: redirectUrl
        ))
    }

    func parseTitle(html: String) throws -> String {
        let doc = try HTML(html: html, encoding: .utf8)
        
        return doc.title ?? ""
    }
    
    func parsePostURL(html: String) throws -> URL? {
        let doc = try HTML(html: html, encoding: .utf8)
        
        return URL(string: doc.at_css("form")?["action"] ?? "")
    }

    func parseHTMLInput(html: String) throws -> [HTMLInput] {
        let doc = try HTML(html: html, encoding: .utf8)

        return doc.css("input").map {
            HTMLInput(
                name: $0["name"] ?? "",
                type: HTMLInputType(rawValue: $0["type"] ?? "") ?? .text,
                value: $0["value"] ?? ""
            )
        }
    }

    func parseMetaRedirectURL(html: String) throws -> URL? {
        let doc = try HTML(html: html, encoding: .utf8)

        let metas = doc.css("meta")
        let urls = metas
            .map { $0["content"] }
            .filter { $0?.contains("1; URL=") ?? false }
            .map { $0?.replacingOccurrences(of: "1; URL=", with: "") }
            .map { URL(string: $0 ?? "") }
            .compactMap { $0 }

        if let url = urls.first {
            return url
        }

        return nil
    }

    func inject(_ inputs: [HTMLInput], username: String, password: String) -> [HTMLInput] {
        guard
            let firstTextInput = inputs.first(where: { $0.type == .text }),
            let firstPasswordInput = inputs.first(where: { $0.type == .password })
        else {
            // TODO: エラーにした方がいいかも
            return inputs
        }

        return inputs.map {
            if $0 == firstTextInput {
                var newInput = $0
                newInput.value = username
                return newInput
            }
            if $0 == firstPasswordInput {
                var newInput = $0
                newInput.value = password
                return newInput
            }
            return $0
        }
    }
}
