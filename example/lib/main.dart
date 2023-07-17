import 'package:flutter/material.dart';
import 'package:prevent_orphan_text/prevent_orphan_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _containerWidth = 220;

  String text = "Enter text above to start adding items";

  void setWidth(double value) {
    setState(() {
      _containerWidth = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 500,
              child: Slider(
                activeColor: Theme.of(context).primaryColor,
                value: _containerWidth,
                min: 100,
                max: 800,
                label: _containerWidth.round().toString(),
                onChanged: (double value) => setWidth(value),
              ),
            ),
            Text('Width: $_containerWidth'),
            Container(
              //add borders
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              width: _containerWidth,
              child: Column(
                children: [
                  const Text('no orphans'),
                  PreventOrphanText(
                    text,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text('normal text'),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
