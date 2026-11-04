# Auto-revisão técnica — Mãos Unidas

## 1. Objetivo

Registrar a auto-revisão técnica do MVP Mãos Unidas, desenvolvido com Flutter e Firebase, identificando pontos de atenção relacionados à arquitetura, legibilidade, manutenção e segurança.

## 2. Arquitetura

O aplicativo utiliza Flutter para a interface web e Firebase para serviços de autenticação, armazenamento de dados e hospedagem.

**Análise crítica:** a concentração de responsabilidades em um único arquivo pode dificultar a manutenção e a evolução do sistema.

**Melhoria recomendada:** separar gradualmente as telas, os serviços de acesso ao Firestore e as regras de negócio em arquivos específicos.

## 3. Segurança

O sistema trabalha com informações de beneficiários, incluindo CPF, exigindo cuidados com privacidade e controle de acesso.

**Análise crítica:** a consulta de beneficiários deve ser protegida por autenticação e regras de autorização adequadas no Firestore. A validação apenas na interface não é suficiente.

**Melhoria recomendada:** revisar as regras de segurança do Firestore, restringir o acesso aos dados e testar tentativas de consulta não autorizada.

## 4. Legibilidade e refatoração

A organização do código influencia a facilidade de identificar erros e implementar novas funcionalidades.

**Análise crítica:** métodos responsáveis por interface e acesso ao banco de dados podem se tornar extensos e difíceis de testar.

**Melhoria recomendada:** utilizar nomes descritivos, reduzir a duplicação de código e extrair responsabilidades para funções ou serviços menores.

## 5. Limitações identificadas

A confirmação definitiva de entregas permanece desabilitada enquanto as regras de segurança não forem concluídas e validadas.

Essa restrição evita apresentar como operacional uma funcionalidade que ainda necessita de testes.

## 6. Conclusão

A auto-revisão identificou oportunidades de melhoria na organização do código, no controle de acesso e na validação das funcionalidades.

O MVP deve continuar sendo tratado como protótipo acadêmico até a conclusão dos testes e das medidas de segurança necessárias.
