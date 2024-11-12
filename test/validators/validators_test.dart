import 'package:strawti_utils/src/validators/validate_email.dart';
import 'package:strawti_utils/src/validators/validate_name.dart';
import 'package:strawti_utils/src/validators/validate_username.dart';
import 'package:test/test.dart';

void main() {
  group("validateName", () {
    test("'ABC123' deve ser inválido!", () {
      expect(validateName("ABC123"), isA<String>());
    });

    test("'' deve ser inválido!", () {
      expect(validateName(""), isA<String>());
    });

    test("' ' deve ser inválido!", () {
      expect(validateName(" "), isA<String>());
    });

    test("'João da Silva' deve ser válido!", () {
      expect(validateName("João da Silva"), isNull);
    });

    test("'Maria Clara' deve ser válido!", () {
      expect(validateName("Maria Clara"), isNull);
    });

    test("'José' deve ser válido!", () {
      expect(validateName("José"), isNull);
    });

    test("'Ana' deve ser válido!", () {
      expect(validateName("Ana"), isNull);
    });

    test("'Ana' deve ser válido!", () {
      expect(validateName("Érico de Souza"), isNull);
    });
  });

  group("validateEmail", () {
    test("'' deve ser inválido!", () {
      expect(validateEmail(""), isA<String>());
    });

    test("' ' deve ser inválido!", () {
      expect(validateEmail(" "), isA<String>());
    });

    test("'nome' deve ser inválido!", () {
      expect(validateEmail("nome"), isA<String>());
    });

    test("'@' deve ser inválido!", () {
      expect(validateEmail("@"), isA<String>());
    });

    test("'nome.com' deve ser inválido!", () {
      expect(validateEmail("nome.com"), isA<String>());
    });

    test("'nome@dominio' deve ser inválido!", () {
      expect(validateEmail("nome@dominio"), isA<String>());
    });

    test("'@dominio.com' deve ser inválido!", () {
      expect(validateEmail("@dominio.com"), isA<String>());
    });

    test("'nome@.com' deve ser inválido!", () {
      expect(validateEmail("nome@.com"), isA<String>());
    });

    test("'nome@dominio..com' deve ser inválido!", () {
      expect(validateEmail("nome@dominio..com"), isA<String>());
    });

    test("'nome@dominio.com' deve ser válido!", () {
      expect(validateEmail("nome@dominio.com"), isNull);
    });
  });

  group("validateUsername", () {
    test("'' deve ser inválido!", () {
      expect(validateUsername(''), isA<String>());
    });

    test("' ' deve ser inválido!", () {
      expect(validateUsername(' '), isA<String>());
    });

    test("'user..name' deve ser inválido!", () {
      expect(validateUsername('user..name'), isA<String>());
    });

    test("'username.' deve ser inválido!", () {
      expect(validateUsername('username.'), isA<String>());
    });

    test("'.username' deve ser inválido!", () {
      expect(validateUsername('.username'), isA<String>());
    });

    test("'username12345678901234567890111' deve ser inválido!", () {
      expect(
          validateUsername('username12345678901234567890111'), isA<String>());
    });

    test("'username123' deve ser inválido!", () {
      expect(
        validateUsername('username123', maxLength: 10),
        isA<String>(),
      );
    });

    test("'username' deve ser válido!", () {
      expect(validateUsername('username'), isNull);
    });

    test("'user.name' deve ser válido!", () {
      expect(validateUsername('user.name'), isNull);
    });
    test("'user__name' deve ser válido!", () {
      expect(validateUsername('user__name'), isNull);
    });

    test("'username12' deve ser válido!", () {
      expect(
        validateUsername('username12', maxLength: 10),
        isNull,
      );
    });

    test("'username123456789123456789012345' deve ser válido!", () {
      expect(
        validateUsername('username123456789123456789012345', maxLength: 32),
        isNull,
      );
    });

    test("'.username' deve ser válido!", () {
      expect(
        validateUsername('.username', allowToStartWithAPeriod: true),
        isNull,
      );
    });

    test("'username.' deve ser válido!", () {
      expect(
        validateUsername('username.', allowToEndWithAPeriod: true),
        isNull,
      );
    });
  });
}
