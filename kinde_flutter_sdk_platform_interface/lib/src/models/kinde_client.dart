import 'kinde_user.dart';

class KindeClient {
  final String token;
  final String  idToken;
  final dynamic isAuthenticated;
  final dynamic login;
  final dynamic getUser;
  final dynamic logout;

  const KindeClient({
    required this.token,
    required this.idToken,
    required this.isAuthenticated,
    required this.login,
    required this.getUser,
    required this.logout
  });
}
