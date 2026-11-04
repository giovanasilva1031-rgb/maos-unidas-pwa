# Mãos Unidas

## Sobre o projeto

O Mãos Unidas é um aplicativo web progressivo (PWA) desenvolvido como projeto acadêmico para apoiar a organização e o controle da distribuição de benefícios sociais.

A proposta é facilitar a consulta de beneficiários e apoiar o registro de entregas de doações, contribuindo para a organização das atividades de assistência social.

## Funcionalidades do MVP

- Consulta de beneficiários por CPF.
- Consulta de informações e situação de elegibilidade.
- Autenticação de usuários com Firebase Authentication.
- Integração com Cloud Firestore para armazenamento de dados.
- Interface web desenvolvida em Flutter.

**Observação:** o registro definitivo de entregas depende da configuração e validação das regras de segurança do Firestore.

## Tecnologias utilizadas

- Dart e Flutter
- Firebase Authentication
- Cloud Firestore
- Firebase Hosting
- Git e GitHub

## Aplicação publicada

https://maos-unidas-pwa.web.app

## Objetivo acadêmico

Demonstrar a aplicação prática de conceitos de desenvolvimento de software, banco de dados, autenticação, publicação em nuvem e versionamento de código em uma solução voltada ao apoio social.

## Como executar o projeto

### Pré-requisitos

- Flutter SDK instalado
- Visual Studio Code
- Navegador Microsoft Edge
- Conexão com a internet

### Instalação

1. Clone o repositório do GitHub.
2. Abra a pasta do projeto no VS Code.
3. Execute o comando:

   flutter pub get

4. Inicie o aplicativo no navegador:

   flutter run -d edge

### Observações

O sistema utiliza serviços do Firebase para
autenticação e armazenamento de dados.

Para funcionar corretamente, é necessário
manter a configuração do Firebase disponível.