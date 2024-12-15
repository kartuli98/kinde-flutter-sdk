package com.example.kinde_flutter_sdk_android

import ApiClient
import GrantType
import Serializer.gson
import Store
import TokenApi
import TokenRepository
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Base64.URL_SAFE
import android.util.Base64.decode
import androidx.activity.ComponentActivity
import androidx.activity.result.contract.ActivityResultContracts
import androidx.appcompat.app.AppCompatActivity
import au.kinde.sdk.api.OAuthApi
import au.kinde.sdk.api.model.UserProfileV2
import au.kinde.sdk.callApi
import au.kinde.sdk.keys.Keys
import au.kinde.sdk.utils.ClaimDelegate.getClaim
import com.example.kinde_flutter_sdk_android.models.KindeClientOptions
import com.google.gson.Gson
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import net.openid.appauth.AuthState
import net.openid.appauth.AuthorizationException
import net.openid.appauth.AuthorizationRequest
import net.openid.appauth.AuthorizationResponse
import net.openid.appauth.AuthorizationService
import net.openid.appauth.AuthorizationServiceConfiguration
import net.openid.appauth.CodeVerifierUtil
import net.openid.appauth.EndSessionRequest
import net.openid.appauth.EndSessionResponse
import net.openid.appauth.ResponseTypeValues
import net.openid.appauth.TokenRequest
import retrofit2.Call
import java.math.BigInteger
import java.security.KeyFactory
import java.security.Signature
import java.security.spec.RSAPublicKeySpec
import kotlin.concurrent.thread

const val SDK_VERSION : String = "1.2.3"

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
  private var loginResult: Result? = null
  private var logoutResult: Result? = null


  private lateinit var serviceConfiguration: AuthorizationServiceConfiguration
  private lateinit var state: AuthState
  private var store: Store? = null
  private var tokenRepository: TokenRepository? = null
  private var oAuthApi: OAuthApi? = null
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
        Uri.parse(LOGOUT_URL.format(kindeOptions.domain)),
      )


      state = AuthState(serviceConfiguration)

      store = Store(activity!!, kindeOptions.domain)

      apiClient = ApiClient(HTTPS.format(kindeOptions.domain), authNames = arrayOf(BEARER_AUTH))

      tokenRepository = TokenRepository(apiClient!!.createService(TokenApi::class.java), SDK_VERSION)
      oAuthApi = apiClient!!.createService(OAuthApi::class.java)

      result.success(true);
    } catch (e: Exception) {
      result.error(e.toString(), null, null);
    }
  }

  override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
    Log.i("ANDROID DEBUG", "onAttachedToActivity")
    this.activity = activityPluginBinding.activity
    activityPluginBinding.addActivityResultListener(this);
  }

  override fun onDetachedFromActivityForConfigChanges() {
    Log.i("ANDROID DEBUG", "onDetachedFromActivityForConfigChanges")
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {
    Log.i("ANDROID DEBUG", "onReattachedToActivityForConfigChanges")
    activity = p0.activity
    p0.addActivityResultListener(this);
  }

  override fun onDetachedFromActivity() {
    Log.i("ANDROID DEBUG", "onDetachedFromActivity")
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
      "login" -> login(call, result)
      "register" -> register(call)
      "isAuthenticate" -> isAuthenticate(result)
      "initialize" -> initialize(call, result)
      "getToken" -> getToken(call, result)
      "logout" -> logout(result)
      "getUserProfile" -> getUserProfileV2(result)
//      "createKindeClient" -> createKindeClient(call)
      else -> result.notImplemented()
    }
  }

  private fun getUserProfileV2(result: Result) {
    thread {
      val userProfile = callApi(oAuthApi!!.getUserProfileV2());
      if (userProfile != null) {
        val gson = Gson()
        result.success(gson.toJson(userProfile))
      } else {
        result.error("no user", "", "")
      }
    }
  }

  private fun <T> callApi(call: Call<T>, refreshed: Boolean = false): T? {
    val (data, exception) = call.callApi(state, refreshed = refreshed)
    if (data != null) {
      return data
    }
    if (exception != null) {
      if (exception is TokenExpiredException) {
        if (getToken(state.createTokenRefreshRequest())) {
          return callApi(call.clone(), refreshed = true)
        }
      } else {
        //todo
//        sdkListener.onException(exception)
      }
    }
    return null
  }

  private fun register(call: MethodCall) {
    auth(
      arguments = call.arguments,
      additionalParams = mapOf(REGISTRATION_PAGE_PARAM_NAME to REGISTRATION_PAGE_PARAM_VALUE)
    )
  }

  private fun login(call: MethodCall, result: Result) {
    loginResult = result
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
      val type: GrantType? = if (arguments["type"] != null) GrantType.valueOf(arguments["type"] as String) else null
      val orgCode: String? = arguments["orgCode"] as String?
      val loginHint: String? = arguments["loginHint"] as String?
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

      // Extract and set login_hint if it's provided in additionalParams and is not empty.
      loginHint?.takeIf { it.isNotEmpty() }?.let {
        authRequestBuilder.setLoginHint(it)
      }
      val authRequest: AuthorizationRequest = authRequestBuilder
        .setNonce(null)
        .setScopes(kindeOptions.scopes)
        .build()

      val authIntent = authService!!.getAuthorizationRequestIntent(authRequest)
      activity!!.startActivityForResult(authIntent, ActivityRequestCodes.REQUEST_CODE_LOGIN)
    } catch (e: Exception) {
      Log.e("ANDROID DEBUG", e.toString())
    }
  }

    private fun isAuthenticate(result: Result): Unit {
      result.success(state.isAuthorized && checkToken())
    }

  private fun checkToken(): Boolean {
    if (isTokenExpired(au.kinde.sdk.model.TokenType.ACCESS_TOKEN)) {
      getToken(state.createTokenRefreshRequest())
    }
    if (state.isAuthorized) {
      store?.getKeys()?.let { keysString ->
        try {
          Gson().fromJson(keysString, Keys::class.java)?.let { keys ->
            keys.keys.firstOrNull()?.let { key ->
              val jwt = state.accessToken.orEmpty()

              val exponentB: ByteArray = decode(key.exponent, URL_SAFE)
              val modulusB: ByteArray = decode(key.modulus, URL_SAFE)
              val bigExponent = BigInteger(1, exponentB)
              val bigModulus = BigInteger(1, modulusB)
              val publicKey = KeyFactory.getInstance(key.keyType)
                .generatePublic(RSAPublicKeySpec(bigModulus, bigExponent))
              val signedData: String = jwt.substring(0, jwt.lastIndexOf("."))
              val signatureB64u: String =
                jwt.substring(jwt.lastIndexOf(".") + 1, jwt.length)
              val signature: ByteArray = decode(signatureB64u, URL_SAFE)
              val sig: Signature = Signature.getInstance("SHA256withRSA")
              sig.initVerify(publicKey)
              sig.update(signedData.toByteArray())
              return sig.verify(signature)
            }
          }
        } catch (ex: Exception) {
//          sdkListener.onException(ex)
        }
      }
    }
    return false
  }

  private fun isTokenExpired(tokenType: au.kinde.sdk.model.TokenType): Boolean {
    val expClaim = getClaim("exp", tokenType)
    if (expClaim.value != null) {
      val expireEpochMillis = (expClaim.value as Long) * 1000
      val currentTimeMillis = System.currentTimeMillis()

      if (currentTimeMillis > expireEpochMillis) {
        return true
      }
    }
    return false
  }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
      Log.i("ANDROID DEBUG", "requestCode: $requestCode, resultCode: $resultCode")
      when (requestCode) {
        ActivityRequestCodes.REQUEST_CODE_LOGIN -> loginActivityResult(resultCode, data)
        ActivityRequestCodes.REQUEST_CODE_LOGOUT -> logoutActivityResult(resultCode, data)
      }
      return false
  }

  private fun loginActivityResult(resultCode: Int, data: Intent?) {
    if (resultCode == AppCompatActivity.RESULT_CANCELED && data != null) {
      val ex = AuthorizationException.fromIntent(data)
      ex?.let {
        loginResult?.error("auth-exception", ex.errorDescription, null)
      }
    }

    if (resultCode == AppCompatActivity.RESULT_OK && data != null) {
      val resp = AuthorizationResponse.fromIntent(data)
      val ex = AuthorizationException.fromIntent(data)
      state.update(resp, ex)
      store!!.saveState(state.jsonSerializeString())
        resp?.let {
          thread {
            val token = getTokenAndReturnIt(resp.createTokenExchangeRequest())
            loginResult?.success(token);
            loginResult = null;
          }
        }
      ex?.let {
        loginResult?.error("auth-exception", ex.errorDescription, null)
        loginResult = null;
      }
    } else {
      loginResult = null;
    }
  }

  private fun logoutActivityResult(resultCode: Int, data: Intent?) {
    if (resultCode == ComponentActivity.RESULT_OK && data != null) {
      val ex = AuthorizationException.fromIntent(data)

      ex?.let {
        // Handle error case if exception exists
        logoutResult?.error("logout-exception", "${it.error} ${it.errorDescription}", null)
      } ?: run {
        // Success case: clear bearer token and state
        apiClient?.setBearerToken("")
        store?.clearState()
        logoutResult?.success(true)
      }
    } else {
      // Result not OK or data is null
      logoutResult?.success(false)
    }

    // Reset logoutResult at the end, reducing repetition
    logoutResult = null
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getToken(call: MethodCall, result: Result) {

  }

  override fun getToken(tokenType: TokenType): String? =
    if (tokenType == TokenType.ACCESS_TOKEN) state.accessToken else state.idToken



  private fun getToken(tokenRequest: TokenRequest): Boolean {
    Log.i("ANDROID DEBUG", "getToken")
    val (resp, ex) = tokenRepository!!.getToken(
      authState = state,
      tokenRequest = tokenRequest
    )
    if (resp != null) {
      Log.i("ANDROID DEBUG", "getToken resp: $resp")
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
      logout(null)
    }
    return resp != null
  }

  private fun getTokenAndReturnIt(tokenRequest: TokenRequest): String? {
    Log.i("ANDROID DEBUG", "getTokenAndReturnIt")
    val (resp, ex) = tokenRepository!!.getToken(
      authState = state,
      tokenRequest = tokenRequest
    )
    if (resp != null) {
      state.update(resp, ex)
      apiClient?.setBearerToken(state.accessToken.orEmpty())
      store?.saveState(state.jsonSerializeString())
      return state.accessToken;
    }
    return null;
  }

  private fun logout(result: Result?) {
    logoutResult = result
    try {
      // Create the EndSessionRequest
      val endSessionRequest = EndSessionRequest.Builder(serviceConfiguration)
        .setPostLogoutRedirectUri(Uri.parse(kindeOptions.logoutUri))
        .setAdditionalParameters(mapOf(REDIRECT_PARAM_NAME to kindeOptions.logoutUri))
        .setState(null)
        .build()

      // Create the intent to handle the end session
      val endSessionIntent = authService!!.getEndSessionRequestIntent(endSessionRequest)
      activity!!.startActivityForResult(endSessionIntent, ActivityRequestCodes.REQUEST_CODE_LOGOUT)
    } catch (e: Exception) {
      // Log the exception and return an error result
      Log.e("ANDROID DEBUG", "Logout failed", e)
      result?.error("logout-error", "Logout failed: ${e.message}", null)
    }
  }


}

object ActivityRequestCodes {
  const val REQUEST_CODE_LOGIN = 1001
  const val REQUEST_CODE_SIGNUP = 1002
  const val REQUEST_CODE_LOGOUT = 1002
}
