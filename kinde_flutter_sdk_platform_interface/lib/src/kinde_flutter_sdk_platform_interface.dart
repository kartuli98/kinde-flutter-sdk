import 'package:kinde_flutter_sdk_platform_interface/src/models/kinde_client_options.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:kinde_flutter_sdk_platform_interface/platform.dart';

import 'models/kinde_client.dart';

abstract class KindeFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a BatteryLevelPlatform.
  KindeFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static KindeFlutterSdkPlatform _instance = MethodChannelKindeFlutterSdk();

  /// The default instance of [KindeFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelKindeFlutterSdk].
  static KindeFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KindeFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(KindeFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  Future<bool> logout(KindeClient client) {
    throw UnimplementedError('logout() has not been implemented');
  }

  Future<String?> login(KindeClient client,{
    AuthFlowType? type,
    String? orgCode,
    String? loginHint,
    AuthUrlParams? authUrlParams,
  }) {
    throw UnimplementedError('login() has not been implemented');
  }

  Future<KindeClient> createKindeClient(KindeClientOptions options) {
    throw UnimplementedError('createKindeClient() has not been implemented');
  }

  Future<void> register({
    AuthFlowType? type,
    String? orgCode,
    String? loginHint,
    AuthUrlParams? authUrlParams,
  }) {
    throw UnimplementedError('register() has not been implemented');
  }

  Future<UserProfileV2?> getUserProfileV2(KindeClient client) {
    throw UnimplementedError('getUserProfileV2() has not been implemented');
  }

  Future<UserProfile?> getUser() {
    throw UnimplementedError('getUser() has not been implemented');
  }

  Future<String?> getToken() {
    throw UnimplementedError('getToken() has not been implemented');
  }

  Future<void> createOrg({required String orgName, AuthFlowType? type}) {
    throw UnimplementedError('createOrg() has not been implemented');
  }

  Future<bool> isAuthenticate(KindeClient client) {
    throw UnimplementedError('isAuthenticate() has not been implemented');
  }
}
