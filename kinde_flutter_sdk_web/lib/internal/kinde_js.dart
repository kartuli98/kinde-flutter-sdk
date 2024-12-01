@JS()
library kinde_js;

import 'package:js/js.dart';

@JS()
@anonymous
// @staticInterop
class KindeClient {
  external String get token;
  external String get idToken;
  external bool get isAuthenticated;
  external dynamic get login;
  external dynamic get getUser;
  external dynamic get logout;

  external factory KindeClient(
      {String token,
      String idToken,
      bool authenticated,
      dynamic login,
      dynamic getUser,
      dynamic logout,
      });

// external Function([AuthOptions? options]) get login;
// external Future<void> login([AuthOptions? authOptions]);

// // Public methods
// Future<String?> getToken({GetTokenOptions? options}) async {
//   // Implement logic to return token
//   return _token;
// }
//
// Future<String?> getIdToken({GetTokenOptions? options}) async {
//   // Implement logic to return ID token
//   return _idToken;
// }
//
// Future<bool> isAuthenticated() async {
//   // Implement logic to check authentication
//   return _authenticated;
// }
//
// KindeUser getUser() {
//   // Return the current user
//   return _user;
// }
//
// Future<KindeUser?> getUserProfile() async {
//   // Implement logic to get user profile
//   return _user;
// }
//
//
// Future<void> logout() async {
//   // Implement logout logic
//   _authenticated = false;
// }
//
// Future<void> register({AuthOptions? options}) async {
//   // Implement registration logic
// }
//
// Future<void> createOrg({OrgOptions? options}) async {
//   // Implement organization creation logic
// }
//
// KindeClaim? getClaim(String claim, {ClaimTokenKey? tokenKey}) {
//   // Implement logic to retrieve a claim
//   return null;
// }
//
// KindeFlag<T> getFlag<T extends KindeFlagTypeCode>(
//     String code, {
//       KindeFlagValueType<T>? defaultValue,
//       T? flagType,
//     }) {
//   // Implement logic to retrieve a feature flag
//   return KindeFlag<T>();
// }
//
// dynamic getBooleanFlag(String code, {bool? defaultValue}) {
//   // Implement logic to retrieve a boolean flag
//   return true; // or return an Error object
// }
//
// dynamic getStringFlag(String code, {required String defaultValue}) {
//   // Implement logic to retrieve a string flag
//   return defaultValue; // or return an Error object
// }
//
// dynamic getIntegerFlag(String code, {required int defaultValue}) {
//   // Implement logic to retrieve an integer flag
//   return defaultValue; // or return an Error object
// }
//
// KindePermissions getPermissions() {
//   // Implement logic to retrieve user permissions
//   return KindePermissions();
// }
//
// KindePermission getPermission(String key) {
//   // Implement logic to retrieve a specific permission
//   return KindePermission();
// }
//
// KindeOrganization getOrganization() {
//   // Implement logic to retrieve the current organization
//   return KindeOrganization();
// }
//
// KindeOrganizations getUserOrganizations() {
//   // Implement logic to retrieve user organizations
//   return KindeOrganizations();
// }
}

@JS()
@anonymous
class GetTokenOptions {}

@JS()
@anonymous
class AuthOptions {}

@JS()
@anonymous
class OrgOptions {}

@JS()
@anonymous
class ClaimTokenKey {}

@JS()
@anonymous
class KindeFlagTypeCode {}

@JS()
@anonymous
class KindeFlagValueType<T> {}

@JS()
@anonymous
class KindeClaim {}

@JS()
@anonymous
class KindeFlag<T> {}

@JS()
@anonymous
class KindePermissions {}

@JS()
@anonymous
class KindePermission {}

@JS()
@anonymous
class KindeOrganization {}

@JS()
@anonymous
class KindeOrganizations {}

@JS()
@anonymous
external dynamic createKindeClient(KindeClientOptions options);

@JS()
@anonymous
class KindeClientOptions {
  external String? get audience;
  external String? get client_id;
  external String get redirect_uri;
  external String get domain;
  external bool? get isDangerouslyUseLocalStorage;
  external String? get logout_uri;
  // external Function(ErrorProps)? get onErrorCallback;
  // external Function(KindeUser, Map<String, dynamic>?)? onRedirectCallback;
  //todo change to List<String> or map to string in  Plugin...Web class method invocation
  external String? get scope;
  external String? get proxy_redirect_uri;
  external String? get framework;
  external String? get framework_version;

  external factory KindeClientOptions({
    String? audience,
    String? client_id,
    String redirect_uri,
    String domain,
    bool isDangerouslyUseLocalStorage,
    String? logout_uri,
    //  onErrorCallback,
    // this.onRedirectCallback,
    String? scope,
    String? proxyRedirectUri,
    String? framework,
    String? frameworkVersion,
  });
}

@JS()
@anonymous
class ErrorProps {}

@JS()
@anonymous
class KindeUser {
  external String? get given_name;
  external String? get id;
  external String? get family_name;
  external String? get email;
  external String? get picture;

  external factory KindeUser({
    String? given_name,
    String? id,
    String? family_name,
    String? email,
    String? picture,
  });
}

@JS()
external String stringify(Object object);
