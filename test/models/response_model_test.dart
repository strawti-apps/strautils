import 'package:strawti_utils/strawti_utils.dart';
import 'package:test/test.dart';

void main() {
  group("Testes do StrautilsResponse<T>", () {
    test("Deve retornar success como verdadeiro e data como string", () {
      var response = StrautilsResponse.success("Certo");

      expect(response.success, isTrue);
      expect(response.data, isNotEmpty);
    });

    test("Deve retornar warning como verdadeiro e data como null", () {
      var response = StrautilsResponse.warning("Aviso");

      expect(response.warning, isTrue);
      expect(response.data, isNull);
    });

    test("Deve retornar error como verdadeiro e data como null", () {
      var response = StrautilsResponse.error("Erro");

      expect(response.error, isTrue);
      expect(response.data, isNull);
    });
  });
}
