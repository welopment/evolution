import 'package:evolution/evolution.dart';

///
/// Linear Algorithm
///
/// A version of an evolutionary algorithm that
/// applies mutation an recombination on all
/// candidate solutions.
///
///
void linear(
  int positions, // number of variables, i.e dimensionality of the problem
  int sizeN, // number of [Agent]s in the population
  int bestN, // number of [Agent]s selected by fitness
  int randN, // number of [Agent]s randomly selected
  int seed, // seeding the random number generator
  int steps, // number of generations
  double w, // weighting factor used in differential evolution
  fitness, // evaluation function
) {
  Random r = Random(seed);

  int z = 0;
  Population p0 = generatePopulation(
    10, // size of Population
    2, // degrees of freedom
    r, // random number generator
    fitness, // fitness function
  );

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
    Population p8 = p1.sorted();
    Population p9 = p8.select(10);
    Population p10 = Population(p7 + p9, r, fitness);
    z++;
    p0 = p10;
  }
  Population res = p0.sorted().select(1);
  print(res);
}
