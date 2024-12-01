import '../internal/kinde_js.dart' as kinde_js;
import 'package:kinde_flutter_sdk_platform_interface/platform.dart';

abstract class KindeWebMappers {
  static _KindeClientMapper get client => _KindeClientMapper._();
  static _KindeClientOptionsMapper get options => _KindeClientOptionsMapper._();
  static _KindeUserMapper get user => _KindeUserMapper._();
}

class _KindeClientMapper {
  const _KindeClientMapper._();

  KindeClient fromWeb(kinde_js.KindeClient web) {
    return KindeClient(
      token: web.token,
      idToken: web.idToken,
      isAuthenticated: web.isAuthenticated,
      login: web.login,
      getUser: web.getUser,
      logout: web.logout
    );
  }

}

class _KindeClientOptionsMapper {
  const _KindeClientOptionsMapper._();

  KindeClientOptions fromWeb(kinde_js.KindeClientOptions web) {
    return KindeClientOptions(
      audience: web.audience,
      client_id: web.client_id,
      redirect_uri: web.redirect_uri,
      domain: web.domain,
      isDangerouslyUseLocalStorage: web.isDangerouslyUseLocalStorage,
      logout_uri: web.logout_uri,
      scopes: web.scope?.split(" ") ?? [],
      proxy_redirect_uri: web.proxy_redirect_uri,
      framework: web.framework,
      framework_version: web.framework_version
    );
  }

  kinde_js.KindeClientOptions toWeb(KindeClientOptions options) {
    return kinde_js.KindeClientOptions(
      audience: options.audience,
      client_id: options.client_id,
      redirect_uri: options.redirect_uri,
      domain: options.domain,
      //todo
      isDangerouslyUseLocalStorage: options.isDangerouslyUseLocalStorage ?? false,
      logout_uri: options.logout_uri,
      scope: options.scopes.join(" "),
      proxyRedirectUri: options.proxy_redirect_uri,
      framework: options.framework,
      frameworkVersion: options.framework_version
    );
  }

}

class _KindeUserMapper {
  const _KindeUserMapper._();

  KindeUser fromWeb(kinde_js.KindeUser web) {
    return KindeUser(givenName: web.given_name,
      id: web.id,
      familyName: web.family_name,
      email: web.email,
      picture: web.picture
    );
  }

}
