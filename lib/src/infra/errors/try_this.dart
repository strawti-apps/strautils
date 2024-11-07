import 'dart:async';
import 'dart:io';

import 'package:strawti_utils/src/infra/errors/default_errors.dart';
import 'package:strawti_utils/src/infra/models/response_model.dart';

typedef TryThisFunction<T> = FStrautilsResponse<T> Function();

/// StrawtiUtisTryThis é uma interface para ser utilizada principalmente
/// em Repositórios.
/// [TryThisFunction] é FStrautilsResponse<T> Function().
/// [callback] é o que você deseja executar.
/// Implemente o [onCatch] caso queira um retorno diferente.
/// Informe o que você está tentando fazer no [action].
/// Caso queira uma nova tentativa, implemente o [tryAgain].
/// Exemplo:
/// ```dart
/// class LoginRepository extends StrawtiUtisTryThis {
///   FStrautilsResponse<UserModel> login(String email, String password) {
///      return await tryThis(() {
///          ...
///          return StrautilsResponse.success(data);
///      },
///      tryAgain: () => login(email, password),
///      );
///   }
/// }
/// ```
/// Os tratamentos são feitos para:
/// [SocketException], [NoSuchMethodError], [TimeoutException] e [FormatException].
/// Caso o [onCatch] for null, um [StrautilsResponse.error] é retornado por padrão.
/// As mensagens retornadas são definidas em [StrautilsDefaultErrors].
abstract class StrawtiUtisTryThis {
  FStrautilsResponse<T> tryThis<T>(
    TryThisFunction<T> callback, {
    TryThisFunction<T>? onCatch,
    TryThisFunction<T>? tryAgain,
    String action = "realizar operação",
  }) async {
    try {
      return await callback();
    } on SocketException {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.socketException,
        tryAgain: tryAgain,
      );
    } on NoSuchMethodError {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.noSuchMethodError,
        tryAgain: tryAgain,
      );
    } on TimeoutException {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.timeoutException,
        tryAgain: tryAgain,
      );
    } on FormatException {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.timeoutException,
        tryAgain: tryAgain,
      );
    } catch (error, stack) {
      if (onCatch != null) {
        return onCatch();
      }

      return StrautilsResponse.error(
        StrautilsDefaultErrors.unknowError(action, error, stack),
        tryAgain: tryAgain,
      );
    }
  }
}
