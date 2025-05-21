import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void
main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: CounterPage());
}

class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => CounterPageState();
}

class CounterPageState extends State<CounterPage> {
  int _counter = 0;
  static const platform = MethodChannel('com.maksim.demoWatchOS');

  void _sendToWatch(int value) async {
    try {
      await platform.invokeMethod('updateCounter', { 'value': value });
    } catch (e) {
      print("Failed to send to Watch: $e");
    }
  }

  void _increment() {
    setState(() { 
      _counter++; 
    });
    _sendToWatch(_counter);
  }

  void _decrement() {
    setState(() {
      _counter--;
    });
    _sendToWatch(_counter);
  }

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler((call) async {
        if (call.method == 'watchUpdated') {
          setState(() {
              _counter = call.arguments['value'];
          });
        }
    });
  }

  @override
  Widget
  build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('iOS Counter')),
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon( Icons.remove),
            onPressed: _decrement
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text('$_counter', style: TextStyle(fontSize: 32)),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _increment
          ),
        ],
      ),
    ),
  );
}
