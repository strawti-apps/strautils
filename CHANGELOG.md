# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em
[Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/), e este projeto
adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [1.0.0] - 2024-01-XX

### Adicionado

- **Modelo de Resposta Padronizado**
  - `StrautilsResponse<T>` - Modelo principal para respostas
  - `StrautilsResponseTypes` - Enum com tipos de resposta (success, warning,
    error)
  - `FStrautilsResponse<T>` - Type alias para Future<StrautilsResponse<T>>
  - Suporte a retry automático via função `tryAgain`
  - Getters `success`, `error`, `warning` para verificação de status

- **Widget Response Future Builder**
  - `StrautilsResponseFutureBuilder<T>` - Widget para trabalhar com respostas
  - Suporte a builders customizados (loading, error, empty, warning)
  - Sistema de retry automático com limite configurável
  - Callback `onMaxAttempts` para feedback ao usuário
  - Configuração de `maxAttempts` (padrão: 3)

- **Validadores**
  - `validateEmail()` - Validação de email com regex
  - `validateName()` - Validação de nome
  - `validateUsername()` - Validação de username
  - Mensagens customizáveis para campos vazios e inválidos

- **Helpers**
  - `StrautilsDateTimeHelper` - Utilitários para manipulação de datas
    - `nowWithoutTime` - Data atual sem horário
    - `isEqualDate()` - Compara apenas datas
    - `isEqualTime()` - Compara apenas horários
    - `isEqualDateTime()` - Compara data e hora completas
  - `ternaryClean<T>()` - Função para operadores ternários mais limpos

- **In-App Review**
  - `StrautilsInAppReview` - Sistema para solicitar avaliações
  - Respeita intervalo de 30 dias entre solicitações
  - Fallback para loja de aplicativos
  - Configuração de App Store ID para iOS
  - Não funciona em modo debug (segurança)

- **In-App Update**
  - `StrautilsInAppUpdate` - Sistema de atualizações automáticas
  - Suporte a atualizações flexíveis e imediatas
  - Verificação automática de disponibilidade
  - Disponível apenas no Android
  - Integração com Google Play

- **Tratamento de Erros**
  - `StrautilsTryThis` - Interface para repositórios
  - Tratamento automático de exceções comuns:
    - `SocketException` - Problemas de conexão
    - `NoSuchMethodError` - Dados inesperados
    - `TimeoutException` - Timeout de operações
    - `FormatException` - Formato inválido
  - `StrautilsDefaultErrors` - Mensagens padronizadas
  - Suporte a tratamento customizado via `onCatch`

### Dependências

- `get_storage: ^2.1.1` - Armazenamento local
- `in_app_review: ^2.0.9` - Avaliações in-app
- `in_app_update: ^4.2.3` - Atualizações in-app
- `flutter: sdk: flutter` - Framework Flutter

### Configurações

- SDK Dart: ^3.5.1
- Lints: ^4.0.0
- Test: ^1.24.0

### Documentação

- README.md completo com exemplos
- API Reference detalhada
- Exemplos práticos de uso
- Casos de uso comuns
- Padrões recomendados

### Testes

- Testes unitários para modelos
- Testes para validadores
- Cobertura de casos de uso principais

Para mais informações sobre mudanças específicas, consulte os commits do
repositório.
