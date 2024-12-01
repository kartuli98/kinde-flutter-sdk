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
  Future<bool> isAuthenticate(KindeClient client) async {
    return _methodChannel.invokeMethod<bool>(
      'isAuthenticate',
    ).then((bool? value) => value ?? false);
  }

  @override
  Future<void> createOrg({required String orgName, AuthFlowType? type}) {
    return _methodChannel.invokeMethod<void>(
      'launch',
      <String, Object>{
        'orgName': orgName,
      },
    );
  }

  @override
  Future<String> getToken() {
    return _methodChannel.invokeMethod<String>(
      'getToken',
    ).then((String? value) => value ?? "");;
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
    );
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
    );
  }

  @override
  Future<void> logout(KindeClient client) {
    return _methodChannel.invokeMethod<void>(
      'logout',
    );
  }
}
