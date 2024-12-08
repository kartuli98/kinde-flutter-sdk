import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kinde_flutter_sdk_platform_interface/platform.dart';

/// A web implementation of the KindeFlutterSdkPlatform of the KindeFlutterSdk plugin.
class KindeFlutterSdkIOS extends KindeFlutterSdkPlatform {
  /// Constructs a KindeFlutterSdkIOS
  KindeFlutterSdkIOS();

  static void registerWith() {
    KindeFlutterSdkPlatform.instance = KindeFlutterSdkIOS();
  }


  final _methodChannel = const MethodChannel('kinde_flutter_sdk_ios');

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<KindeClient> createKindeClient(KindeClientOptions options) {
    print("debug logout_uri: ${options.logout_uri}");
    final optionsJson = options.toJson();
    optionsJson["scopes"] = options.scopes.join(" ");
    return _methodChannel.invokeMethod<bool>(
        'initialize', optionsJson
    ).then((result) {
      debugPrint("Flutter Plugin Debug: createKindeClient() => result: $result");
      return KindeClient(
        token: "token",
        idToken: "idToken",
        isAuthenticated: false,
        login: login,
        getUser: getUser,
        logout: logout
    );
    });
  }

  @override
  Future<bool> isAuthenticate(KindeClient client) async {
    return _methodChannel.invokeMethod<bool>(
      'isAuthenticate',
    ).then((bool? value) {
      debugPrint("Flutter Plugin Debug: isAuthenticate() => result: $value");
      return value ?? false;
    });
  }

  @override
  Future<void> createOrg({required String orgName, AuthFlowType? type}) {
    return _methodChannel.invokeMethod<void>(
      'launch',
      <String, Object>{
        'orgName': orgName,
      },
    ).then((_) {
      debugPrint("Flutter Plugin Debug: createOrg()");
    });
  }

  @override
  Future<String> getToken() {
    return _methodChannel.invokeMethod<String>(
      'getToken',
    ).then((String? value) {
      debugPrint("Flutter Plugin Debug: getToken() => result: $value");
      return value ?? "";
    });;
  }

// @override
// Future<UserProfile> getUser() {
//   final userJson = _methodChannel.invokeMethod<Object>(
//     'launch',
//   ).then((Object? value) => );
//   UserProfile().rebuild(updates)
// }

// @override
// Future<UserProfileV2> getUserProfileV2() {
//   return _methodChannel.invokeMethod<bool>(
//     'launch',
//     <String, Object>{
//       'url': url,
//     },
//   );
// }

  @override
  Future<void> register(
      {AuthFlowType? type,
        String? orgCode,
        String? loginHint,
        AuthUrlParams? authUrlParams}) {
    return _methodChannel.invokeMethod<bool>(
      'register',
      <String, Object?>{
        ///todo
        'type': type?.toString(),
        'orgCode': orgCode,
        'loginHint': loginHint,
        'authUrlParams': authUrlParams?.toMap()
      },
    ).then((_) {
      debugPrint("Flutter Plugin Debug: register()");
    });
  }

  @override
  Future<String?> login( KindeClient client,
      {AuthFlowType? type,
        String? orgCode,
        String? loginHint,
        AuthUrlParams? authUrlParams}) {
    return _methodChannel.invokeMethod<String>(
      'login',
      <String, Object?>{
        ///todo
        'type': type?.toString(),
        'orgCode': orgCode,
        'loginHint': loginHint,
        'authUrlParams': authUrlParams?.toMap()
      },
    ).then((token) {
      print("Flutter Plugin Debug: login() => token: $token");
      return token ?? "";
    });
  }

  @override
  Future<UserProfileV2> getUserProfileV2(KindeClient client) {
    return _methodChannel.invokeMethod<dynamic>(
      'getUserProfile',
    ).then((rawResult) {
      final result = jsonDecode(Utf8Decoder().convert(rawResult));
      debugPrint("Flutter Plugin Debug: getUserProfileV2() => result: $result");
      if(result is String) {
        throw Exception(result);
      } else {
        final builder = UserProfileV2Builder();
        builder.id = result["id"];
        builder.name = result["name"];
        builder.givenName = result["given_name"];
        builder.familyName = result["family_name"];
        builder.updatedAt = result["updated_at"];
        return builder.build();
      }
    });
  }

  @override
  Future<bool> logout(KindeClient client) {
    return _methodChannel.invokeMethod<dynamic>(
      'logout',
    ).then((isLogoutSuccess) {
      debugPrint("IOS Flutter Plugin Debug: logout() => isLogoutSuccess: $isLogoutSuccess");
      if(isLogoutSuccess is bool) {
        return isLogoutSuccess;
      } else {
        throw KindeError(isLogoutSuccess);
      }
    });
  }
}
