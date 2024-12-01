// import 'package:flutter_test/flutter_test.dart';
// import 'package:kinde_flutter_sdk_android/kinde_flutter_sdk_android.dart';
// import 'package:kinde_flutter_sdk_android/kinde_flutter_sdk_android_platform_interface.dart';
// import 'package:kinde_flutter_sdk_android/kinde_flutter_sdk_android_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockKindeFlutterSdkAndroidPlatform
//     with MockPlatformInterfaceMixin
//     implements KindeFlutterSdkAndroidPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final KindeFlutterSdkAndroidPlatform initialPlatform = KindeFlutterSdkAndroidPlatform.instance;
//
//   test('$MethodChannelKindeFlutterSdkAndroid is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelKindeFlutterSdkAndroid>());
//   });
//
//   test('getPlatformVersion', () async {
//     KindeFlutterSdkAndroid kindeFlutterSdkAndroidPlugin = KindeFlutterSdkAndroid();
//     MockKindeFlutterSdkAndroidPlatform fakePlatform = MockKindeFlutterSdkAndroidPlatform();
//     KindeFlutterSdkAndroidPlatform.instance = fakePlatform;
//
//     expect(await kindeFlutterSdkAndroidPlugin.getPlatformVersion(), '42');
//   });
// }
