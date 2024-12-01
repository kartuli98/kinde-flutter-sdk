import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


import 'package:kinde_flutter_sdk_platform_interface/platform.dart';


/// An implementation of [KindeFlutterSdkPlatform] that uses method channels.
class MethodChannelKindeFlutterSdk extends KindeFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kinde_flutter_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  // @override
  // Future<bool> isAuthenticate() async {
  //   return methodChannel.invokeMethod<bool>(
  //     'isAuthenticate',
  //   ).then((bool? value) => value ?? false);
  // }

  // @override
  // Future<void> createOrg({required String orgName, AuthFlowType? type}) {
  //    return methodChannel.invokeMethod<Function>(
  //     'launch',
  //     <String, Object>{
  //       'orgName': orgName,
  //     },
  //   ).then((bool? value) => value ?? false);;
  // }

  // @override
  // Future<String> getToken() {
  //   return methodChannel.invokeMethod<String>(
  //     'getToken',
  //   ).then((String? value) => value ?? "");;
  // }

  // @override
  // Future<UserProfile> getUser() {
  //   final userJson = methodChannel.invokeMethod<Object>(
  //     'launch',
  //   ).then((Object? value) => );
  //   UserProfile().rebuild(updates)
  // }

  // @override
  // Future<UserProfileV2> getUserProfileV2() {
  //   return methodChannel.invokeMethod<bool>(
  //     'launch',
  //     <String, Object>{
  //       'url': url,
  //     },
  //   );
  // }

  // @override
  // Future<void> register(
  //     {AuthFlowType? type,
  //     String? orgCode,
  //     String? loginHint,
  //     AuthUrlParams? authUrlParams}) {
  //   return methodChannel.invokeMethod<bool>(
  //     'register',
  //     <String, Object?>{
  //       ///todo
  //       'type': type?.toString(),
  //       'orgCode': orgCode,
  //       'loginHint': loginHint,
  //       'authUrlParams': authUrlParams?.toMap()
  //     },
  //   );
  // }

  // @override
  // Future<String?> login(
  //     {AuthFlowType? type,
  //     String? orgCode,
  //     String? loginHint,
  //     AuthUrlParams? authUrlParams}) {
  //   return methodChannel.invokeMethod<String>(
  //     'login',
  //     <String, Object?>{
  //       ///todo
  //       'type': type?.toString(),
  //       'orgCode': orgCode,
  //       'loginHint': loginHint,
  //       'authUrlParams': authUrlParams?.toMap()
  //     },
  //   );
  // }

  // @override
  // Future<void> logout() {
  //   return methodChannel.invokeMethod<void>(
  //     'logout',
  //   );
  // }
}
