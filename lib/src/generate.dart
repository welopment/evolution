import 'package:evolution/evolution.dart';

///
/// Generate an initial [Population] of [Agents]
/// with all variables == 0.0.
///
Population generatePopulation(
  int sizePopulation,
  int sizeAgent,
  Random r,
  fitness, // fitness function
) {
  List<Agent> as = XList.generate<Agent>(
    sizePopulation,
    (i) => Agent(
      List.generate(sizeAgent, (i) => 0.0),
      r,
      fitness,
    ),
  ).toList();
  Population rp = Population(
    as, // List of Agents
    r, // random number generator
    fitness, // fitness function
  );
  return rp;
}
