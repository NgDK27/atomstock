import 'package:flutter/cupertino.dart';
import 'package:oppenhomies/pages/settings/layouts/update_completed_layout.dart';

class UpdatePasswordCompleted extends StatelessWidget {
  const UpdatePasswordCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return UpdateCompletedLayout(updatedField: "Password");
  }
}
