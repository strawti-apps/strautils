import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:strawti_utils/src/infra/models/response_model.dart';

/// StrautilsResponseFutureBuilder é um Widget que padroniza verificações
/// comuns feitas em um Future.
///
/// [futureResponse]: Específica o Future que será executado. Precisa ser do
/// tipo [FStrautilsResponse<T>] que nada mais é que um [Future<StrautilsResponse<T>>].
///
/// [builder]: retorna o objeto de resposta do seu [futureResponse]. Use-o
/// em seu Widget retornado.
///
/// [loadingBuilder]: Será chamado enquanto o [Snapshot.connectionState] for
/// [ConnectionState.waiting] ou [ConnectionState.none].
///
/// Caso [loadingBuilder] seja `null`. [CircularProgressIndicator] será
/// retornado.
///
/// [emptyBuilder]: Será chamado quando o retorno de [futureResponse] for
/// `isEmpty` or `isNull`;
///
/// Caso [emptyBuilder] seja `null`. `Text("Nada para mostrar!")` será retornado.
///
/// [errorBuilder]: Será chamado quando
class StrautilsResponseFutureBuilder<T> extends StatefulWidget {
  const StrautilsResponseFutureBuilder({
    super.key,
    required this.futureResponse,
    required this.builder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.warningBuilder,
    this.onMaxAttempts,
    this.maxAttempts = 3,
  });

  final int maxAttempts;
  final void Function(
    BuildContext context,
    int currentAttempt,
    int maxAttempts,
  )? onMaxAttempts;

  final FStrautilsResponse<T> futureResponse;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  final Widget Function(
    BuildContext context,
    Object? error,
    String message,
    void Function() tryAgain,
  )? errorBuilder;

  final Widget Function(
    BuildContext context,
    String message,
    void Function() tryAgain,
  )? warningBuilder;

  @override
  State<StrautilsResponseFutureBuilder<T>> createState() =>
      _ResponseFutureBuilderState<T>();
}

class _ResponseFutureBuilderState<T>
    extends State<StrautilsResponseFutureBuilder<T>> {
  Future<StrautilsResponse<T>>? future;

  @override
  void initState() {
    future = widget.futureResponse;
    super.initState();
  }

  int attempts = 1;
  void tryAgain(
    Future<StrautilsResponse<T>> Function()? callback,
  ) {
    if (attempts >= widget.maxAttempts) {
      if (widget.onMaxAttempts != null) {
        widget.onMaxAttempts!(context, attempts, widget.maxAttempts);
      }

      return;
    }

    future = callback != null ? callback() : widget.futureResponse;

    attempts += 1;
    setState(() {});
    log(
      "attempts: $attempts / ${widget.maxAttempts}",
      name: 'StrautilsResponseFutureBuilder',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StrautilsResponse<T>>(
      key: Key('$attempts'),
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            log(
              "Loading",
              name: "StrautilsResponseFutureBuilder",
            );

            if (widget.loadingBuilder != null) {
              return widget.loadingBuilder!(context);
            }

            return CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              log(
                "Iternal Error: ${snapshot.error}",
                name: "StrautilsResponseFutureBuilder",
              );

              if (widget.errorBuilder != null) {
                return widget.errorBuilder!(
                  context,
                  snapshot.error,
                  "Ocorreu um erro interno!",
                  () => tryAgain(null),
                );
              }

              return Text("Ocorreu um erro interno!");
            }

            var response = snapshot.data!;
            if (response.error) {
              log(
                "Response Error: $response",
                name: "StrautilsResponseFutureBuilder",
              );

              if (widget.errorBuilder != null) {
                return widget.errorBuilder!(
                  context,
                  snapshot.error,
                  response.message,
                  () => tryAgain(response.tryAgain),
                );
              }

              return Text(response.message);
            }

            if (response.warning) {
              log(
                "Response Warning: $response",
                name: "StrautilsResponseFutureBuilder",
              );

              if (widget.warningBuilder != null) {
                return widget.warningBuilder!(
                  context,
                  response.message,
                  () => tryAgain(response.tryAgain),
                );
              }

              return Text(response.message);
            }

            var data = response.data;
            print(data);

            if (data == null ||
                (data is List && data.isEmpty) ||
                (data is String && data.isEmpty)) {
              log("Data is Empty", name: 'StrautilsResponseFutureBuilder');
              if (widget.emptyBuilder != null) {
                return widget.emptyBuilder!(context);
              }

              return Text("Nada para mostrar!");
            }

            return widget.builder(context, response.data as T);
        }
      },
    );
  }
}
