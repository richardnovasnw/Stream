import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/streams.dart';

void main() {
  List<int> numbers = [11, 12, 13, 12, 4, 1];
  List<String> alphabets = ['A', 'B', 'C', 'D'];

  final StreamController streamController = StreamController();

  streamController.stream.listen((data) => print(data));

  //FILTER
  streamController.sink.add(numbers.where((b) => b > 10));

  //MAP
  streamController.sink.add(numbers.map((e) => e * 100));

  //FLATMAP
  streamController.sink.addStream(Stream.fromIterable([4, 3, 2, 1]).transform(
      FlatMapStreamTransformer((i) =>
          Stream.fromFuture(Future.delayed(Duration(seconds: 1), () => i)))));

  //REDUCE

  streamController.sink
      .add(numbers.reduce((value, element) => value + element));
  // CONCAT
  streamController.sink.addStream(ConcatStream(
      [Stream.fromIterable(numbers), Stream.fromIterable(alphabets)]));

  //COMBINELATEST
  streamController.sink.addStream(Rx.combineLatest2(
      Stream.value(1), Stream.fromIterable([0, 1, 2]), (a, b) => '$a $b'));

  //ZIP
  streamController.sink.addStream(ZipStream([
    Stream.fromIterable([1, 3, 3]),
    Stream.fromIterable([8, 8, 8, 8])
  ], (values) => values.join()));

//SCAN
  streamController.sink.addStream(Stream.fromIterable(numbers)
      .transform(ScanStreamTransformer((a, b, i) => a + b, 5)));

//DEBOUNCE
  streamController.sink.addStream(
      Stream.fromIterable(numbers).debounceTime(const Duration(seconds: 1)));

  // streamController.close();
}
// 