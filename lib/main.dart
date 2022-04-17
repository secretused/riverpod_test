import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_test/view_model.dart';
import 'package:riverpod_test/provider.dart';

// import 'data/count_data.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  ViewModel _viewModel = ViewModel();
  @override
  void initState() {
    super.initState();
    // ConsumerStatefulWidgetのConsumerStateの場合直接アクセスできる
    _viewModel.setRef(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(titileProvider)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(ref.watch(messageProvider)),
            Text(
              _viewModel.count,
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  // readを使うことでfloatingActionButtonを再描画させない
                  onPressed: () {
                    _viewModel.onIncrease();
                  },
                  child: const Icon(CupertinoIcons.add),
                ),
                FloatingActionButton(
                  // readを使うことでfloatingActionButtonを再描画させない
                  onPressed: () {
                    _viewModel.onDecrease();
                  },
                  child: const Icon(CupertinoIcons.minus),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  _viewModel.countUp,
                ),
                Text(
                  _viewModel.countDown,
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "increment",
        // readを使うことでfloatingActionButtonを再描画させない
        onPressed: () {
          _viewModel.onReset();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
