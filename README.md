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

## Fluxo de consulta de beneficiários

O aplicativo Mãos Unidas permite consultar
beneficiários cadastrados utilizando o CPF.

### Etapas do processo

1. O usuário autorizado acessa o sistema.
2. Informa o CPF do beneficiário.
3. O aplicativo consulta os dados no Cloud Firestore.
4. As informações encontradas são exibidas na tela.
5. O usuário verifica a situação de elegibilidade
   e o benefício associado ao cadastro.

### Controle de entregas

O projeto prevê o registro de entregas de
benefícios sociais, com identificação do
beneficiário e do voluntário responsável.

O controle de duplicidade por benefício e
mês faz parte das regras de negócio previstas.

### Limitações do MVP

A confirmação definitiva de entregas depende
da conclusão e validação das regras de
segurança do banco de dados.

O sistema é um protótipo acadêmico e deve
ser validado antes de sua utilização real.

## Publicação e monitoramento

### Firebase Hosting

O aplicativo Mãos Unidas foi publicado
utilizando o Firebase Hosting.

Link público:
https://maos-unidas-pwa.web.app

O processo de publicação foi realizado
pelo terminal com o comando:

firebase deploy --only hosting

### Monitoramento com UptimeRobot

Foi configurado um monitor HTTP/HTTPS
no UptimeRobot para acompanhar a
disponibilidade da aplicação.

O monitor verifica o endereço público
do sistema a cada 5 minutos.

A ferramenta permite visualizar:
- Estado atual da aplicação.
- Histórico de disponibilidade.
- Incidentes de indisponibilidade.
- Tempo de resposta do servidor.

Também foi configurada a opção de
notificação por e-mail para alertas.

### Considerações

O monitoramento verifica a disponibilidade
do endereço web, mas não substitui os
testes das funcionalidades internas.