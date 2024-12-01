import Flutter
import UIKit



public class KindeFlutterSdkIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "kinde_flutter_sdk_ios", binaryMessenger: registrar.messenger())
    let instance = KindeFlutterSdkIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "initialize":
      initialize(call, result);
    case "isAuthenticate":
      isAuthorized(result)
    case "login":
      login(call, result)
    case "register":
      login(call, result)
    case "logout":
      signOut(call, result)
    case "getUserProfile":
      getUserProfile(call, result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
 
  public func login(_ call: FlutterMethodCall, _ result: @escaping  FlutterResult) {
    let arguments = call.arguments as! [String: Any]
//    let loginHint: String? = arguments["loginHint"] as! String?
    Task {
      KindeSDKAPI.auth.enablePrivateAuthSession(true)
      var token: String = ""
      do {
        try await KindeSDKAPI.auth.login()
        token = try await KindeSDKAPI.auth.getToken()
              print("Login successful")
          } catch let error as AuthError {
              switch error {
              case .notAuthenticated:
                  print("User is not authenticated.")
              default:
                  print("AuthError occurred: \(error)")
              }
          } catch {
              print("General error occurred: \(error)")
          }
      result(token);
    }
  }
  
  public func register(_ call: FlutterMethodCall, _ result: FlutterResult) {
    let arguments = call.arguments as! [String: Any]
//    let loginHint: String? = arguments["loginHint"] as! String?
    Task {
      KindeSDKAPI.auth.enablePrivateAuthSession(true)
      do {
        try await KindeSDKAPI.auth.register()
      } catch {
        print("An error occurred: \(error)")
      }
    }
  }
  
  public func signOut(_ call: FlutterMethodCall, _ result: FlutterResult) {
    Task {
        await KindeSDKAPI.auth.logout()
    }
  }
  
  public func isAuthorized(_ result: FlutterResult) {
    let isAuthorized: Bool = KindeSDKAPI.auth.isAuthorized()
    result(isAuthorized)
  }
  
  private func initialize(_ call: FlutterMethodCall, _ result: FlutterResult)  {
    if let options = call.arguments as? [String: Any] {
      
      let config = Config(
        domain: options["domain"] as! String,
        clientId: options["client_id"] as! String,
        redirectUri: options["redirect_uri"] as! String,
        postLogoutRedirectUri: options["logout_uri"] as! String,
        scope: options["scopes"] as! String,
        audience: options["audience"] as! String?
      )
        
//        guard let urlComponents = URLComponents(string: config.domain),
//           let host = urlComponents.host,
//           let businessName = host.split(separator: ".").first else {
//            preconditionFailure("Failed to parse Business Name from configured issuer \(config.domain)")
//        }
        
      KindeSDKAPI.basePath = config.domain
      // Use Bearer authentication subclass of RequestBuilderFactory
      KindeSDKAPI.requestBuilderFactory = BearerRequestBuilderFactory()
        let logger = DefaultLogger()
      KindeSDKAPI.auth = Auth(config: config,
                    authStateRepository: AuthStateRepository(key: "\(Bundle.main.bundleIdentifier ?? "com.kinde.KindeAuth").authState", logger: logger),
                    logger: logger)
      print("initialized 100")
      result(true);
    } else {
      preconditionFailure("Failed to initialize")
    }
  }
  
  public func getUserProfile(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    Task {
      do {
        let userProfile: UserProfile = try await OAuthAPI.getUser()
        let userName = "\(userProfile.givenName ?? "") \(userProfile.familyName ?? "")"
        print("Got profile for user \(userName)")
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try encoder.encode(userProfile)
        result(jsonData)
      } catch {
        result("Error get user profile: \(error)")
      }
    }
  }
  
}
