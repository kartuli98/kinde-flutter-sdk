// import 'package:flutter_test/flutter_test.dart';
// import 'package:kinde_flutter_sdk_web/kinde_flutter_sdk_web.dart';
// import 'package:kinde_flutter_sdk_web/kinde_flutter_sdk_web_platform_interface.dart';
// import 'package:kinde_flutter_sdk_web/kinde_flutter_sdk_web_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockKindeFlutterSdkWebPlatform
//     with MockPlatformInterfaceMixin
//     implements KindeFlutterSdkWebPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final KindeFlutterSdkWebPlatform initialPlatform = KindeFlutterSdkWebPlatform.instance;
//
//   test('$MethodChannelKindeFlutterSdkWeb is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelKindeFlutterSdkWeb>());
//   });
//
//   test('getPlatformVersion', () async {
//     KindeFlutterSdkWeb kindeFlutterSdkWebPlugin = KindeFlutterSdkWeb();
//     MockKindeFlutterSdkWebPlatform fakePlatform = MockKindeFlutterSdkWebPlatform();
//     KindeFlutterSdkWebPlatform.instance = fakePlatform;
//
//     expect(await kindeFlutterSdkWebPlugin.getPlatformVersion(), '42');
//   });
// }
