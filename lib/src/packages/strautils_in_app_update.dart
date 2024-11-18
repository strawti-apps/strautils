import 'dart:io';

import 'package:in_app_update/in_app_update.dart';
import 'package:strawti_utils/strawti_utils.dart';

class StrautilsInAppUpdate {
  StrautilsInAppUpdate._();

  static final StrautilsInAppUpdate instance = StrautilsInAppUpdate._();

  Future<StrautilsResponse> verify({
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

      if (performImmediateUpdate) {
        var result = await InAppUpdate.performImmediateUpdate();

        if (result == AppUpdateResult.userDeniedUpdate) {
          return StrautilsResponse.warning(
            "Atualização Negada ou Cancelada pelo Usuário.",
          );
        }

        return StrautilsResponse.success(
          null,
          message: "Atualização Realizada!",
        );
      }

      if (startFlexibleUpdate) {
        var result = await InAppUpdate.startFlexibleUpdate();

        if (result == AppUpdateResult.userDeniedUpdate) {
          return StrautilsResponse.warning(
            "Atualização Negada ou Cancelada pelo Usuário.",
          );
        }

        if (result == AppUpdateResult.success) {
          await InAppUpdate.completeFlexibleUpdate();

          return StrautilsResponse.success(
            null,
            message: "Atualização Realizada!",
          );
        }
      }

      return StrautilsResponse.error(
        StrautilsDefaultErrors.unknowError("fazer a atualização"),
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
