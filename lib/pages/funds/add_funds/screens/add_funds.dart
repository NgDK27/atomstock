import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/pages/funds/layouts/move_funds.dart';
import 'package:oppenhomies/pages/funds/models/move_funds_type.dart';

class AddFunds extends HookConsumerWidget {
  const AddFunds({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MoveFunds(type: MoveFundsType.add,);
  }
}
