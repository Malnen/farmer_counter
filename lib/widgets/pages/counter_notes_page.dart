import 'package:farmer_counter/models/counter_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CounterNotesPage extends HookWidget {
  const CounterNotesPage();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<CounterItem> itemNotifier = context.read();
    return Column(
      children: <Widget>[],
    );
  }
}
