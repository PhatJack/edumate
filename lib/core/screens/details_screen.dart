import 'package:edumate/core/widgets/app_layout.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final title = arguments?['title'] ?? 'No Title';
    final id = arguments?['id'] ?? 0;

    return EAppLayout(
      title: title,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 80, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Màn hình chi tiết',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Dữ liệu nhận được:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Title: $title'),
                    Text('ID: $id'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
