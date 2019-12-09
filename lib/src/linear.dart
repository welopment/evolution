import 'package:evolution/evolution.dart';

///
/// Linear Algorithm
///
/// A version of an evolutionary algorithm that
/// applies mutation an recombination on all
/// candidate solutions.
void linear(
  int positions, //
  int sizeN, //
  int bestN, //
  int randN, //
  int seed, //
  int steps, //
  double w,
  fitness,
) {
  Random r = Random(seed);

  int z = 0;
  Population p0 = gp(10, 2, r, fitness);

  double w = 1000.0;
  while (z < 10000) {
    double wz = w / (z == 0 ? 1 : z).toDouble();
    Population p01 = p0.sorted();
    Population p1 = p01.select(4);
    Population p2 = p1.mutation(wz);
    Population p3 = p2.sorted();
    Population p4 = p3.select(10);
    Population p5 = p4.crossover();
    Population p6 = p5.sorted();
    Population p7 = p6.select(10);
    Population p81 = p1.sorted();
    Population p8 = p81.select(10);
    Population p9 = Population(p7 + p8, r, fitness);
    z++;
    p0 = p9;
  }
  Population res = p0.sorted().select(1);
  print(res);
}
