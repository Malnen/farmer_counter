import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/counters/counter_details_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CounterDetailsPage extends HookWidget {
  final void Function(CounterItem updatedItem)? onUpdate;
  final void Function(CounterItem item)? onDelete;

  const CounterDetailsPage({
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<CounterItem> itemNotifier = context.read();
    final String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(itemNotifier.value.createdAt);

    return Column(
      children: <Widget>[
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '${'counter_details_page.fields.name'.tr()}: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          itemNotifier.value.name,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => _editName(context, itemNotifier),
                      tooltip: 'counter_details_page.actions.edit'.tr(),
                    ),
                  ],
                ),
                const Divider(),
                _buildDetailRow('counter_details_page.fields.count'.tr(), itemNotifier.value.count.toString()),
                const Divider(),
                _buildDetailRow('counter_details_page.fields.created_at'.tr(), formattedDate),
              ],
            ),
          ),
        ),
        Flexible(
          child: CounterDetailsHistoryList(),
        ),
      ],
    );
  }

  Future<void> _editName(BuildContext context, ValueNotifier<CounterItem> itemNotifier) async {
    final TextEditingController controller = TextEditingController(text: itemNotifier.value.name);
    final String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('counter_details_page.dialogs.edit_name.title'.tr()),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'counter_details_page.dialogs.edit_name.name_label'.tr()),
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(context), child: Text('counter_details_page.dialogs.edit_name.cancel'.tr())),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text('counter_details_page.dialogs.edit_name.save'.tr()),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != itemNotifier.value.name) {
      itemNotifier.value = itemNotifier.value.copyWith(name: newName);
      onUpdate?.call(itemNotifier.value);
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
