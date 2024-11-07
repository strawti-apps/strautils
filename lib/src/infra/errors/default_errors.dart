import 'dart:developer';

class StrautilsDefaultErrors {
  static String unknowError(String action, [Object? error, StackTrace? stack]) {
    log("Action: $action => $error ($stack)", name: "StrautilsDefaultErrors");
    return 'Ocorreu um erro ao tentar $action';
  }

  static const socketException =
      'Problemas na conexão com o servidor. Verifique a sua internet';
  static const noSuchMethodError = 'Alguma informação não veio como o esperado';
  static const timeoutException =
      'O tempo máximo foi atingido. Tente novamente mais tarde';
  static const formatException = 'Algo veio em um formato inesperado';
}
