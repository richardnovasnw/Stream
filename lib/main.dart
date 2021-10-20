import 'dart:async';

import 'package:rxdart/rxdart.dart';

Stream<int> getNumberStream() async* {
  for (int i = 1; i <= 10; i++) {
    yield i;
  }
}

Stream<String> getAlphabetsStream() async* {
  for (var element in ['A', 'B', 'C', 'D', 'F', 'G', 'H']) {
    yield element;
  }
}

Stream<String> getDuplicateStream() async* {
  for (var element in ['1', '2', '2', '2', '3', '3', '4']) {
    yield element;
  }
}

void main() {
  filter(getNumberStream()).listen((event) {
    print('filter : $event');
  });

  map(getNumberStream()).listen((event) {
    print('map : $event');
  });

  flatMap(getNumberStream()).listen((event) {
    print('flatMap : $event');
  });

  concatMap(getNumberStream()).listen((event) {
    print('concatMap : $event');
  });

  concat(getNumberStream(), getAlphabetsStream()).listen((event) {
    print('concat : $event');
  });

  combineLatest(getNumberStream(), getAlphabetsStream()).listen((event) {
    print('combineLatest : $event');
  });

  zip(getNumberStream(), getAlphabetsStream()).listen((event) {
    print('zip : $event');
  });
  scan(getNumberStream()).listen((event) {
    print('concat : $event');
  });

  reduce(getNumberStream()).then((value) => print('reduce $value'));

  debounce(getNumberStream(), getDuplicateStream()).listen((event) {
    print('debounce : $event');
  });

  distinct(getDuplicateStream()).listen((event) {
    print('distinct : $event');
  });
  takeUntil(getNumberStream(), getDuplicateStream()).listen((event) {
    print('takeUntil : $event');
  });

  defaultIfEmpty().listen((event) {
    print('defaultIfEmpty : $event');
  });
}

Stream<int> filter(Stream<int> a) {
  return a.where((b) => b > 4);
}

Stream<int> map(Stream<int> a) {
  return a.map((e) => e * 100);
}

Stream<int> flatMap(Stream<int> a) {
  return a..expand((e) => [e, e + 1]);
}

Stream<int> concatMap(Stream<int> a) {
  return a.asyncExpand((event) => Stream.fromIterable([event, event * 5]));
}

Stream concat(
  Stream<int> a,
  Stream<String> b,
) {
  return ConcatStream([a, b]);
}

Stream combineLatest(
  Stream<int> a,
  Stream<String> b,
) {
  return Rx.combineLatest2(a, b, (a, b) => '$a $b');
}

Stream zip(Stream<int> a, Stream<String> b) {
  return ZipStream([
    a,
    b,
  ], (values) => values.join());
}

Stream<int> scan(Stream<int> a) {
  return a.transform(ScanStreamTransformer((c, d, i) => c + d, 0));
}

Future reduce(Stream<int> a) {
  return a.reduce((value, element) => value + element);
}

Stream debounce(Stream<int> a, Stream<String> b) {
  return ConcatStream([
    a.debounceTime(const Duration(seconds: 3)),
    b.debounceTime(const Duration(seconds: 3)),
    Stream.fromIterable([2, 4]).debounceTime(const Duration(seconds: 3))
  ]);
}

Stream<String> distinct(Stream<String> a) {
  return a.distinct();
}

Stream<int> takeUntil(Stream<int> a, Stream<String> b) {
  return a.takeUntil(TimerStream(b, const Duration(seconds: 3)));
}

Stream defaultIfEmpty() {
  return const Stream.empty().defaultIfEmpty('Empty');
}
