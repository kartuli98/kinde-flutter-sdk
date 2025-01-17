import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kinde_flutter_sdk/src/oauth_webauth_param/src/base/base_oauth_flow.dart';
import 'package:kinde_flutter_sdk/src/oauth_webauth_param/src/base/model/oauth_configuration.dart';
import 'package:kinde_flutter_sdk/src/oauth_webauth_param/src/oauth_web_view.dart';
import 'package:oauth2/oauth2.dart';

import '../oauth_webauth_param.dart';

class OAuthWebScreen extends StatelessWidget {
  static Future? start({
    Key? key,
    GlobalKey<OAuthWebViewState>? globalKey,
    required OAuthConfiguration configuration,
  }) {
    assert(
    !kIsWeb ||
        (kIsWeb &&
            configuration.onSuccessAuth != null &&
            configuration.onError != null &&
            configuration.onCancel != null),
    'You must set onSuccessAuth, onError and onCancel function when running on Web otherwise you will not get any result.');
    final oauthFlow = BaseOAuthFlow()
      ..initOAuth(
        configuration: configuration,
      );
    oauthFlow.onNavigateTo(OAuthWebAuth.instance.appBaseUrl);
    return null;
  }

  late final BuildContext context;
  final GlobalKey<OAuthWebViewState> globalKey;
  final OAuthConfiguration configuration;

  OAuthWebScreen({
    Key? key,
    GlobalKey<OAuthWebViewState>? globalKey,
    required this.configuration,
  })  : globalKey = globalKey ?? GlobalKey<OAuthWebViewState>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        this.context = context;
        return Scaffold(
          body: SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: WillPopScope(
              onWillPop: onBackPressed,
              child: OAuthWebView(
                key: globalKey,
                configuration: configuration.copyWith(
                  onSuccessAuth: _onSuccess,
                  onError: _onError,
                  onCancel: _onCancel,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSuccess(Credentials credentials) {
    Navigator.pop(context, credentials);
    configuration.onSuccessAuth?.call(credentials);
  }

  void _onError(dynamic error) {
    Navigator.pop(context, error);
    configuration.onError?.call(error);
  }

  void _onCancel() {
    Navigator.pop(context);
    configuration.onCancel?.call();
  }

  Future<bool> onBackPressed() async {
    if (!((await globalKey.currentState?.onBackPressed()) ?? false)) {
      return false;
    }
    configuration.onCancel?.call();
    return true;
  }
}
