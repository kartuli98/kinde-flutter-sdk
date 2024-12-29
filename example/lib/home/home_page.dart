import 'package:example/constants.dart';
import 'package:example/home/components/home_body.dart';
import 'package:example/home/components/home_footer.dart';
import 'package:example/home/components/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinde_flutter_sdk/kinde_flutter_sdk.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var kindeClient = KindeFlutterSDK.instance;

  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<UserProfileV2?> _profile = ValueNotifier(null);
  final ValueNotifier<bool> _loggedIn = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    kindeClient.isAuthenticate().then((value) {
      _loggedIn.value = value;
      if (value) {
        _getProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.viewPaddingOf(context).top,
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.viewPaddingOf(context).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListenableBuilder(
                listenable: Listenable.merge([_loading, _profile]),
                builder: (context, _) {
                  return HomeHeader(
                      profile: _profile.value,
                      loading: _loading.value,
                      onLogin: _signIn,
                      onLogout: _signOut,
                      onRegister: _signUp);
                }),
            Expanded(
              child: SizedBox(
                child: ValueListenableBuilder(
                    valueListenable: _loggedIn,
                    builder: (context, isLoggedIn, __) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            verticalSpaceMedium,
                            HomeBody(loggedIn: isLoggedIn),
                            const HomeFooter(),
                          ],
                        ),
                      );
                    }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _signIn() {
    kindeClient.login(type: AuthFlowType.pkce).then((token) {
      print("Flutter App Debug: login() => token: $token");
      if (token != null) {
        _loggedIn.value = true;
        _getProfile();
      }
    });
  }

  _signOut() {
    print("Flutter App Debug: logout()");
    kindeClient.logout().then((value) {
      if(value) {
        _loggedIn.value = false;
        _profile.value = null;
      }
    }).onError((error, _) {
      print(error);
    });
  }

  _signUp() {
    kindeClient.register();
  }

  _getProfile() {
    _loading.value = true;
    kindeClient.getUserProfileV2().then((profile) async {
      _profile.value = profile;
    }).whenComplete(() => _loading.value = false);
  }
}
