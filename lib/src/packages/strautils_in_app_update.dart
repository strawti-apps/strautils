import 'dart:io';

import 'package:in_app_update/in_app_update.dart';
import 'package:strawti_utils/strawti_utils.dart';


/// Enables In App Updates on Android using the official Android APIs.
/// 
/// Atualizações flexíveis:
/// As atualizações flexíveis oferecem download e instalação em segundo plano com monitoramento otimizado do estado. Essa UX é adequada quando é aceitável que o usuário use o app durante o download da atualização. Por exemplo, você pode incentivar os usuários a testar um novo recurso que não é essencial para a funcionalidade principal do app.
/// 
/// Atualizações imediatas:
/// Atualizações imediatas são fluxos de UX de tela cheia que exigem que o usuário atualize e reinicie o app para continuar a usá-lo. Esse fluxo de UX é ideal para casos em que uma atualização é essencial para a funcionalidade principal do app. Depois que um usuário aceita uma atualização imediata, o Google Play processa a instalação da atualização e a reinicialização do app.
/// 
/// In App Updates are only available from API Versions >= 21.
/// 
/// More: [https://developer.android.com/guide/playcore/in-app-updates?hl=pt-br]
/// Be aware that this plugin cannot be tested locally. It must be installed via Google Play to work. Please check the official documentation about In App Updates from Google:
/// [https://developer.android.com/guide/playcore/in-app-updates/test]
class StrautilsInAppUpdate {
  Future<StrautilsResponse> updateApp({
    ///  Executa uma atualização imediata (tela cheia)
    bool performImmediateUpdate = false,

    /// Inicia uma atualização flexível (download em segundo plano)
    bool startFlexibleUpdate = false,
  }) async {
    try {
      if (!Platform.isAndroid) {
        return StrautilsResponse.error("Disponível apenas em Android");
      }

      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return StrautilsResponse.warning("Nenhuma atualização disponível!");
      }

      AppUpdateResult? result;

      if (performImmediateUpdate) {
        result = await InAppUpdate.performImmediateUpdate();
      } else if (startFlexibleUpdate) {
        result = await InAppUpdate.startFlexibleUpdate();
      }

      if (result == AppUpdateResult.success) {
        if (startFlexibleUpdate) {
          await InAppUpdate.completeFlexibleUpdate();
        }

        return StrautilsResponse.success(
          null,
          message: "Atualização Realizada!",
        );
      }

      return StrautilsResponse.error(
        result == AppUpdateResult.userDeniedUpdate
            ? "Atualização Negada ou Cancelada pelo Usuário."
            : StrautilsDefaultErrors.unknowError("fazer a atualização"),
      );
    } catch (error, stack) {
      return StrautilsResponse.error(
        StrautilsDefaultErrors.unknowError(
          "fazer a atualização",
          error,
          stack,
        ),
      );
    }
  }
}
