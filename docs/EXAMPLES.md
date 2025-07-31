# Exemplos Práticos - Strawti Utils

Este documento contém exemplos práticos e casos de uso reais do package
`strawti_utils`.

## 📦 Imports Recomendados

Para diferentes casos de uso, use os imports apropriados:

```dart
// Para repositórios e infraestrutura
import 'package:strawti_utils/infra.dart';

// Para utilitários básicos (helpers, ternários)
import 'package:strawti_utils/utils.dart';

// Para uso completo (incluindo widgets e validadores)
import 'package:strawti_utils/strawti_utils.dart';
```

## 📱 Exemplo Completo de Aplicação

### 1. Estrutura de Repositório

```dart
// lib/repositories/user_repository.dart
import 'package:strawti_utils/infra.dart';

class UserRepository extends StrautilsTryThis {
  final ApiService _api;

  UserRepository(this._api);

  FStrautilsResponse<User> getUser(String id) async {
    return tryThis(() async {
      final user = await _api.getUser(id);
      return StrautilsResponse.success(user);
    },
    tryAgain: () => getUser(id),
    action: "buscar usuário",
    );
  }

  FStrautilsResponse<List<User>> getUsers() async {
    return tryThis(() async {
      final users = await _api.getUsers();
      return StrautilsResponse.success(users);
    },
    tryAgain: () => getUsers(),
    action: "buscar usuários",
    );
  }

  FStrautilsResponse<User> createUser(User user) async {
    return tryThis(() async {
      final createdUser = await _api.createUser(user);
      return StrautilsResponse.success(
        createdUser,
        message: "Usuário criado com sucesso!",
      );
    },
    tryAgain: () => createUser(user),
    action: "criar usuário",
    );
  }
}
```

### 2. Tela de Lista de Usuários

```dart
// lib/screens/users_screen.dart
import 'package:flutter/material.dart';
import 'package:strawti_utils/strawti_utils.dart';

class UsersScreen extends StatelessWidget {
  final UserRepository _repository = UserRepository(ApiService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Usuários")),
      body: StrautilsResponseFutureBuilder<List<User>>(
        futureResponse: _repository.getUsers(),
        builder: (context, users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCard(user: users[index]);
            },
          );
        },
        loadingBuilder: (context) => UsersSkeleton(),
        errorBuilder: (context, error, message, tryAgain) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(message, textAlign: TextAlign.center),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: tryAgain,
                  child: Text("Tentar Novamente"),
                ),
              ],
            ),
          );
        },
        emptyBuilder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text("Nenhum usuário encontrado"),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 3. Formulário de Cadastro

```dart
// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:strawti_utils/strawti_utils.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nome Completo",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validateName(
                  value,
                  emptyMessage: "Nome é obrigatório",
                  invalidMessage: "Nome deve ter pelo menos 2 caracteres",
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validateEmail(
                  value,
                  emptyMessage: "Email é obrigatório",
                  invalidMessage: "Email inválido",
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Nome de Usuário",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validateUsername(
                  value,
                  emptyMessage: "Username é obrigatório",
                  invalidMessage: "Username deve ter 3-20 caracteres",
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Senha é obrigatória";
                  }
                  if (value!.length < 6) {
                    return "Senha deve ter pelo menos 6 caracteres";
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Cadastrar"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _createUser();
    }
  }

  void _createUser() {
    final user = User(
      name: _nameController.text,
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StrautilsResponseFutureBuilder<User>(
        futureResponse: UserRepository(ApiService()).createUser(user),
        builder: (context, createdUser) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuário criado com sucesso!")),
          );
          Navigator.of(context).pop();
          return Container();
        },
        loadingBuilder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Criando usuário..."),
            ],
          ),
        ),
        errorBuilder: (context, error, message, tryAgain) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Erro"),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _createUser();
                  },
                  child: Text("Tentar Novamente"),
                ),
              ],
            ),
          );
          return Container();
        },
      ),
    );
  }
}
```

### 4. Configuração de In-App Review

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:strawti_utils/strawti_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar In-App Review
  await StrautilsInAppReview.instance.initialize(
    appStoreId: "123456789", // Seu App Store ID
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _requestReview(context),
              child: Text("Avaliar App"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _checkForUpdates(context),
              child: Text("Verificar Atualizações"),
            ),
          ],
        ),
      ),
    );
  }

  void _requestReview(BuildContext context) async {
    final response = await StrautilsInAppReview.instance.requestReview();
    
    if (response.warning) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }
  }

  void _checkForUpdates(BuildContext context) async {
    final response = await StrautilsInAppUpdate().updateApp(
      startFlexibleUpdate: true,
    );

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Atualização iniciada!")),
      );
    } else if (response.warning) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro"),
          content: Text(response.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
```

### 5. Uso de Helpers

```dart
// lib/utils/date_utils.dart
import 'package:strawti_utils/utils.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    final today = StrautilsDateTimeHelper.nowWithoutTime;
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (StrautilsDateTimeHelper.isEqualDate(dateOnly, today)) {
      return "Hoje";
    }
    
    final yesterday = today.subtract(Duration(days: 1));
    if (StrautilsDateTimeHelper.isEqualDate(dateOnly, yesterday)) {
      return "Ontem";
    }
    
    return "${date.day}/${date.month}/${date.year}";
  }
  
  static bool isToday(DateTime date) {
    return StrautilsDateTimeHelper.isEqualDate(
      date,
      StrautilsDateTimeHelper.nowWithoutTime,
    );
  }
  
  static bool isSameTime(DateTime a, DateTime b) {
    return StrautilsDateTimeHelper.isEqualTime(a, b);
  }
}
```

### 6. Widget Condicional com Ternary Clean

```dart
// lib/widgets/conditional_widget.dart
import 'package:flutter/material.dart';
import 'package:strawti_utils/utils.dart';

class ConditionalWidget extends StatelessWidget {
  final bool isLoggedIn;
  final User? user;

  ConditionalWidget({
    required this.isLoggedIn,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Usando ternaryClean para widgets condicionais
        ternaryClean(
          isLoggedIn,
          caseTrue: UserProfileWidget(user: user!),
          caseFalse: LoginButton(),
        ),
        
        SizedBox(height: 16),
        
        // Outro exemplo
        ternaryClean(
          isLoggedIn && user != null,
          caseTrue: Text("Bem-vindo, ${user!.name}!"),
          caseFalse: Text("Faça login para continuar"),
        ),
        
        SizedBox(height: 16),
        
        // Múltiplas condições
        ternaryClean(
          isLoggedIn,
          caseTrue: Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 8),
              Text("Perfil"),
            ],
          ),
          caseFalse: Row(
            children: [
              Icon(Icons.login),
              SizedBox(width: 8),
              Text("Entrar"),
            ],
          ),
        ),
      ],
    );
  }
}
```

### 7. Tratamento de Erros Customizado

```dart
// lib/repositories/custom_repository.dart
import 'package:strawti_utils/infra.dart';

class CustomRepository extends StrautilsTryThis {
  FStrautilsResponse<Data> getData() async {
    return tryThis(() async {
      // Simular operação que pode falhar
      if (Random().nextBool()) {
        throw Exception("Erro aleatório");
      }
      
      return StrautilsResponse.success(Data());
    },
    tryAgain: () => getData(),
    action: "buscar dados",
    onCatch: (error) {
      // Tratamento customizado para exceções específicas
      if (error.toString().contains("aleatório")) {
        return StrautilsResponse.warning(
          "Tente novamente em alguns segundos",
          tryAgain: () => getData(),
        );
      }
      
      // Retorna null para usar o tratamento padrão
      return null;
    },
    );
  }
}
```

## 🎯 Padrões Recomendados

### 1. Estrutura de Repositórios

- Sempre estenda `StrautilsTryThis`
- Use `tryThis` para operações que podem falhar
- Implemente `tryAgain` para retry automático
- Use `action` descritivo para mensagens de erro

### 2. Uso de Widgets

- Use `StrautilsResponseFutureBuilder` para operações assíncronas
- Implemente builders customizados para melhor UX
- Configure `maxAttempts` apropriadamente
- Use `onMaxAttempts` para feedback ao usuário

### 3. Validação de Formulários

- Use os validadores fornecidos
- Customize mensagens de erro
- Combine múltiplos validadores quando necessário

### 4. In-App Features

- Configure In-App Review no `main()`
- Respeite as diretrizes da Apple/Google
- Teste em dispositivos reais (não em debug)

### 5. Tratamento de Erros

- Use mensagens padronizadas quando possível
- Implemente `onCatch` para casos específicos
- Forneça sempre uma opção de retry

## 🔧 Configurações Avançadas

### 1. Customização de Mensagens de Erro

```dart
// lib/constants/error_messages.dart
class ErrorMessages {
  static const String networkError = "Verifique sua conexão com a internet";
  static const String serverError = "Servidor indisponível no momento";
  static const String timeoutError = "Operação demorou muito, tente novamente";
  static const String unknownError = "Algo deu errado, tente novamente";
}
```

### 2. Configuração de Retry

```dart
class RetryConfig {
  static const int defaultMaxAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  static Future<void> delay() async {
    await Future.delayed(retryDelay);
  }
}
```

### 3. Logging Customizado

```dart
import 'dart:developer';

class CustomLogger {
  static void logError(String action, Object error, StackTrace? stack) {
    log(
      "Action: $action => $error",
      name: "CustomRepository",
      error: error,
      stackTrace: stack,
    );
  }
}
```

Estes exemplos demonstram como usar efetivamente o package `strawti_utils` em
aplicações reais, seguindo as melhores práticas e padrões recomendados.
