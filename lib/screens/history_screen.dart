import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final data = await DBHelper.instance.getHistory();
    setState(() {
      history = data;
    });
  }

  Future<void> clearHistory() async {
    await DBHelper.instance.clearHistory();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History 📜"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: clearHistory,
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(child: Text("No history yet"))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];

                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(item['name']),
                  subtitle: Text(item['timestamp']),
                );
              },
            ),
    );
  }
}