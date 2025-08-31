import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CounterCardActions extends HookWidget {
  final void Function(int delta)? onBulkAdjust;
  final VoidCallback? onReverseLast;

  const CounterCardActions({required this.onBulkAdjust, this.onReverseLast, super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final ValueNotifier<bool> expanded = useState<bool>(false);
    final double maxWidth = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        ClipRect(
          child: AnimatedAlign(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            heightFactor: expanded.value ? 1 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: expanded.value ? 1 : 0,
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  spacing: 12,
                  children: <Widget>[
                    _buildActionButton(
                      increase: true,
                      background: colorScheme.primary,
                      foreground: colorScheme.onPrimary,
                      icon: Icons.arrow_upward,
                      labelKey: 'counter_card.actions.increase',
                      expanded: expanded,
                      maxWidth: maxWidth,
                      context: context,
                    ),
                    _buildActionButton(
                      increase: false,
                      background: colorScheme.error,
                      foreground: colorScheme.onError,
                      icon: Icons.arrow_downward,
                      labelKey: 'counter_card.actions.decrease',
                      expanded: expanded,
                      maxWidth: maxWidth,
                      context: context,
                    ),
                    _buildReverseButton(
                      background: colorScheme.secondary,
                      foreground: colorScheme.onSecondary,
                      icon: Icons.undo,
                      labelKey: 'counter_card.actions.reverse',
                      expanded: expanded,
                      maxWidth: maxWidth,
                      context: context,
                      onPressed: onReverseLast,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            ),
            child: TextButton.icon(
              key: ValueKey<bool>(expanded.value),
              icon: Icon(expanded.value ? Icons.expand_less : Icons.expand_more),
              label: Text(
                expanded.value ? 'counter_card.hide_actions'.tr() : 'counter_card.more_actions'.tr(),
              ),
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.bodyLarge,
              ),
              onPressed: () => expanded.value = !expanded.value,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required bool increase,
    required Color background,
    required Color foreground,
    required IconData icon,
    required String labelKey,
    required ValueNotifier<bool> expanded,
    required double maxWidth,
    required BuildContext context,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: expanded.value ? maxWidth : 0,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => _showBulkDialog(increase: increase, context: context),
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: 0,
            maxWidth: maxWidth,
            minHeight: 48,
            maxHeight: 48,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  labelKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReverseButton({
    required Color background,
    required Color foreground,
    required IconData icon,
    required String labelKey,
    required ValueNotifier<bool> expanded,
    required double maxWidth,
    required BuildContext context,
    required VoidCallback? onPressed,
  }) {
    final bool hasOnPressed = onPressed != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: expanded.value && hasOnPressed ? maxWidth : 0,
      height: hasOnPressed ? 48 : 0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            minWidth: 0,
            maxWidth: maxWidth,
            minHeight: 48,
            maxHeight: 48,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  labelKey.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showBulkDialog({required bool increase, required BuildContext context}) async {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final int? result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          increase ? 'counter_card.dialogs.increase_title'.tr() : 'counter_card.dialogs.decrease_title'.tr(),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$')),
            ],
            decoration: InputDecoration(
              labelText: 'counter_card.dialogs.amount_label'.tr(),
              hintText: 'counter_card.dialogs.amount_hint'.tr(),
            ),
            validator: (String? value) {
              final int? parsed = int.tryParse((value ?? '').trim());
              if (parsed == null || parsed == 0) {
                return 'counter_card.dialogs.amount_error'.tr();
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(context, int.parse(controller.text));
              }
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );

    if (result != null && onBulkAdjust != null) {
      onBulkAdjust!(increase ? result : -result);
    }
  }
}
