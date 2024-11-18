import 'dart:developer';

/// Mensagens de erros padronizadas!
/// Padrões criados para:
/// [SocketException]
/// [NoSuchMethodError]
/// [TimeoutException]
/// [FormatException]
/// 
/// Mais um [StrautilsDefaultErrors.unknowError]
class StrautilsDefaultErrors {

  /// [action] é a ação que está sendo feita. Ex. 'fazer login'
  static String unknowError(String action, [Object? error, StackTrace? stack]) {
    log("Action: $action => $error ($stack)", name: "StrautilsDefaultErrors");
    return 'Não foi possível $action';
  }

  static const socketException =
      'Problemas na conexão com o servidor. Verifique a sua internet';
  static const noSuchMethodError = 'Alguma informação não veio como o esperado';
  static const timeoutException =
      'O tempo máximo foi atingido. Tente novamente mais tarde';
  static const formatException = 'Algo veio em um formato inesperado';
}
