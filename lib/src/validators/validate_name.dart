/// RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ]+(?: [A-Za-zÀ-ÖØ-öø-ÿ]+)*$")
String? validateName(
  String? value, {
  String emptyMessage = "Campo obrigátorio!",
  String invalidMessage = "O nome informado é inválido!",
}) {
  if (value?.trim().isEmpty ?? true) {
    return emptyMessage;
  }

  final regex = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ]+(?: [A-Za-zÀ-ÖØ-öø-ÿ]+)*$");
  if (regex.hasMatch(value!) == false) {
    return invalidMessage;
  }

  return null;
}
