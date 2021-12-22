import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter-shortcuts-actions-bug-95506',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Shortcuts(
        manager: ShortcutManager(),
        shortcuts: <LogicalKeySet, Intent>{
          NonRepeatingLogicalKeySet(LogicalKeyboardKey.keyG):
              const GroupIntent(),
        },
        child: const MyHomePage(title: 'flutter-shortcuts-actions-bug-95506'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FocusNode node = FocusNode(debugLabel: 'hi');
  void incGroupCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      dispatcher: const ActionDispatcher(),
      actions: <Type, Action<Intent>>{
        GroupIntent: GroupAction(this),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have triggered the group action this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),

                // const TextField(
                //   autofocus: true,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroupIntent extends Intent {
  const GroupIntent();
}

class GroupAction extends Action<GroupIntent> {
  GroupAction(this.model);

  /// Just a hack to show the point...
  final _MyHomePageState model;

  @override
  void invoke(covariant GroupIntent intent) => model.incGroupCounter();
}

class NonRepeatingLogicalKeySet extends LogicalKeySet {
  NonRepeatingLogicalKeySet(
    LogicalKeyboardKey key1, [
    LogicalKeyboardKey? key2,
    LogicalKeyboardKey? key3,
    LogicalKeyboardKey? key4,
  ]) : super(key1, key2, key3, key4);

  @override
  bool accepts(RawKeyEvent event, RawKeyboard state) {
    // If event were a KeyEvent instead of a RawKeyEvent we could do this to not
    // allow the shortcut to trigger on repeats:

    // return event is! KeyRepeatEvent && super.accepts(event, state);

    return super.accepts(event, state);
  }
}
