import 'package:kinde_flutter_sdk_platform_interface/platform.dart';

import 'auth_config.dart';

const _defaultScopes = ['openid', 'profile', 'email', 'offline'];

class KindeFlutterSDK {

  static KindeFlutterSDK? _instance;

  static KindeFlutterSDK get instance {
    _instance ??= KindeFlutterSDK._internal();
    return _instance ?? KindeFlutterSDK._internal();
  }

  KindeFlutterSDK._internal() {
    // if (_config == null) {
    //   throw KindeError('KindeFlutterSDK have not been configured');
    // }
    //
    // var domainUrl = "";
    // if (_config!.authDomain.startsWith('https')) {
    //   domainUrl = _config!.authDomain;
    // } else if (_config!.authDomain.startsWith('http')) {
    //   domainUrl = _config!.authDomain.replaceFirst('http', "https");
    // } else {
    //   domainUrl = 'https://${_config!.authDomain}';
    // }
    //
    // _serviceConfiguration = AuthorizationServiceConfiguration(
    //     authorizationEndpoint: '$domainUrl$_authPath',
    //     tokenEndpoint: '$domainUrl$_tokenPath',
    //     endSessionEndpoint: '$domainUrl$_logoutPath');
    //
    // Dio dio = Dio(BaseOptions(
    //   baseUrl: domainUrl,
    // ));
    //
    // _kindeApi = KindeApi(dio: dio, interceptors: [
    //   BearerAuthInterceptor(),
    //   RefreshTokenInterceptor(
    //     dio: dio,
    //     refreshToken: getToken,
    //   ),
    // ]);
    // _keysApi = KeysApi(_kindeApi.dio);
    // _tokenApi = TokenApi(_kindeApi.dio);
    //
    // if (_store.keys == null) {
    //   _keysApi.getKeys().then((value) {
    //     _store.keys = value;
    //   });
    // }
    //
    // var token = authState?.accessToken;
    // if (token != null) {
    //   _kindeApi.setBearerAuth(_bearerAuth, token);
    // }
  }

  static AuthConfig? _config;
  static KindeClient? _kindeClient;

  static Future<void> initializeSDK(
      {required String authDomain,
        required String authClientId,
        required String loginRedirectUri,
        required String logoutRedirectUri,
        List<String> scopes = _defaultScopes,
        String? audience}) async {
    _kindeClient = await KindeFlutterSdkPlatform.instance.createKindeClient(
        KindeClientOptions(
            redirect_uri: loginRedirectUri,
            logout_uri: logoutRedirectUri,
            client_id: authClientId,
            domain: authDomain, scopes: scopes)
    );
    // _config = AuthConfig(
    //     authDomain: authDomain,
    //     authClientId: authClientId,
    //     loginRedirectUri: loginRedirectUri,
    //     logoutRedirectUri: logoutRedirectUri,
    //     scopes: scopes,
    //     audience: audience);
    //
    // secure_store.FlutterSecureStorage secureStorage =
    // const secure_store.FlutterSecureStorage(
    //     aOptions: secure_store.AndroidOptions());
    //
    // Future<List<int>> getSecureKey(
    //     secure_store.FlutterSecureStorage secureStorage) async {
    //   var containsEncryptionKey =
    //   await secureStorage.containsKey(key: 'encryptionKey');
    //   if (!containsEncryptionKey) {
    //     var key = Hive.generateSecureKey();
    //     await secureStorage.write(
    //         key: 'encryptionKey', value: base64UrlEncode(key));
    //     return key;
    //   } else {
    //     final base64 = await secureStorage.read(key: 'encryptionKey');
    //     return base64Url.decode(base64!);
    //   }
    // }

    // final secureKey = await getSecureKey(secureStorage);
    //
    // final path = await getTemporaryDirectory();
    //
    // await Store.init(HiveAesCipher(secureKey), path.path);
  }

  Future<String?> getPlatformVersion() {
    return KindeFlutterSdkPlatform.instance.getPlatformVersion();
  }

  Future<bool> logout() async {
    assert(_kindeClient != null, "firstly call initializeSDK() method");
    return KindeFlutterSdkPlatform.instance.logout(_kindeClient!);
  }

  Future<String?> login({
    AuthFlowType? type,
    String? orgCode,
    String? loginHint,
    AuthUrlParams? authUrlParams,
  }) async {
    assert(_kindeClient != null, "firstly call initializeSDK() method");
    return KindeFlutterSdkPlatform.instance.login(_kindeClient!);
  }

  Future<void> register({
    AuthFlowType? type,
    String? orgCode,
    String? loginHint,
    AuthUrlParams? authUrlParams,
  }) {
    return KindeFlutterSdkPlatform.instance.register();
  }

  Future<bool> isAuthenticate() async {
    assert(_kindeClient != null, "firstly call initializeSDK() method");
    return KindeFlutterSdkPlatform.instance.isAuthenticate(_kindeClient!);
  }

  Future<UserProfileV2?> getUserProfileV2() async {
    assert(_kindeClient != null, "firstly call initializeSDK() method");
    return KindeFlutterSdkPlatform.instance.getUserProfileV2(_kindeClient!);
  }

  Future<String?> getToken() => KindeFlutterSdkPlatform.instance.getToken();
}
