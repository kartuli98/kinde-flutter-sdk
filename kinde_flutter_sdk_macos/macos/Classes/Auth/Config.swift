import Foundation

/// Configuration for the Kinde authentication service and Kinde Management API client
public struct Config: Decodable {
    let domain: String
    let clientId: String
    let redirectUri: String
    let postLogoutRedirectUri: String
    let scope: String
    let audience: String?
    
    public init(domain: String, clientId: String, redirectUri: String,
                postLogoutRedirectUri: String, scope: String, audience: String?) {
        self.domain = domain
        self.clientId = clientId
        self.redirectUri = redirectUri
        self.postLogoutRedirectUri = postLogoutRedirectUri
        self.scope = scope
        self.audience = audience
    }
    
    /// Get the configured Issuer URL, or `nil` if it is missing or malformed
    public func getDomainUrl() -> URL? {
        guard let url = URL(string: self.domain) else {
            return nil
        }
        return url
    }
     
    /// Get the configured Redirect URL, or `nil` if it is missing or malformed
    func getRedirectUrl() -> URL? {
        guard let url = URL(string: self.redirectUri) else {
            return nil
        }
        return url
    }
    
    /// Get the configured Post Logout Redirect URL, or `nil` if it is missing or malformed
    func getPostLogoutRedirectUrl() -> URL? {
        guard let url = URL(string: self.postLogoutRedirectUri) else {
            return nil
        }
        return url
    }

    
    private static func loadFromPlist() -> Config? {
        var configFilePath: String = ""
        for bundle in Bundle.allBundles {
            if let resourcePath = bundle.path(forResource: "KindeAuth", ofType: "plist") {
                configFilePath = resourcePath
                break
            }
        }
        guard configFilePath.count > 0,
              let values = NSDictionary(contentsOfFile: configFilePath) as? [String: Any] else {
                return nil
        }
        
        guard let domain = values["Domain"] as? String,
              let clientId = values["ClientId"] as? String,
              let redirectUri = values["RedirectUri"] as? String,
              let postLogoutRedirectUri = values["PostLogoutRedirectUri"] as? String,
              let scope = values["Scope"] as? String else {
                return nil
            }
        let audience = values["Audience"] as? String
        return Config(domain: domain,
                      clientId: clientId,
                      redirectUri: redirectUri,
                      postLogoutRedirectUri: postLogoutRedirectUri,
                      scope: scope,
                      audience: audience)
    }
}
