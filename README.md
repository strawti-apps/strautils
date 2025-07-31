# Strawti Utils

Uma biblioteca Flutter/Dart que fornece utilitários e componentes padronizados
para desenvolvimento de aplicações, incluindo gerenciamento de respostas,
widgets reutilizáveis, validadores e integrações com funcionalidades nativas.

## 📦 Instalação

Adicione a dependência ao seu `pubspec.yaml`:

```yaml
dependencies:
  strawti_utils: ^1.1.0
```

Execute:

```bash
flutter pub get
```

### Importação

O package oferece diferentes arquivos de export:

```dart
// Importação completa
import 'package:strawti_utils/strawti_utils.dart';

// Apenas utilitários básicos
import 'package:strawti_utils/utils.dart';

// Apenas infraestrutura
import 'package:strawti_utils/infra.dart';
```

## 🚀 Funcionalidades

### 📋 Modelo de Resposta Padronizado

Sistema unificado para gerenciar respostas de operações assíncronas com suporte
a retry automático.

### 🎨 Widgets Reutilizáveis

Componentes Flutter otimizados para casos de uso comuns.

### ✅ Validadores

Funções de validação prontas para uso em formulários.

### 🔧 Helpers

Utilitários para operações comuns como manipulação de datas.

### 📱 Integrações Nativas

- **In-App Review**: Solicitação de avaliações na loja
- **In-App Update**: Atualizações automáticas do aplicativo

### 🛡️ Tratamento de Erros

Sistema robusto de tratamento de exceções com mensagens padronizadas.

## 📚 Documentação Detalhada

### 1. Modelo de Resposta (`StrautilsResponse`)

O `StrautilsResponse<T>` é o coração do sistema, fornecendo uma estrutura
padronizada para todas as operações assíncronas.

#### Tipos de Resposta

- `success`: Operação realizada com sucesso
- `warning`: Aviso (dados podem estar disponíveis)
- `error`: Erro na operação

#### Exemplo de Uso

```dart
class UserRepository extends StrautilsTryThis {
  FStrautilsResponse<User> getUser(String id) async {
    return tryThis(() async {
      // Sua lógica aqui
      final user = await api.getUser(id);
      return StrautilsResponse.success(user);
    },
    tryAgain: () => getUser(id),
    action: "buscar usuário",
    );
  }
}
```

#### Propriedades Principais

- `data`: Dados retornados pela operação
- `message`: Mensagem para exibição na UI
- `tryAgain`: Função para nova tentativa
- `success`, `error`, `warning`: Getters para verificar status

### 2. Widget Response Future Builder

Widget especializado para trabalhar com `StrautilsResponse` de forma
declarativa.

#### Exemplo Básico

```dart
StrautilsResponseFutureBuilder<User>(
  futureResponse: userRepository.getUser(id),
  builder: (context, user) {
    return UserCard(user: user);
  },
  loadingBuilder: (context) => CircularProgressIndicator(),
  errorBuilder: (context, error, message, tryAgain) {
    return ErrorWidget(
      message: message,
      onRetry: tryAgain,
    );
  },
  emptyBuilder: (context) => Text("Usuário não encontrado"),
)
```

#### Configurações Avançadas

- `maxAttempts`: Número máximo de tentativas (padrão: 3)
- `onMaxAttempts`: Callback quando limite de tentativas é atingido
- `warningBuilder`: Widget para exibir avisos

### 3. Validadores

#### Email

```dart
final emailError = validateEmail(
  emailController.text,
  emptyMessage: "Email é obrigatório",
  invalidMessage: "Email inválido",
);
```

#### Nome

```dart
final nameError = validateName(
  nameController.text,
  emptyMessage: "Nome é obrigatório",
  invalidMessage: "Nome deve ter pelo menos 2 caracteres",
);
```

#### Username

```dart
final usernameError = validateUsername(
  usernameController.text,
  emptyMessage: "Username é obrigatório",
  invalidMessage: "Username deve ter 3-20 caracteres alfanuméricos",
);
```

### 4. Helpers

#### DateTime Helper

```dart
// Data atual sem horário
final today = StrautilsDateTimeHelper.nowWithoutTime;

// Comparar apenas datas
final isSameDate = StrautilsDateTimeHelper.isEqualDate(date1, date2);

// Comparar apenas horários
final isSameTime = StrautilsDateTimeHelper.isEqualTime(time1, time2);

// Comparar data e hora completas
final isSameDateTime = StrautilsDateTimeHelper.isEqualDateTime(dt1, dt2);
```

#### Ternary Clean

```dart
// Ao invés de operador ternário complexo
Widget widget = ternaryClean(
  isLoggedIn,
  caseTrue: UserProfile(),
  caseFalse: LoginButton(),
);
```

### 5. In-App Review

Sistema inteligente para solicitar avaliações seguindo as melhores práticas.

#### Configuração

```dart
await StrautilsInAppReview.instance.initialize(
  appStoreId: "123456789", // Obrigatório para iOS
);
```

#### Uso

```dart
final response = await StrautilsInAppReview.instance.requestReview();
if (response.success) {
  print("Avaliação solicitada com sucesso");
}
```

#### Características

- Respeita intervalo de 30 dias entre solicitações
- Fallback para loja de aplicativos
- Não funciona em modo debug (segurança)

### 6. In-App Update

Sistema de atualizações automáticas para Android.

#### Atualização Imediata

```dart
final response = await StrautilsInAppUpdate().updateApp(
  performImmediateUpdate: true,
);
```

#### Atualização Flexível

```dart
final response = await StrautilsInAppUpdate().updateApp(
  startFlexibleUpdate: true,
);
```

#### Características

- Disponível apenas no Android
- Suporte a atualizações flexíveis e imediatas
- Verificação automática de disponibilidade

### 7. Tratamento de Erros

#### StrautilsTryThis

Interface para repositórios com tratamento automático de exceções.

```dart
class ProductRepository extends StrautilsTryThis {
  FStrautilsResponse<List<Product>> getProducts() async {
    return tryThis(() async {
      final products = await api.getProducts();
      return StrautilsResponse.success(products);
    },
    tryAgain: () => getProducts(),
    action: "buscar produtos",
    );
  }
}
```

#### Exceções Tratadas

- `SocketException`: Problemas de conexão
- `NoSuchMethodError`: Dados inesperados
- `TimeoutException`: Timeout de operações
- `FormatException`: Formato inválido
- `ArgumentError`: Argumentos inválidos
- `RangeError`: Índice fora do intervalo
- `StateError`: Estado inválido
- `UnsupportedError`: Operação não suportada
- `ConcurrentModificationError`: Modificação concorrente
- `OutOfMemoryError`: Memória insuficiente
- `HttpException`: Erro de comunicação HTTP

#### Mensagens Padronizadas

```dart
// Erro genérico
StrautilsDefaultErrors.unknowError("fazer login");

// Erros específicos
StrautilsDefaultErrors.socketException;
StrautilsDefaultErrors.timeoutException;
StrautilsDefaultErrors.formatException;
StrautilsDefaultErrors.argumentError;
StrautilsDefaultErrors.stateError;
StrautilsDefaultErrors.httpException;
```

## 🎯 Casos de Uso Comuns

### 1. Lista com Loading e Error States

```dart
StrautilsResponseFutureBuilder<List<Product>>(
  futureResponse: productRepository.getProducts(),
  builder: (context, products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  },
  loadingBuilder: (context) => ProductListSkeleton(),
  errorBuilder: (context, error, message, tryAgain) {
    return RetryWidget(
      message: message,
      onRetry: tryAgain,
    );
  },
  emptyBuilder: (context) => EmptyProductsWidget(),
)
```

### 2. Formulário com Validação

```dart
class LoginForm extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            validator: (value) => validateEmail(value),
            decoration: InputDecoration(labelText: "Email"),
          ),
          TextFormField(
            validator: (value) => validateName(value),
            decoration: InputDecoration(labelText: "Nome"),
          ),
          ElevatedButton(
            onPressed: () => _submitForm(),
            child: Text("Entrar"),
          ),
        ],
      ),
    );
  }
}
```

### 3. Repositório com Retry

```dart
class UserRepository extends StrautilsTryThis {
  FStrautilsResponse<User> createUser(User user) async {
    return tryThis(() async {
      final createdUser = await api.createUser(user);
      return StrautilsResponse.success(createdUser);
    },
    tryAgain: () => createUser(user),
    action: "criar usuário",
    );
  }
}
```

## 🔧 Configuração

### Dependências

O package utiliza as seguintes dependências:

- `get_storage`: Armazenamento local
- `in_app_review`: Avaliações in-app
- `in_app_update`: Atualizações in-app

### Permissões (Android)

Para In-App Updates, adicione ao `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
```

## 🧪 Testes

O package inclui testes para os principais componentes:

```bash
flutter test
```

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## 🤝 Contribuição

Contribuições são bem-vindas! Por favor, leia as diretrizes de contribuição
antes de submeter um pull request.

## 📞 Suporte

Para dúvidas ou problemas, abra uma issue no repositório do projeto.
