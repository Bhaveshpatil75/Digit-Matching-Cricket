import 'package:fcc/services/auth/auth_providerr.dart';
import 'package:fcc/services/auth/auth_user.dart';

class AuthService implements AuthProviderr{
  final AuthProviderr authProviderr;

  AuthService(this.authProviderr);

  @override
  Future<AuthUser> createUser({required email, required password}) {
    return authProviderr.createUser(email: email, password: password);
  }

  @override

  AuthUser? get currentUser => authProviderr.currentUser;

  @override
  Future<AuthUser> logIn({required email, required password}) {
    return authProviderr.logIn(email: email, password: password);
  }

  @override
  Future<void> logOut() {
    return authProviderr.logOut();
  }

  @override
  Future<void> sendVerificationMail() {
    return authProviderr.sendVerificationMail();
  }

}