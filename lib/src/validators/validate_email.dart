/// RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$")
String? validateEmail(
  String? value, {
  String emptyMessage = "Campo obrigátorio!",
  String invalidMessage = "O email informado é inválido!",
}) {
  if (value?.trim().isEmpty ?? true) {
    return emptyMessage;
  }

  final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$");
  if (regex.hasMatch(value!) == false) {
    return invalidMessage;
  }

  return null;
}
