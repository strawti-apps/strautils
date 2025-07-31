// RegExp(r"^(?!.*\.\.)(?!.*\.$)[a-zA-Z0-9._]{1,30}$")
String? validateUsername(
  String? value, {
  String emptyMessage = "Campo obrigatório!",
  String invalidMessage = "O username informado é inválido!",
  bool allowToEndWithAPeriod = false,
  bool allowToStartWithAPeriod = false,
  int maxLength = 30,
}) {
  if (value?.trim().isEmpty ?? true) {
    return emptyMessage;
  }

  if (value!.length > maxLength) {
    return invalidMessage;
  }

  if (allowToEndWithAPeriod) {
    if (value.endsWith('.')) {
      value = value.substring(0, value.length - 1);
    }
  }

  if (allowToStartWithAPeriod) {
    if (value.startsWith('.')) {
      value = value.substring(1, value.length);
    }
  }

  final regex = RegExp(r"^(?!.*\.\.)(?!\.)(?!.*\.$)[a-zA-Z0-9._]{1,30}$");
  if (!regex.hasMatch(value)) {
    return invalidMessage;
  }

  return null;
}
