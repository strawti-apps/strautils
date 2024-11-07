import 'package:strawti_utils/strawti_utils.dart';

class LoginRepository extends StrawtiUtisTryThis {
  FStrautilsResponse<String> login(String email, String password) async {
    return tryThis(
      () async {
        return StrautilsResponse.success('token');
      },
      tryAgain: () => login(email, password),
      action: 'fazer login',
    );
  }
}
