// import 'package:flutter_test/flutter_test.dart';
// import 'package:kinde_flutter_sdk/kinde_flutter_sdk.dart';
// import 'package:kinde_flutter_sdk/src/kinde_flutter_sdk.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// import 'package:kinde_flutter_sdk_platform_interface/platform.dart';
//
// class MockKindeFlutterSdkPlatform
//     with MockPlatformInterfaceMixin
//     implements KindeFlutterSdkPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
//
//   @override
//   Future<void> createOrg({required String orgName, AuthFlowType? type}) {
//     // TODO: implement createOrg
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<String?> getToken() {
//     // TODO: implement getToken
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<UserProfile?> getUser() {
//     // TODO: implement getUser
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<UserProfileV2?> getUserProfileV2() {
//     // TODO: implement getUserProfileV2
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<bool> isAuthenticate() {
//     // TODO: implement isAuthenticate
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> login({AuthFlowType? type, String? orgCode, String? loginHint, AuthUrlParams? authUrlParams}) {
//     // TODO: implement login
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> logout() {
//     // TODO: implement logout
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> register({AuthFlowType? type, String? orgCode, String? loginHint, AuthUrlParams? authUrlParams}) {
//     // TODO: implement register
//     throw UnimplementedError();
//   }
// }
//
// void main() {
//   final KindeFlutterSdkPlatform initialPlatform = KindeFlutterSdkPlatform.instance;
//
//   test('$MethodChannelKindeFlutterSdk is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelKindeFlutterSdk>());
//   });
//
//   test('getPlatformVersion', () async {
//     KindeFlutterSDK kindeFlutterSdkPlugin = KindeFlutterSDK.instance;
//     MockKindeFlutterSdkPlatform fakePlatform = MockKindeFlutterSdkPlatform();
//     KindeFlutterSdkPlatform.instance = fakePlatform;
//
//     expect(await kindeFlutterSdkPlugin.getPlatformVersion(), '42');
//   });
// }
