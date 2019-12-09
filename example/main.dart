import 'package:evolution/evolution.dart';
import 'package:optima/optima.dart';

void main() {
  //var seed = DateTime.now().millisecond;

  print(
      "Optimize a version of the sphere function centered at (100.0, ... , 100.0) on the unrestricted version of the problem.");
  10.times((int i) {
    var ret = diff(4, 25, 10, 10, 25, i, 500, 10.0, sphere100);
    print("Sphere100 - Trial Nr.: ${i} - f: ${ret.fitness()} - ag: ${ret}");
    return ret;
  });

  print("Use the version restricted on (50, 150) in each dimension.");
  10.times((int i) {
    var result = diff2(4, 25, 10, 10, 25, i, 500, 10.0, sphere100, 50, 150);
    print(
        "Sphere100 (restricted) - Trial Nr.: ${i} - f: ${result.fitness()} - ag: ${result}");
    return result;
  });

  print(
      "Optimize a version of the ackley function centered at (10.0, ... , 10.0) on the unrestricted version of the problem.");
  10.times((int i) {
    var result = diff(4, 25, 10, 10, 25, i, 1000, 10.0, ackley10);
    print("Ackley10 - Trial Nr.: ${i} - f: ${result.fitness()} - ag: ${result}   ");
    return result;
  });

  print(
      "Optimize a version of the ackley function centered at (100.0, ... , 100.0) on the unrestricted version of the problem.");
  print("This will not find a solution to the problem.");

  10.times((int i) {
    var result = diff(4, 25, 10, 10, 25, i, 1000, 10.0, ackley100);
    print("Ackley100 - Trial Nr.: ${i} - f: ${result.fitness()} - ag: ${result}");
    return result;
  });

  print("Use the version restricted on (50, 150) in each dimension.");
  10.times((int i) {
    var result = diff2(4, 25, 10, 10, 25, i, 1000, 10.0, ackley100, 50, 150);
    print(
        "Ackley100 (restricted) - Trial Nr.: ${i} - f: ${result.fitness()} - ag: ${result}");
    return result;
  });
}

/// The Ackley function centered at (10.0, ... , 10.0)
double Function(List<double>) ackley10 = (l) {
  List<double> m = l.map((d) {
    return d - 10.0;
  }).toList();

  return ackley(m);
};
