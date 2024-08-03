import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/pages/settings/layouts/update_completed_layout.dart';

class UpdateEmailCompleted extends StatelessWidget {
  const UpdateEmailCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return UpdateCompletedLayout(updatedField: "Email");
  }
}
