import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: ListView.builder(
        itemCount: 12,
        addAutomaticKeepAlives: true,
        primary: false,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text((index + 1).toString()),
            ),
            title: Text('Item ${index + 1}'),
            subtitle: Text('This is item number ${index + 1}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Handle item tap action here
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
