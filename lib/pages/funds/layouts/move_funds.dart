import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oppenhomies/pages/funds/helpers/currency_input_formatter.dart';
import 'package:oppenhomies/pages/funds/models/move_funds_type.dart';
import 'package:oppenhomies/styles/colors.dart';
import 'package:oppenhomies/styles/opacities.dart';
import 'package:oppenhomies/styles/radius.dart';
import 'package:oppenhomies/styles/spacings.dart';
import 'package:oppenhomies/styles/text.dart';
import 'package:oppenhomies/widgets/bars/bottom_bar.dart';
import 'package:oppenhomies/widgets/buttons/primary/OpFilledGlowPrimaryButton.dart';
import 'package:oppenhomies/widgets/divider/divider_variant.dart';
import 'package:oppenhomies/widgets/helpers/money_formatter.dart';
import 'package:oppenhomies/widgets/scaffolds/platform_sliver_scaffold.dart';
import 'package:oppenhomies/widgets/tables/simple_row.dart';

class MoveFunds extends HookConsumerWidget {
  final MoveFundsType type;
  final double
      currentBalance; // TODO: Figure out the right way to pass this data. Probably use Riverpod

  const MoveFunds({
    super.key,
    required this.type,
    this.currentBalance = 123456789, // TODO: Remove default value
  });

  void handleChangeAccount({required BuildContext context}) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text("Account cannot be changed during testing phase"),
        content: const Text(
          "Please use the provided free account, which has unlimited funds.",
        ),
        actions: [
          PlatformDialogAction(
            child: const Text("OK"),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }

  void handleMoveFunds({
    required BuildContext context,
    required MoveFundsType type,
    required double amount,
  }) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text("${type.label}ing funds attempted"),
        content: Text(
          "Amount: ${amount.vndFormat()}",
        ),
        actions: [
          PlatformDialogAction(
            child: const Text("OK"),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputController = useTextEditingController();
    final accountController =
        useTextEditingController(text: "TymeX • Free Testing Account");

    final inputAmount = useState(0.0);

    useEffect(
      () {
        void listener() {
          final amount = double.tryParse(
                inputController.text.replaceAll(RegExp(r'[^0-9]'), ''),
              ) ??
              0;
          inputAmount.value = amount;
        }

        inputController.addListener(listener);
        return () => inputController.removeListener(listener);
      },
      [inputController],
    );

    final isButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() {
          final inputText =
              inputController.text.replaceAll(RegExp(r'[^0-9]'), '');
          final amount = double.tryParse(inputText) ?? 0;
          isButtonEnabled.value = amount > 1000 &&
              (type == MoveFundsType.add || amount <= currentBalance);
        }

        inputController.addListener(listener);
        return () => inputController.removeListener(listener);
      },
      [inputController, type, currentBalance],
    );

    return OpPlatformSliverScaffold(
      title: "${type.label} funds",
      slivers: [
        SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.symmetric(horizontal: OpSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                PlatformTextField(
                  autofocus: true,
                  controller: inputController,
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  textInputAction: TextInputAction.done,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textAlign: TextAlign.start,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    VNDInputFormatter(),
                  ],
                  style:
                      OpTextStyle.display(context)?.copyWith(letterSpacing: 5),
                  makeCupertinoDecorationNull: true,
                  material: (_, __) => MaterialTextFieldData(
                    decoration: const InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintStyle: TextStyle(inherit: true, letterSpacing: 15),
                      suffix: Text("₫"),
                    ),
                  ),
                  cupertino: (_, __) => CupertinoTextFieldData(
                    suffix: Text("₫", style: OpTextStyle.titleLarge(context)),
                    placeholderStyle: TextStyle(
                      color: OpDynamicColor.onSurface(context)
                          .withOpacity(OpOpacity.secondary),
                      letterSpacing: 15,
                    ),
                    padding: const EdgeInsets.fromLTRB(
                      OpSpacing.none,
                      OpSpacing.lg,
                      OpSpacing.none,
                      OpSpacing.xs,
                    ),
                  ),
                ),
                const SizedBox(height: OpSpacing.sm),
                SimpleRow(
                  label: "Current balance",
                  value: currentBalance,
                ),
                const OpDividerVariant(),
                SimpleRow(
                  label: "Balance after ${type.label.toLowerCase()}ing",
                  value: type == MoveFundsType.add
                      ? currentBalance + inputAmount.value
                      : currentBalance - inputAmount.value,
                ),
                const SizedBox(height: OpSpacing.lg),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(OpRadius.full),
                      ),
                      color: OpDynamicColor.surfaceContainerHigh(context),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(OpSpacing.sm),
                      child: Icon(
                        () {
                          switch (type) {
                            case MoveFundsType.add:
                              return PlatformIcons(context).upArrow;
                            case MoveFundsType.withdraw:
                              return PlatformIcons(context).downArrow;
                          }
                        }(),
                        color: OpDynamicColor.onSurface(context),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: OpSpacing.lg),
                PlatformTextField(
                  controller: accountController,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  onTap: () => handleChangeAccount(context: context),
                  material: (_, __) => MaterialTextFieldData(
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.chevron_right),
                      label: Text(
                        switch (type) {
                          MoveFundsType.add => "Adding from",
                          MoveFundsType.withdraw => "Withdrawing to",
                        },
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(OpRadius.md),
                        ),
                      ),
                    ),
                  ),
                  cupertino: (_, __) => CupertinoTextFieldData(
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: OpSpacing.xs),
                      child: Icon(
                        CupertinoIcons.chevron_right,
                        color: OpDynamicColor.onSurface(context),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: OpSpacing.sm,
                      horizontal: OpSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(OpRadius.md),
                      ),
                      border: Border.all(
                        color: OpDynamicColor.onSurfaceVariant(context)
                            .withOpacity(OpOpacity.tertiary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      floatingBottomWidget: BottomBar(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (type == MoveFundsType.withdraw &&
                inputAmount.value > currentBalance) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PlatformIcons(context).error,
                    color: OpDynamicColor.cherryHarmonized(
                      context,
                    ),
                  ),
                  const SizedBox(
                    width: OpSpacing.xs,
                  ),
                  Text(
                    "Not enough balance",
                    textAlign: TextAlign.center,
                    style: OpTextStyle.labelMedium(context).bold().copyWith(
                          color: OpDynamicColor.cherryHarmonized(context),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: OpSpacing.sm),
            ],
            OpFilledGlowPrimaryButton(
              text: type.label,
              onPressed: isButtonEnabled.value
                  ? () => handleMoveFunds(
                        context: context,
                        type: type,
                        amount: double.parse(inputController.text
                            .replaceAll(RegExp(r'[^0-9]'), ''),),
                      )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
