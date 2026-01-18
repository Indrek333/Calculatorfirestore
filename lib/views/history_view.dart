import 'package:flutter/material.dart';
import '../models/history_item.dart';
import '../controllers/history_controller.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late final HistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HistoryController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Ajalugu'),
        actions: [
          IconButton(
            tooltip: 'Kustuta ajalugu',
            onPressed: () async {
              await _controller.clear();
              setState(() {});
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: FutureBuilder<List<HistoryItem>>(
        future: _controller.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text(
                'Ajalugu on tühi.',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 12, color: Colors.black12),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.black),
                title: Text(
                  item.expression,
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  item.timestamp,
                  style: const TextStyle(color: Colors.black54),
                ),
              );
            },
          );
        },
      ),
    );
  }
}