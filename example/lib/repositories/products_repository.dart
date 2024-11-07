import 'dart:io';

import 'package:strawti_utils/strawti_utils.dart';

class ProductsRepository extends StrautilsTryThis {
  FStrautilsResponse<List<String>> getAllProducts() async {
    return tryThis(
      () async {
        var data = [1, 2, 3, 5];
        data.shuffle();

        if (data.first == 1) {
          return StrautilsResponse.error(
            "Uma mensagem de erro retornada da API",
          );
        }

        if (data.first == 2) {
          return StrautilsResponse.warning(
            "Você precisa especificar o usuário",
          );
        }

        if (data.first == 3) {
          throw const SocketException("Sem internet");
        }

        return StrautilsResponse.success([""]);
      },
      tryAgain: () => getAllProducts(),
      action: 'Buscar produtos',
    );
  }
}
