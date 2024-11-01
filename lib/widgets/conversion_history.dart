import 'package:flutter/material.dart';
import '../models/conversion_record.dart';

class ConversionHistory extends StatelessWidget {
  final List<ConversionRecord> history;

  const ConversionHistory({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Conversion History',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          if (history.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No conversions yet',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final record = history[index];
                return ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    '${record.operation}: ${record.inputValue} => ${record.result}',
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}