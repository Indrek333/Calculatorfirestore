import 'package:flutter/material.dart';
import 'converter_view.dart';
import 'history_view.dart';
import '../models/calculator_model.dart';
import '../controllers/calculator_controller.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  late final CalculatorModel _model;
  late final CalculatorController _controller;

  final TextEditingController _expressionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = CalculatorModel();
    _controller = CalculatorController(_model);
  }

  @override
  void dispose() {
    _expressionController.dispose();
    super.dispose();
  }

  void _insertText(String text) {
    final value = _expressionController.value;
    final selection = value.selection;
    final baseText = value.text;
    final insertAt = selection.isValid ? selection.start : baseText.length;
    final endAt = selection.isValid ? selection.end : baseText.length;

    final newText = baseText.replaceRange(insertAt, endAt, text);
    final cursorPosition = insertAt + text.length;

    _expressionController.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  
  Future<void> _onCalculatePressed() async {
    await _controller.calculateExpression(_expressionController.text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Lihtne kalkulaator'),
        actions: [
          IconButton(
            tooltip: 'Ajalugu',
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryView()),
              );
            },
          ),
        ],
      ),

  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF1E3C72),
          Color(0xFF2A5298),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                        Text(
                          'Lihtne kalkulaator',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ConverterView(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.map),
                          label: const Text('Km → miilid teisendaja'),
                        ),
                        const SizedBox(height: 16),

                        const SizedBox(height: 6),
                        TextField(
                          controller: _expressionController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.edit),
                            hintText: 'Sisesta võrrand (nt 5+6/2)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Column(
                          children: [
                            Row(
                              children: [
                                _KeyButton(label: '7', onTap: () => _insertText('7')),
                                _KeyButton(label: '8', onTap: () => _insertText('8')),
                                _KeyButton(label: '9', onTap: () => _insertText('9')),
                                _KeyButton(label: '÷', onTap: () => _insertText('/')),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _KeyButton(label: '4', onTap: () => _insertText('4')),
                                _KeyButton(label: '5', onTap: () => _insertText('5')),
                                _KeyButton(label: '6', onTap: () => _insertText('6')),
                                _KeyButton(label: '×', onTap: () => _insertText('*')),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _KeyButton(label: '1', onTap: () => _insertText('1')),
                                _KeyButton(label: '2', onTap: () => _insertText('2')),
                                _KeyButton(label: '3', onTap: () => _insertText('3')),
                                _KeyButton(label: '−', onTap: () => _insertText('-')),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _KeyButton(label: '0', onTap: () => _insertText('0')),
                                _KeyButton(label: '+', onTap: () => _insertText('+')),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: _onCalculatePressed,
                          icon: const Icon(Icons.check),
                          label: const Text('Arvuta'),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'Tulemus',
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _controller.getResultText(),
                            textAlign: TextAlign.right,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _KeyButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}