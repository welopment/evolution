import 'package:evolution/evolution.dart';

///
/// Parallel Algorithm
///
/// An algorithm based on splitting the population
/// into one subpopulation subject to mutation and recombination
/// and another subpopulation of survivors that remain unchanged.
///
void parallelPopulations(
  int positions, //
  int sizeN, //
  int bestN, //
  int randN, //
  int seed, //
  int steps, //
  double w,
  fitness,
) {
  //int seed = DateTime.now().millisecond;
  Random r = Random(seed);

  int z = 0;
  Population p0 = gp(sizeN, positions, r, fitness);

  while (z < steps) {
    double wz = w / (z == 0 ? 1 : z).toDouble();

    // random survivors
    Population p01 = p0.copy();
    p01.shuffle(r.r);
    Population rand = p01.select(randN);

    // best survivors
    Population p02 = p0.copy();
    Population p021 = p02.sorted();
    Population best = p021.select(bestN);

    // mutation
    Population p03 = p0.copy();
    Population mutated = p03.mutation(wz);

    //best crossover
    Population p3 = best.copy();
    Population p4 = p3.select(bestN);
    Population bestCrossover = p4.crossover();

    //rand crossover
    Population p6 = rand.copy();
    Population p7 = p6.select(randN);
    Population randCrossover = p7.crossover();

    // all
    Population all = Population(
        /*rand +*/ best + mutated + bestCrossover + randCrossover,
        r,
        fitness);
        
    Population p8 = all.copy();
    Population p9 = p8.sorted();
    Population p10 = p9.select(sizeN);

    p0 = p10;
    z++;
  }
  Population res = p0.sorted().select(1);
  print(res);
}
