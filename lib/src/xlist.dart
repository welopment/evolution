//import 'package:evolutionSimple/evolution.dart';
import 'dart:collection' show ListMixin;

class XList<T> extends Object with ListMixin<T> {
  XList();

  XList.fromList(List<T> l) {
    this._base = l;
  }

  List<T> _base = List<T>();

  List<T> get base => this._base;

  set base(List<T> l) => this._base = l;

  @override
  T operator [](int n) => this._base[n];

  @override
  void operator []=(int n, T e) => this._base[n] = e;

  @override
  int get length => _base.length;

  @override
  set length(int i) => _base.length = i;

  @override
  void add(T i) => _base.add(i);

  @override
  void addAll(Iterable<T> i) => _base.addAll(i);

  Iterable<T> mapi(T Function(int i, T) f) {
    int z = 0;
    return this.map((T el) {
      T ret = f(z, el);
      z++;
      return ret;
    });
  }

  Iterable<T> mapz(List<T> other, T Function(int, T, T) f) {
    if (this.length != other.length) throw Exception("different lengths");

    int z = 0;
    return this.map((T el) {
      T ret = f(z, el, other[z]);
      z++;
      return ret;
    });
  }

  static Iterable<T> generateWithContext<C, T>(
    int length,
    T Function(int, C) f,
    C c,
  ) {
    Iterable<T> ret = XList()
      ..base = List<T>.generate(length, (int i) => f(i, c));

    //print("generateWithContext: par ${length} akt ${ret.length}");
    return ret;
  }

  static Iterable<T> generate<T>(
    int length,
    T Function(int) f,
  ) {
    Iterable<T> ret = XList()
      ..base = List<T>.generate(
        length,
        (int i) => f(i),
      );

    //print("generateWithContext: par ${length} akt ${ret.length}");
    return ret;
  }

  Iterable<T> copy() {
    return this.map((T el) {
      return el;
    });
  }
}
