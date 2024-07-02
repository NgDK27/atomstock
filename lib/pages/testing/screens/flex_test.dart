import 'package:flutter/material.dart';

class RenderFlexPage extends StatelessWidget {
  const RenderFlexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Column > Text_A'),
          Expanded( // Expanded_A
            child: Column(
              children: [
                Text('Column > Expanded_A > Column > Text_B'),
                Expanded( // Expanded_B

                    child: Text('Column > Expanded_A > Column > Expanded_B'))
              ],
            ),
          )
        ],
      ),
    );
  }
}