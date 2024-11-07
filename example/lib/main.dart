import 'package:example/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:strawti_utils/strawti_utils.dart';

import 'repositories/products_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _repository = LoginRepository();

  Future<void> login() async {
    var response = await _repository.login("email", "password");

    setState(() {
      message = response.message;
    });

    if (response.error || response.warning) {
      setState(() {
        message = "Tentando novamente!";
      });

      response = await response.tryAgain();
    }

    setState(() {
      message = response.message;
    });
  }

  String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Clique no botão para fazer um teste:',
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            StrautilsResponseFutureBuilder(
              futureResponse: ProductsRepository().getAllProducts(),
              // Opcional
              errorBuilder: (
                context,
                error,
                message,
                isResponseError,
                tryAgain,
              ) {
                return Column(
                  children: [
                    Text("$message => $error"),
                    TextButton(
                      onPressed: tryAgain,
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                );
              },
              // Opcional
              loadingBuilder: (context) => const CircularProgressIndicator(),
              // Opcional
              warningBuilder: (context, message, tryAgain) {
                return Column(
                  children: [
                    Text(message),
                    TextButton(
                      onPressed: tryAgain,
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                );
              },
              // Opcional
              emptyBuilder: (context) => const Text("Sem produtos"),
              // Requerido
              builder: (context, products) {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(products[index]),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => login(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
