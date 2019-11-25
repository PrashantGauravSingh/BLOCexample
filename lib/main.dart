import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  final _bloc = CounterBLoC();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getBody(),
        floatingActionButton: _getButton()
    );
  }

  @override
  dispose(){
    super.dispose();
    _bloc.dispose();
  }

  _getBody(){
    return StreamBuilder(
        stream: _bloc.stream_counter,
        initialData: 0,
        builder: (context, snapshot) {
          return Center(
            child: Text(snapshot.data.toString()),
          );
        }
    );
  }

  _getButton(){
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => _bloc.counter_event_sink.add(IncrementEvent()),
    );
  }

}


class CounterBLoC{

  int _counter = 0;

  // init and get StreamController
  final _counterStreamController = StreamController<int>();
  StreamSink<int> get counter_sink => _counterStreamController.sink;

  // expose data from stream
  Stream<int> get stream_counter => _counterStreamController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  // expose sink for input events
  Sink <CounterEvent> get counter_event_sink => _counterEventController.sink;

  CounterBLoC() {  _counterEventController.stream.listen(_count);  }


  _count(CounterEvent event) => counter_sink.add(++_counter);

  dispose(){
    _counterStreamController.close();
    _counterEventController.close();
  }
}

abstract class CounterEvent{}

class IncrementEvent extends CounterEvent{}
