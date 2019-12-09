import 'package:evolution/evolution.dart';

///
/// Differential Evolution.
///
/// This is an custom version of Differential Evolution.
/// DE is originally due to Storn and Price.

/// public interface
double differential(
  int positions, //
  int sizeN, //
  int bestN, //
  int randN, //
  int diffN, //
  int seed, //
  int steps, //
  double w, //
  double Function(List<double>) fitness, //
) =>
    diff(
      positions, //
      sizeN, //
      bestN, //
      randN, //
      diffN, //
      seed, //
      steps, //
      w,
      fitness,
    ).fitness();

/// A version of Differential Evolution with unrestricted search space.
Agent diff(
  int positions, //
  int sizeN, //
  int bestN, //
  int randN, //
  int diffN, //
  int seed, //
  int steps, //
  double w, //
  double Function(List<double>) fitness, //
) {
  //int seed = DateTime.now().millisecond;
  Random r = Random(seed);

  int z = 0;
  Population p0 = gp(sizeN, positions, r, fitness);

  while (z < steps) {
    double wz = w / ((z == 0 ? 1 : z)).toDouble();

    /*
    // random survivors
    Population p01 = p0.copy();
    p01.shuffle(r.r);
    Population rand = p01.select(randN);
    */

    // best survivors
    Population p02 = p0.copy();
    Population p021 = p02.sorted();
    Population best = p021.select(bestN);

    // mutation
    Population p03 = p0.copy();
    Population mutated = p03.mutation(wz / 10.0);

    Population differential = mutated.differential(diffN, wz * 10.0);

    // combine candidate solutions
    Population all = Population(
        /*rand + */ best + differential,
        r,
        fitness);
    Population p8 = all.copy();
    Population p9 = p8.sorted();
    Population p10 = p9.select(sizeN);

    p0 = p10;
    z++;
  }
  Population res = p0.sorted().select(1);
  //print(res);
  return res.first;
}

/// A version of Differential Evolution with restricted search space.

Agent diff2(
  int positions, //
  int sizeN, //
  int bestN, //
  int randN, //
  int diffN, //
  int seed, //
  int steps, //
  double w, //
  double Function(List<double>) fitness, //
  double lower, //
  double upper, //
) {
  //int seed = DateTime.now().millisecond;
  Random r = Random(seed);

  int z = 0;
  Population p0 = gp(sizeN, positions, r, fitness);

  while (z < steps) {
    double wz = w / ((z == 0 ? 1 : z)).toDouble();

    /*
    // random survivors
    Population p01 = p0.copy();
    p01.shuffle(r.r);
    Population rand = p01.select(randN);
    */

    // best survivors
    Population p02 = p0.copy();
    Population p021 = p02.sorted();
    Population best = p021.select(bestN);

    // mutation
    Population p03 = p0.copy();
    Population mutated = p03.mutation(wz / 10.0).confined(lower, upper);

    Population differential = mutated.differential(diffN, wz * 10.0);

    // combine
    Population all = Population(
        /*rand + */ best + differential,
        r,
        fitness);
    Population p8 = all.copy();
    Population p9 = p8.sorted();
    Population p10 = p9.select(sizeN);

    p0 = p10;
    z++;
  }
  Population res = p0.sorted().select(1);
  return res.first;
}
