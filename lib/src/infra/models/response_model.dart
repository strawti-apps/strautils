import 'dart:developer';

enum StrautilsResponseTypes { success, warning, error }

typedef FStrautilsResponse<T> = Future<StrautilsResponse<T>>;

/// StrautilsResponse é um modelo padrão para respostas.
/// Use o tipo [FStrautilsResponse<T>] para diminiuir o excesso.
final class StrautilsResponse<T> {
  /// Possíveis status de retorno [StrautilsResponseTypes].
  /// success, warning ou error.
  final StrautilsResponseTypes status;

  /// Qualquer coisa que queira passar adiante independente do status [StrautilsResponseTypes].
  final T? data;

  /// Mensagem que deseja passar adiante para mostrar na UI.
  final String message;

  /// Função que executa o código novamente.
  /// Exemplo:
  /// ```dart
  /// class LoginRepository {
  ///    FStrautilsResponse<UserModel> signInWithEmailAndPassword(
  ///       String email, String password,
  ///    ) async {
  ///       try {
  ///           ...
  ///          return StrautilsResponse.success(data);
  ///       } catch(error) {
  ///          return StrautilsResponse.error(
  ///            'Não foi possível realizar operação. Tente novamente!',
  ///            tryAgain: () => signInWithEmailAndPassword(email, password)
  ///          );
  ///       }
  ///    }
  /// }
  /// ```
  final FStrautilsResponse<T> Function() tryAgain;

  /// status é [StrautilsResponseTypes.success].
  bool get success => status == StrautilsResponseTypes.success;

  /// status é [StrautilsResponseTypes.error].
  bool get error => status == StrautilsResponseTypes.error;

  /// status é [StrautilsResponseTypes.warning].
  bool get warning => status == StrautilsResponseTypes.warning;

  StrautilsResponse({
    required this.status,
    required this.data,
    required this.message,
    required this.tryAgain,
  });

  /// status é [StrautilsResponseTypes.success].
  /// tryAgain retorna [StrautilsResponse.success] por padrão.
  factory StrautilsResponse.success(T data, {String message = ''}) {
    log("$message => $data", name: "StrautilsResponse.success");
    return StrautilsResponse(
      data: data,
      status: StrautilsResponseTypes.success,
      message: message,
      tryAgain: () async => StrautilsResponse.success(
        data,
        message: message,
      ),
    );
  }

  /// status é [StrautilsResponseTypes.warning].
  /// tryAgain retorna [StrautilsResponse.error] caso seja null.
  factory StrautilsResponse.warning(
    String message, {
    dynamic data,
    Future<StrautilsResponse<T>> Function()? tryAgain,
  }) {
    log("$message => $data", name: "StrautilsResponse.warning");
    return StrautilsResponse(
      data: data,
      status: StrautilsResponseTypes.warning,
      message: message,
      tryAgain: () async {
        if (tryAgain == null) {
          return StrautilsResponse.error(
            "Função de tentativa não implementada",
          );
        }

        return await tryAgain();
      },
    );
  }

  /// status é [StrautilsResponseTypes.error].
  /// tryAgain retorna [StrautilsResponse.error] caso seja null.
  factory StrautilsResponse.error(
    String message, {
    dynamic data,
    Future<StrautilsResponse<T>> Function()? tryAgain,
    Object? error,
  }) {
    log("$message => $error", name: "StrautilsResponse.error");
    return StrautilsResponse(
      data: data,
      status: StrautilsResponseTypes.error,
      message: message,
      tryAgain: () async {
        if (tryAgain == null) {
          return StrautilsResponse.error(
            "Função de tentativa não implementada",
          );
        }

        return await tryAgain();
      },
    );
  }

  @override
  String toString() {
    return "StrautilsResponse(message: $message, status: $status, data: $data)";
  }
}
