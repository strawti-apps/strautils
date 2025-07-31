import 'dart:developer';

/// Mensagens de erros padronizadas!
/// Padrões criados para:
/// [SocketException]
/// [NoSuchMethodError]
/// [TimeoutException]
/// [FormatException]
/// [ArgumentError]
/// [RangeError]
/// [StateError]
/// [UnsupportedError]
/// [ConcurrentModificationError]
/// [OutOfMemoryError]
/// [StackOverflowError]
/// [HttpException]
/// [ClientException]
///
/// Mais um [StrautilsDefaultErrors.unknowError]
class StrautilsDefaultErrors {
  /// [action] é a ação que está sendo feita. Ex. 'fazer login'
  static String unknowError(String action, [Object? error, StackTrace? stack]) {
    log("Action: $action => $error ($stack)", name: "StrautilsDefaultErrors");
    return 'Não foi possível $action';
  }

  static const socketException = 'Problemas na conexão com o servidor. Verifique a sua internet';
  static const noSuchMethodError = 'Alguma informação não veio como o esperado';
  static const timeoutException = 'O tempo máximo foi atingido. Tente novamente mais tarde';
  static const formatException = 'Algo veio em um formato inesperado';
  static const argumentError = 'Um ou mais argumentos fornecidos são inválidos';
  static const stateError = 'O estado atual não permite esta operação';
  static const unsupportedError = 'Esta operação não é suportada';
  static const concurrentModificationError = 'Dados foram modificados durante o processamento';
  static const outOfMemoryError = 'Memória insuficiente para completar a operação';
  static const httpException = 'Erro na comunicação com o servidor';
}
