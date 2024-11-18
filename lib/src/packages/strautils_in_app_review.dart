import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:strawti_utils/src/infra/models/response_model.dart';

/// Melhores práticas
/// Peça uma classificação somente depois que as pessoas demonstrarem engajamento com seu aplicativo ou jogo. Por exemplo, você pode solicitar às pessoas quando elas concluírem um nível do jogo ou uma tarefa significativa. Evite pedir uma classificação no primeiro lançamento ou durante a integração, porque as pessoas não tiveram tempo suficiente para obter uma compreensão clara do valor do seu aplicativo ou formar uma opinião. As pessoas podem até estar mais propensas a deixar um feedback negativo se sentirem que um aplicativo está pedindo uma classificação antes que tenham a chance de usá-lo.
/// Evite interromper as pessoas enquanto elas estão realizando uma tarefa ou jogando um jogo. Pedir feedback pode atrapalhar a experiência do usuário e parecer um fardo. Procure por pausas naturais ou pontos de parada no seu aplicativo ou jogo onde uma solicitação de classificação tem menos probabilidade de ser incômoda.
///
/// Evite importunar as pessoas. Solicitações repetidas de classificação podem ser irritantes e podem até mesmo influenciar negativamente a opinião das pessoas sobre seu aplicativo. Considere permitir pelo menos uma ou duas semanas entre as solicitações, solicitando novamente após as pessoas demonstrarem engajamento adicional com sua experiência.
class StrautilsInAppReview {
  StrautilsInAppReview._();

  static final StrautilsInAppReview instance = StrautilsInAppReview._();

  final inAppReview = InAppReview.instance;

  GetStorage get storage => GetStorage(toString());

  int? get _lastRequest {
    if (requestAt == null) return null;

    return requestAt!.difference(DateTime.now()).inDays.abs();
  }

  String? _appStoreId;
  DateTime? requestAt;

  Future<void> initialize({
    /// Required for iOS & MacOS.
    String? appStoreId,
  }) async {
    await GetStorage.init(toString());

    _appStoreId = appStoreId;
    await storage.write('appStoreId', _appStoreId);

    if (storage.read('requestAt') != null) {
      requestAt = DateTime.fromMillisecondsSinceEpoch(
        storage.read('requestAt'),
      );
    }
  }

  Future<bool> isAvailable() async {
    if ((await inAppReview.isAvailable()) == false) {
      return false;
    }

    if (_lastRequest != null && _lastRequest! <= 30) {
      log(
        "Sua última solicitação foi há $_lastRequest dias",
        name: "StrautilsInAppReview",
      );
      return false;
    }

    return true;
  }

  /// Solicita a avaliação do usuário.
  /// Consulte a documentação para saber mais:
  ///
  /// Apple:
  /// [https://developer.apple.com/design/human-interface-guidelines/ios/system-capabilities/ratings-and-reviews/]
  ///
  /// Android:
  /// [https://developer.android.com/guide/playcore/in-app-review#when-to-request]
  /// [https://developer.android.com/guide/playcore/in-app-review#design-guidelines]
  ///
  ///
  /// [NÃO FUNCIONA EM AMBIENTE DE TESTE].
  /// Para testar consulte:
  /// https://pub.dev/packages/in_app_review#testing-read-carefully
  ///
  ///
  /// Na primeira chamada o dialog aparecerá para o usuário avaliar o app.
  /// Após a primeira chamada, apenas depois de 30 dias será mostrado novamente.
  /// Como alternativa o [inAppReview.openStoreListing] será chamado para abrir na loja da plataforma.
  Future<StrautilsResponse> requestReview() async {
    if (kDebugMode) {
      return StrautilsResponse.error(
        "Não é possível consultar popup de avaliação em modo debug",
      );
    }

    if (!(await isAvailable())) {
      await inAppReview.openStoreListing(appStoreId: _appStoreId);

      return StrautilsResponse.warning(
        "Avaliação dentro do app indisponível!",
      );
    }

    await inAppReview.requestReview();
    await storage.write(
      "requestAt",
      DateTime.now().millisecondsSinceEpoch,
    );

    return StrautilsResponse.success(null);
  }

  @override
  String toString() => "StrautilsInAppReview";
}
