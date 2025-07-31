import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';

import 'package:strawti_utils/src/infra/errors/default_errors.dart';
import 'package:strawti_utils/src/infra/models/response_model.dart';

typedef TryThisFunction<T> = FStrautilsResponse<T> Function();

/// StrautilsTryThis é uma interface para ser utilizada principalmente
/// em Repositórios.
/// [TryThisFunction] é FStrautilsResponse<T> Function().
/// [callback] é o que você deseja executar.
/// Implemente o [onCatch] caso queira um retorno diferente.
/// Informe o que você está tentando fazer no [action].
/// Caso queira uma nova tentativa, implemente o [tryAgain].
/// Exemplo:
/// ```dart
/// class LoginRepository extends StrautilsTryThis {
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
/// [SocketException], [NoSuchMethodError], [TimeoutException], [FormatException],
/// [ArgumentError], [RangeError], [StateError], [UnsupportedError],
/// [ConcurrentModificationError], [OutOfMemoryError] e [HttpException].
/// Caso o [onCatch] for null, um [StrautilsResponse.error] é retornado por padrão.
/// As mensagens retornadas são definidas em [StrautilsDefaultErrors].
abstract class StrautilsTryThis {
  FStrautilsResponse<T> tryThis<T>(
    TryThisFunction<T> callback, {
    StrautilsResponse<T> Function(Object error)? onCatch,
    TryThisFunction<T>? tryAgain,
    String action = "realizar operação",
  }) async {
    try {
      return await callback();
    } on SocketException catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.socketException,
        error: error,
        tryAgain: tryAgain,
      );
    } on NoSuchMethodError catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.noSuchMethodError,
        error: error,
        tryAgain: tryAgain,
      );
    } on TimeoutException catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.timeoutException,
        error: error,
        tryAgain: tryAgain,
      );
    } on FormatException catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.formatException,
        error: error,
        tryAgain: tryAgain,
      );
    } on ArgumentError catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.argumentError,
        error: error,
        tryAgain: tryAgain,
      );
    } on StateError catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.stateError,
        error: error,
        tryAgain: tryAgain,
      );
    } on UnsupportedError catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.unsupportedError,
        error: error,
        tryAgain: tryAgain,
      );
    } on ConcurrentModificationError catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.concurrentModificationError,
        error: error,
        tryAgain: tryAgain,
      );
    } on OutOfMemoryError catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.outOfMemoryError,
        error: error,
        tryAgain: tryAgain,
      );
    } on HttpException catch (error) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.httpException,
        error: error,
        tryAgain: tryAgain,
      );
    } catch (error, stack) {
      if (onCatch != null) {
        log("onCatch => $error ($stack)", name: "StrautilsTryThis");
        return onCatch(error);
      }

      return StrautilsResponse.error(
        StrautilsDefaultErrors.unknowError(action, error, stack),
        error: error,
        tryAgain: tryAgain,
      );
    }
  }
}
