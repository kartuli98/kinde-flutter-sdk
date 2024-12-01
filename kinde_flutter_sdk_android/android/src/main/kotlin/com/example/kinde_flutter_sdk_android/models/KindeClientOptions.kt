package com.example.kinde_flutter_sdk_android.models

import java.io.Serializable

data class KindeClientOptions(
  val audience: String? = null,
  val clientId: String,
  val redirectUri: String,
  val domain: String,
  val isDangerouslyUseLocalStorage: Boolean? = null,
  val logoutUri: String? = null,
  val scopes: List<String>,
  val proxyRedirectUri: String? = null,
  val framework: String? = null,
  val frameworkVersion: String? = null
): Serializable {
  companion object {
    fun fromMap(map: Map<String, Any>): KindeClientOptions {
      return KindeClientOptions(
        audience = map["audience"] as? String,
        clientId = map["client_id"] as String,
        redirectUri = map["redirect_uri"] as? String ?: throw IllegalArgumentException("redirect_uri is required"),
        domain = map["domain"] as? String ?: throw IllegalArgumentException("domain is required"),
        isDangerouslyUseLocalStorage = map["isDangerouslyUseLocalStorage"] as? Boolean,
        logoutUri = map["logout_uri"] as? String,
        scopes = map["scopes"] as List<String>? ?: listOf("openid", "offline", "email", "profile"),
        proxyRedirectUri = map["proxy_redirect_uri"] as? String,
        framework = map["framework"] as? String,
        frameworkVersion = map["framework_version"] as? String
      )
    }
  }
}

