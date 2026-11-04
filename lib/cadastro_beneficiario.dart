
import 'package:flutter/material.dart';

class CadastroBeneficiarioScreen extends StatefulWidget {
  const CadastroBeneficiarioScreen({super.key});

  @override
  State<CadastroBeneficiarioScreen> createState() =>
      _CadastroBeneficiarioScreenState();
}

class _CadastroBeneficiarioScreenState
    extends State<CadastroBeneficiarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();
  final enderecoController = TextEditingController();

  DateTime? nascimento;
  String? beneficio;

  final beneficios = [
    'Cesta Básica Familiar',
    'Roupas',
    'Produtos de Higiene',
    'Outros',
  ];

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    telefoneController.dispose();
    enderecoController.dispose();
    super.dispose();
  }

  Future<void> selecionarNascimento() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (data != null && mounted) {
      setState(() {
        nascimento = data;
      });
    }
  }

  void cadastrar() {
    if (!_formKey.currentState!.validate()) return;

    if (nascimento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione a data de nascimento.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Formulário validado! Cadastro demonstrativo.',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Beneficiário'),
        backgroundColor: Colors.green.shade100,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Icon(
                  Icons.person_add,
                  size: 70,
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Novo Beneficiário',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o nome completo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cpfController,
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  decoration: const InputDecoration(
                    labelText: 'CPF (somente números)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null ||
                        !RegExp(r'^\d{11}$').hasMatch(valor)) {
                      return 'Informe 11 números para o CPF';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: selecionarNascimento,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    nascimento == null
                        ? 'Selecionar data de nascimento'
                        : '${nascimento!.day.toString().padLeft(2, '0')}/'
                          '${nascimento!.month.toString().padLeft(2, '0')}/'
                          '${nascimento!.year}',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: enderecoController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Benefício solicitado',
                    border: OutlineInputBorder(),
                  ),
                  items: beneficios.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      beneficio = valor;
                    });
                  },
                  validator: (valor) {
                    if (valor == null) {
                      return 'Selecione um benefício';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: cadastrar,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Cadastrar Beneficiário',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
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
