class KindeClientOptions {
  final String?  audience;
  final String?  client_id;
  final String  redirect_uri;
  final String  domain;
  final bool?  isDangerouslyUseLocalStorage;
  final String?  logout_uri;
  // al Function(ErrorProps)? get onErrorCallback;
  // al Function(KindeUser, Map<String, dynamic>?)? onRedirectCallback;
  List<String> scopes;
  final String? proxy_redirect_uri;
  final String? framework;
  final String? framework_version;

  KindeClientOptions({
   this.  audience,
   this.  client_id,
   required this. redirect_uri,
   required this. domain,
   this.  isDangerouslyUseLocalStorage,
   this.  logout_uri,
   required this. scopes,
   this. proxy_redirect_uri,
   this. framework,
   this. framework_version,
  });

  Map<String, dynamic> toJson() => {
    if(audience != null)
      "audience": audience,
    if(client_id != null)
      "client_id": client_id,
    "redirect_uri": redirect_uri,
    "domain": domain,
    if(isDangerouslyUseLocalStorage != null)
      "isDangerouslyUseLocalStorage": isDangerouslyUseLocalStorage,
    if(logout_uri != null)
      "logout_uri": logout_uri,
    "scopes": scopes,
    if(proxy_redirect_uri != null)
      "proxy_redirect_uri": proxy_redirect_uri,
    if(framework != null)
      "framework": framework,
    if(framework_version != null)
      "framework_version": framework_version,
  };
}
