import 'package:evolution/evolution.dart';

Population gp(
  int lengthPopulation,
  int lengthAgent,
  Random r,
  fitness,
) {
  List<Agent> as = XList.generate<Agent>(
    lengthPopulation,
    (i) => Agent(
      List.generate(lengthAgent, (i) => 0.0),
      r,
      fitness,
    ),
  ).toList();
  Population rp = Population(
    as,
    r,
    fitness,
  );
  return rp;
}

/// Generate a population
Population gpf(
  int lengthPopulation,
  int lengthAgent,
  Random r,
  double Function(List<double>) f,
) {
  List<Agent> xl = XList.generate<Agent>(
    lengthPopulation,
    (i) => Agent(List.generate(lengthAgent, (int i) => 0.0), r, f),
  ).toList();
  Population rp = Population(xl, r, f);

  return rp;
}
