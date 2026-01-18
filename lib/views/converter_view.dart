import 'package:flutter/material.dart';
import '../models/converter.model.dart';
import '../controllers/converter_controller.dart';


class ConverterView extends StatefulWidget {
  const ConverterView({super.key});

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView> {
  late final ConverterModel _model;
  late final ConverterController _controller;

  final TextEditingController _kmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = ConverterModel();
    _controller = ConverterController(_model);
  }

  void _convert() {
    _controller.updateKilometers(_kmController.text);
    _controller.convertKmToMiles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Km → miilid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Teisenda kilomeetrid miilideks',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _kmController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Kilomeetrid (km)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.route),
                  ),
                  onSubmitted: (_) => _convert(),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _convert,
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Teisenda'),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Miilid (mi): ${_controller.getMilesText(decimals: 4)}',
                    textAlign: TextAlign.right,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Tagasi kalkulaatorisse: kasuta ülal “back” noolt.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
