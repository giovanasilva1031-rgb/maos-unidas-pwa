import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cadastro_beneficiario.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaosUnidasApp());
}

class MaosUnidasApp extends StatelessWidget {
  const MaosUnidasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mãos Unidas PWA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

// TELA 1 - LOGIN DO VOLUNTÁRIO

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> entrar() async {
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o e-mail e a senha.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConsultaScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String mensagem = 'Não foi possível entrar no sistema.';

      if (e.code == 'invalid-email') {
        mensagem = 'O e-mail informado é inválido.';
      } else if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        mensagem = 'E-mail ou senha incorretos.';
      } else if (e.code == 'too-many-requests') {
        mensagem = 'Muitas tentativas. Tente novamente mais tarde.';
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensagem)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mãos Unidas - Acesso'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.volunteer_activism,
                  color: Colors.green,
                  size: 90,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Portal do Voluntário',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Bem-vindo ao sistema Mãos Unidas',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail institucional',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: entrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Entrar no Sistema',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CadastroBeneficiarioScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Cadastrar Beneficiário'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TELA 2 - CONSULTA DE BENEFICIÁRIO

class ConsultaScreen extends StatefulWidget {
  const ConsultaScreen({super.key});

  @override
  State<ConsultaScreen> createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  final cpfController = TextEditingController();
  bool resultadoEncontrado = false;
  Map<String, dynamic>? beneficiarioEncontrado;
  bool consultando = false;
  bool registrandoEntrega = false;

  @override
  void dispose() {
    cpfController.dispose();
    super.dispose();
  }

  Future<void> consultarBeneficiario() async {
    final cpf = cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) {
      setState(() {
        resultadoEncontrado = false;
        beneficiarioEncontrado = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um CPF com 11 números.')),
      );
      return;
    }

    setState(() {
      consultando = true;
      resultadoEncontrado = false;
      beneficiarioEncontrado = null;
    });

    try {
      final resultado = await FirebaseFirestore.instance
          .collection('beneficiarios')
          .where('cpf', isEqualTo: cpf)
          .limit(1)
          .get();

      if (!mounted) return;

      if (resultado.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Beneficiário não encontrado.')),
        );
      } else {
        setState(() {
          beneficiarioEncontrado = {
            ...resultado.docs.first.data(),
            'documentoId': resultado.docs.first.id,
          };
          resultadoEncontrado = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao consultar o Firebase.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          consultando = false;
        });
      }
    }
  }

  Future<void> confirmarEntrega() async {
    final beneficiario = beneficiarioEncontrado;
    final usuario = FirebaseAuth.instance.currentUser;
    final voluntarioId = usuario?.uid;
    final beneficiarioId = beneficiario?['documentoId'];
    final beneficio = beneficiario?['beneficio'];

    final horarioBrasilia = DateTime.now().toUtc().subtract(
      const Duration(hours: 3),
    );

    final mesReferencia = horarioBrasilia.year * 100 + horarioBrasilia.month;

    if (beneficiarioId == null || beneficiarioId.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beneficiário sem identificação válida.')),
      );
      return;
    }

    if (beneficiario == null || usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Beneficiário ou usuário não identificado.'),
        ),
      );
      return;
    }

    if (registrandoEntrega) return;

    setState(() {
      registrandoEntrega = true;
    });

    try {
      final entregaId = '${beneficiarioId}_${beneficio}_${mesReferencia}';

      final entregaRef = FirebaseFirestore.instance
          .collection('entregas')
          .doc(entregaId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final entregaExistente = await transaction.get(entregaRef);

        if (entregaExistente.exists) {
          throw Exception('ENTREGA_DUPLICADA');
        }

        transaction.set(entregaRef, {
          'beneficiarioId': beneficiarioId,
          'beneficio': beneficio,
          'mesReferencia': mesReferencia,
          'voluntarioId': voluntarioId,
          'dataEntrega': FieldValue.serverTimestamp(),
        });
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrega registrada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final duplicada = e.toString().contains('ENTREGA_DUPLICADA');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            duplicada
                ? 'Este benefício já foi entregue neste mês.'
                : 'Não foi possível registrar a entrega: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          registrandoEntrega = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registo de Entrega'),
        backgroundColor: Colors.green.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consulta de Beneficiário por CPF',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Informe o CPF do beneficiário para '
                  'consultar o benefício disponível.',
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: cpfController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) {
                    if (resultadoEncontrado) {
                      setState(() {
                        resultadoEncontrado = false;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Digite o CPF',
                    hintText: '000.000.000-00',
                    prefixIcon: Icon(Icons.person_search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: consultarBeneficiario,
                    child: const Text('Consultar Beneficiário'),
                  ),
                ),
                if (resultadoEncontrado) ...[
                  const SizedBox(height: 24),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.person, color: Colors.green, size: 30),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Beneficiário encontrado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Text(
                            'Nome: ${beneficiarioEncontrado?['nome'] ?? 'Não informado'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Benefício: ${beneficiarioEncontrado?['beneficio'] ?? 'Não informado'}',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${beneficiarioEncontrado?['status'] ?? 'Não informado'}',
                          ),

                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: confirmarEntrega,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Confirmar Entrega'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// TELA 3 - CONFIRMAÇÃO DE ENTREGA

class SucessoScreen extends StatelessWidget {
  const SucessoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              const Text(
                'Entrega Registada com Sucesso!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'A entrega foi confirmada nesta '
                'demonstração do sistema.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Voltar ao Menu Principal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
