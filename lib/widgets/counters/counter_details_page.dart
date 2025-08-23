import 'package:easy_localization/easy_localization.dart';
import 'package:farmer_counter/models/counter_item.dart';
import 'package:farmer_counter/widgets/counters/counter_details_history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CounterDetailsPage extends HookWidget {
  final CounterItem item;
  final void Function(CounterItem updatedItem)? onUpdate;
  final void Function(CounterItem item)? onDelete;

  const CounterDetailsPage({
    required this.item,
    this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<CounterItem> itemNotifier = useState(item);
    final String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(itemNotifier.value.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(itemNotifier.value.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteItem(context, itemNotifier),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              child: CounterDetailsHistoryList(item: item),
            ),
          ],
        ),
      ),
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

  Future<void> _deleteItem(BuildContext context, ValueNotifier<CounterItem> itemNotifier) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('counter_details_page.dialogs.delete_counter.title'.tr()),
        content: Text('counter_details_page.dialogs.delete_counter.message'.tr()),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(context, false), child: Text('counter_details_page.dialogs.delete_counter.cancel'.tr())),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text('counter_details_page.dialogs.delete_counter.delete'.tr()),
          ),
        ],
      ),
    );

    if (confirm == true) {
      onDelete?.call(itemNotifier.value);
      if (context.mounted) {
        Navigator.pop(context);
      }
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
