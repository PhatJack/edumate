import 'package:edumate/core/widgets/app_layout.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EAppLayout(
      title: 'Profile',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Trang Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Thông tin người dùng ở đây',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Quay lại Home'),
            ),
            const SizedBox(height: 15),
            OutlinedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/settings'),
              child: const Text('Thay thế bằng Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
