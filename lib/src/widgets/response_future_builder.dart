import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:strawti_utils/src/infra/models/response_model.dart';

class StrautilsResponseFutureBuilder<T> extends StatefulWidget {
  const StrautilsResponseFutureBuilder({
    super.key,
    required this.futureResponse,
    required this.builder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.warningBuilder,
  });

  final FStrautilsResponse<T> futureResponse;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  final Widget Function(
    BuildContext context,
    Object? error,
    String message,
    bool isResponseError,
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
    future = callback != null ? callback() : widget.futureResponse;

    attempts += 1;
    setState(() {});
    log("attempts: $attempts");
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
            if (widget.loadingBuilder != null) {
              return widget.loadingBuilder!(context);
            }

            return CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              if (widget.errorBuilder != null) {
                return widget.errorBuilder!(
                  context,
                  snapshot.error,
                  "Ocorreu um erro interno!",
                  false,
                  () => tryAgain(null),
                );
              }

              log(
                "Iternal Error: ${snapshot.error}",
                name: "ResponseFutureBuilder",
              );
              return Text("Ocorreu um erro interno!");
            }

            var response = snapshot.data!;
            if (response.error) {
              if (widget.errorBuilder != null) {
                return widget.errorBuilder!(
                  context,
                  snapshot.error,
                  response.message,
                  true,
                  () => tryAgain(response.tryAgain),
                );
              }

              log("Response Error: $response", name: "ResponseFutureBuilder");
              return Text(response.message);
            }

            if (response.warning) {
              if (widget.warningBuilder != null) {
                return widget.warningBuilder!(
                  context,
                  response.message,
                  () => tryAgain(response.tryAgain),
                );
              }

              log("Response Warning: $response", name: "ResponseFutureBuilder");
              return Text(response.message);
            }

            if (response.data == null ||
                response.data == [] ||
                response.data == '') {
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
