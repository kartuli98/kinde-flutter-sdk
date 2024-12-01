package com.example.kinde_flutter_sdk_android

import ApiClient
import GrantType
import Store
import TokenApi
import TokenRepository
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import com.example.kinde_flutter_sdk_android.models.KindeClientOptions
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import net.openid.appauth.AuthState
import net.openid.appauth.AuthorizationException
import net.openid.appauth.AuthorizationRequest
import net.openid.appauth.AuthorizationResponse
import net.openid.appauth.AuthorizationService
import net.openid.appauth.AuthorizationServiceConfiguration
import net.openid.appauth.CodeVerifierUtil
import net.openid.appauth.EndSessionRequest
import net.openid.appauth.ResponseTypeValues
import net.openid.appauth.TokenRequest

object BuildConfig {
  const val DEBUG: Boolean = false
  const val LIBRARY_PACKAGE_NAME: String = "au.kinde.sdk"
  const val BUILD_TYPE: String = "release"
  const val SDK_VERSION: String = "1.2.3"
}

enum class TokenType {
  ID_TOKEN, ACCESS_TOKEN
}

interface TokenProvider {
  fun getToken(tokenType: TokenType): String?
}

/** KindeFlutterSdkAndroidPlugin */
class KindeFlutterSdkAndroidPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener, TokenProvider {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  private var context: Context? = null


  private lateinit var serviceConfiguration: AuthorizationServiceConfiguration
  private lateinit var state: AuthState
  private var store: Store? = null
  private var tokenRepository: TokenRepository? = null
  private var apiClient: ApiClient? = null

  private lateinit var kindeOptions: KindeClientOptions;

  private var authService: AuthorizationService? = null


  companion object {
    private const val DOMAIN_KEY = "au.kinde.domain"
    private const val CLIENT_ID_KEY = "au.kinde.clientId"
    private const val AUDIENCE_KEY = "audience"

    private const val AUTH_URL = "https://%s/oauth2/auth"
    private const val TOKEN_URL = "https://%s/oauth2/token"
    private const val LOGOUT_URL = "https://%s/logout"
    private const val REDIRECT_URI_SCHEME = "kinde.sdk://"

    private const val REGISTRATION_PAGE_PARAM_NAME = "start_page"
    private const val REGISTRATION_PAGE_PARAM_VALUE = "registration"
    private const val AUDIENCE_PARAM_NAME = "audience"
    private const val CREATE_ORG_PARAM_NAME = "is_create_org"
    private const val ORG_NAME_PARAM_NAME = "org_name "
    private const val ORG_CODE_PARAM_NAME = "org_code"
    private const val REDIRECT_PARAM_NAME = "redirect"

    private const val HTTPS = "https://%s/"
    private const val BEARER_AUTH = "kindeBearerAuth"
    private const val LOGIN_HINT = "jdoe@user.example.com"
    private val DEFAULT_SCOPES = listOf("openid", "offline", "email", "profile")
// todo consider option with isInitialized field
//    var isInitialized = AtomicBoolean(false)
  }

  private fun initialize(call: MethodCall, result: Result) {
    try {
      val arguments = call.arguments as Map<String, Any>
      kindeOptions = KindeClientOptions.fromMap(arguments)

      serviceConfiguration = AuthorizationServiceConfiguration(
        Uri.parse(AUTH_URL.format(kindeOptions.domain)),
        Uri.parse(TOKEN_URL.format(kindeOptions.domain)),
        null,
      )


      state = AuthState(serviceConfiguration)

      store = Store(activity!!, kindeOptions.domain)

      apiClient = ApiClient(HTTPS.format(kindeOptions.domain), authNames = arrayOf(BEARER_AUTH))

      tokenRepository = TokenRepository(apiClient!!.createService(TokenApi::class.java), BuildConfig.SDK_VERSION)

      result.success(true);
    } catch (e: Exception) {
      result.error(e.toString(), null, null);
    }
  }

  override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
    Log.i("ANDROID DEBUG", "onAttachedToActivity")
    // TODO: your plugin is now attached to an Activity
    this.activity = activityPluginBinding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    Log.i("ANDROID DEBUG", "onDetachedFromActivityForConfigChanges")
    // TODO: the Activity your plugin was attached to was destroyed to change configuration.
    // This call will be followed by onReattachedToActivityForConfigChanges().
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {
    Log.i("ANDROID DEBUG", "onReattachedToActivityForConfigChanges")
    // TODO: your plugin is now attached to a new Activity after a configuration change.
    activity = p0.activity
  }

  override fun onDetachedFromActivity() {
    Log.i("ANDROID DEBUG", "onDetachedFromActivity")
    // TODO: your plugin is no longer associated with an Activity. Clean up references.
    activity = null
  }

 //  The onAttachedToEngine method is called when the plugin is first associated with the Flutter engine, setting up the
 //  communication channel between Dart and native code
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.i("ANDROID DEBUG", "onAttachedToEngine")
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "kinde_flutter_sdk_android")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    authService = AuthorizationService(context!!)

    val stateJson = store?.getState()
     if ( !stateJson.isNullOrEmpty()) {
        state = AuthState.jsonDeserialize(stateJson)
    }
  }



  // MethodCallHandler override method
  override fun onMethodCall(call: MethodCall, result: Result) {
    Log.i("ANDROID DEBUG", "onMethodCall: ${call.method}")
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "login" -> login(call)
      "register" -> register(call)
      "isAuthenticate" -> isAuthenticate(result)
      "initialize" -> initialize(call, result)
      "getToken" -> getToken(call, result)
      "logout" -> logout()
//      "createKindeClient" -> createKindeClient(call)
      else -> result.notImplemented()
    }
  }

  private fun register(call: MethodCall) {
    auth(
      arguments = call.arguments,
      additionalParams = mapOf(REGISTRATION_PAGE_PARAM_NAME to REGISTRATION_PAGE_PARAM_VALUE)
    )
  }

  private fun login(call: MethodCall) {
    auth(
      arguments = call.arguments,
      additionalParams = mapOf()
    )
    }

  private fun auth(
    arguments: Any,
    additionalParams: Map<String, String>) {
    try {
      arguments as Map<*, *>
      Log.d("ANDROID Debug", "0")
      val type: GrantType? = if (arguments["type"] != null) GrantType.valueOf(arguments["type"] as String) else null
      Log.d("ANDROID Debug", "type = $type")
      val orgCode: String? = arguments["orgCode"] as String?
      Log.d("ANDROID Debug", "orgCode = $orgCode")
      val loginHint: String? = arguments["loginHint"] as String?
      Log.d("ANDROID Debug", "loginHint = $loginHint")
      Log.d("ANDROID Debug", "1")
      val verifier =
        if (type == GrantType.PKCE) CodeVerifierUtil.generateRandomCodeVerifier() else null
      val authRequestBuilder = AuthorizationRequest.Builder(
        serviceConfiguration, // the authorization service configuration
        kindeOptions.clientId, // the client ID, typically pre-registered and static
        ResponseTypeValues.CODE, // the response_type value: we want a code
        Uri.parse(kindeOptions.redirectUri)
      )
        .setCodeVerifier(verifier)
        .setAdditionalParameters(
          buildMap {
            putAll(additionalParams)
            kindeOptions.audience?.let {
              put(AUDIENCE_PARAM_NAME, kindeOptions.audience)
            }
            orgCode?.let {
              put(ORG_CODE_PARAM_NAME, orgCode)
            }
          }
        )

      Log.d("ANDROID Debug", "2")

      // Extract and set login_hint if it's provided in additionalParams and is not empty.
      loginHint?.takeIf { it.isNotEmpty() }?.let {
        authRequestBuilder.setLoginHint(it)
      }

      Log.d("ANDROID Debug", "3")
      val authRequest: AuthorizationRequest = authRequestBuilder

//        .setNonce(null)
        .setScopes(kindeOptions.scopes)
        .build()

      Log.d("ANDROID Debug", "authRequest: ${authRequest.toUri()}")

      Log.d("ANDROID Debug", "authService is null: ${authService == null}")

      val authIntent = authService!!.getAuthorizationRequestIntent(authRequest)
      Log.d("ANDROID Debug", "activity is null: ${activity == null}")
      activity!!.startActivity(authIntent)
    } catch (e: Exception) {
      Log.e("ANDROID DEBUG", e.toString())
    }
  }

    private fun isAuthenticate(result: Result): Unit {
      result.success(state.isAuthorized)
    }
//      && checkToken()

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
      Log.i("ANDROID DEBUG", "resultCode: $resultCode")
      if (resultCode == AppCompatActivity.RESULT_CANCELED && data != null) {
        val ex = AuthorizationException.fromIntent(data)
        ex?.let {
//          sdkListener.onException(LogoutException("${ex.errorDescription}"))
        }
      }

      if (resultCode == AppCompatActivity.RESULT_OK && data != null) {
        val resp = AuthorizationResponse.fromIntent(data)
        val ex = AuthorizationException.fromIntent(data)
        state.update(resp, ex)
        store!!.saveState(state.jsonSerializeString())
//        resp?.let {
//          thread {
//            getToken(resp.createTokenExchangeRequest())
//          }
//        }
        ex?.let {
//          sdkListener.onException(AuthException("${ex.error} ${ex.errorDescription}"))
        }
      }
      return  false
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun getToken(tokenType: TokenType): String? =
    if (tokenType == TokenType.ACCESS_TOKEN) state.accessToken else state.idToken

  private fun getToken(call: MethodCall, result: Result) {

  }

  private fun getToken(tokenRequest: TokenRequest): Boolean {
    val (resp, ex) = tokenRepository!!.getToken(
      authState = state,
      tokenRequest = tokenRequest
    )
    if (resp != null) {
      val tokenNotExists = state.accessToken.isNullOrEmpty()
      state.update(resp, ex)
      apiClient?.setBearerToken(state.accessToken.orEmpty())
      store?.saveState(state.jsonSerializeString())
      if (tokenNotExists) {
//        sdkListener.onNewToken(state.accessToken.orEmpty())
      }
    } else {
      ex?.let {
//        sdkListener.onException(TokenException("${ex.error} ${ex.errorDescription}"))
      }
      logout()
    }
    return resp != null
  }

  private fun logout() {
    val endSessionRequest = EndSessionRequest.Builder(serviceConfiguration)
      .setPostLogoutRedirectUri(Uri.parse(kindeOptions.logoutUri))
      .setAdditionalParameters(mapOf(REDIRECT_PARAM_NAME to kindeOptions.logoutUri))
      .setState(null)
      .build()
    val endSessionIntent = authService!!.getEndSessionRequestIntent(endSessionRequest)
    activity!!.startActivity(endSessionIntent)

    apiClient!!.setBearerToken("")
//    sdkListener.onLogout()
    store!!.clearState()
  }

}
