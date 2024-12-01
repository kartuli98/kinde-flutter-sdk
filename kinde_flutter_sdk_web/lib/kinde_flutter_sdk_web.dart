import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:js/js_util.dart';
import 'package:kinde_flutter_sdk_web/mappers/mappers.dart';
import 'package:web/web.dart' as web;

import 'package:kinde_flutter_sdk_platform_interface/platform.dart';
import 'internal/kinde_js.dart' as kinde_js;

/// A web implementation of the KindeFlutterSdkPlatform of the KindeFlutterSdk plugin.
class KindeFlutterSdkWeb extends KindeFlutterSdkPlatform {
  /// Constructs a KindeFlutterSdkWeb
  KindeFlutterSdkWeb();

  static void registerWith(Registrar registrar) {
    KindeFlutterSdkPlatform.instance = KindeFlutterSdkWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }

  @override
  Future<KindeClient> createKindeClient(KindeClientOptions options) async {

    final webOptions = KindeWebMappers.options.toWeb(options);
    final kindeClientPromise = kinde_js.createKindeClient(webOptions);
    final kindeClientWeb = await promiseToFuture<kinde_js.KindeClient>(kindeClientPromise);
    return KindeWebMappers.client.fromWeb(kindeClientWeb);
  }

  @override
  Future<bool> isAuthenticate(KindeClient client) async {
    final isAuthenticatedPromise = client.isAuthenticated();
    final isAuthenticated = await promiseToFuture<bool>(isAuthenticatedPromise);
    return isAuthenticated;
  }

  @override
  Future<UserProfileV2?> getUserProfileV2(KindeClient client) async {
    final kindeUser = client.getUser();
    print(kindeUser);
    final userProfile2 = UserProfileV2((updates) {
      updates.givenName = kindeUser.given_name;
      updates.id = kindeUser.id;
      updates.familyName = kindeUser.family_name;
      updates.email = kindeUser.email;
      updates.picture = kindeUser.picture;
      updates.build();
    }
    );
    return userProfile2;
  }

  @override
  Future<String?> login(KindeClient client, {AuthFlowType? type, String? orgCode, String? loginHint, AuthUrlParams? authUrlParams}) async {
    await promiseToFuture(client.login());
    return null;
  }

  @override
  Future<void> register({AuthFlowType? type, String? orgCode, String? loginHint, AuthUrlParams? authUrlParams}) {
    // TODO: implement register
    throw UnimplementedError('register() has not been implemented for web');
  }

  @override
  Future<void> logout(KindeClient client) async {
    await promiseToFuture<void>(client.logout());
  }
}
