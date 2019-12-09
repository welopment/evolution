import 'package:evolution/evolution.dart';

class Fitness<T> {
  Fitness(this._a, this._fitness);

  XList<T> _a = XList<T>();

  double _fitness = double.infinity;

  List<T> get base {
    return (_a.base.map((x) => x)).toList();
  }

  double get fitness => _fitness;
}
