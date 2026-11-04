
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maos_unidas_pwa/main.dart';

void main() {
  testWidgets('Tela de login apresenta campos obrigatorios', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.text('E-mail institucional'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar no Sistema'), findsOneWidget);
  });

  testWidgets('Login vazio apresenta mensagem de validacao', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    await tester.tap(find.text('Entrar no Sistema'));
    await tester.pump();

    expect(
      find.text('Preencha o e-mail e a senha.'),
      findsOneWidget,
    );
  });

  testWidgets('Tela de consulta apresenta campo de CPF', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ConsultaScreen(),
      ),
    );

    expect(find.text('Digite o CPF'), findsOneWidget);
    expect(find.textContaining('Consultar Benefici'), findsOneWidget);
  });

  testWidgets('CPF incompleto apresenta mensagem de validacao', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ConsultaScreen(),
      ),
    );

    await tester.enterText(
      find.byType(TextField),
      '12345',
    );

    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pump();

    expect(
      find.textContaining('Digite um CPF com 11'),
      findsOneWidget,
    );
  });

  testWidgets('Tela de sucesso apresenta botao de retorno', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SucessoScreen(),
      ),
    );

    expect(find.text('Voltar ao Menu Principal'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
