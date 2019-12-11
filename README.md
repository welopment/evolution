Evolution
=========

An optimization library based on evolutionary algorithms for use in dart and flutter projects.

# Getting started

Add the dependency to your pubspec.yaml file:

```yaml
dependencies:
  evolution: #latest version
```

Add the import statement to your source files:

```dart
import 'package:evolution/evolution.dart';
```

Or, give it a try and run the example:

```dart
dart ./example/main.dart 
```
The example consists of some simple optimization tasks: 

* Sphere100 is a version of the sphere function with global minimum at (100.0, ..., 100.0).
* Sphere100 (restricted) is the same problem solved on a restricted search space.
* Ackley10 is a version of the ackley function with global minimum at (10.0, ..., 10.0).
* Ackley100 is  a version of the ackley function with global minimum at (100.0, ..., 100.0).
* Ackley100 (restricted) is the same problem solved on a restricted search space.

It will run 10 trials of the same problem, printing the number of the trial , the fitness value [f] (small is better) and the solution [ag] represented by an Agent.

# Build a simple algorithm

1. Generate an initial population of candidate solutions (Agents), each of which will have property values of 0.0: 

```dart
Population start = generatePopulation(
    sizeN, // number of [Agent]s in the population
    positions, // number of variables, i.e dimensionality of the problem
    Random(seed), // pass a random number generator object to the Population
    fitness, // gibe each Agents an evaluation function
  );
```

2. Mutate the population. You can specify a weight factor to control the impact of mutation. 

```dart
Population mutated = start.mutation();
```

Instead, you can use the imperative version:

```dart
Population mutated = start.mutationI();
```

3. Generate a differential population of size [diffN].  

```dart
Population differential = mutated.differential(diffN);
```

4. Select a portion of the population of [sizeN] as survivors.  

```dart
Population selected = differential.sorted().select(sizeN);
```

Instead, you can use the imperative version:

```dart
Population selected = differential.sortedI().selectI(sizeN);
```


5. Loop!


# Try Differential Evolution

A more specific algorithm is Differential Evolution. It is defined as:

```dart
/// A version of Differential Evolution with unrestricted search space.
Agent diff(
  int positions, // number of variables, i.e dimensionality of the problem
  int sizeN, // number of [Agent]s in the population
  int bestN, // number of [Agent]s selected by fitness
  int randN, // number of [Agent]s randomly selected
  int diffN, // number of [Agent]s generated by differential evolution
  int seed, // seeding the random number generator
  int steps, // number of generations
  double w, // weighting factor used in differential evolution
  double Function(List<double>) fitness, // evaluation function
) {
  Random r = Random(seed);

  int z = 0;
  Population p0 = generatePopulation(
    sizeN,
    positions,
    r,
    fitness,
  );

  while (z < steps) {
    double wz = w / ((z == 0 ? 1 : z)).toDouble();
    
    // best survivors
    Population best = p0.sorted().select(bestN);

    // mutation
    Population mutated = p0.mutation(wz / 10.0);

    // differential operation
    Population differential = mutated.differential(diffN, wz * 10.0);

    // combine subpopulations
    Population all = Population(
        best + differential,
        r,
        fitness);

    // best survivors of combined population
    Population result = all.sorted().select(sizeN);

    p0 = result;
    z++;
  }
  Population res = p0.sorted().select(1);
  return res.first;
}
```

To improve performace, use a restricted search space and the corresponding version of the algorithm: 

```dart
Agent diff2(
  int positions, //dimensionality of the problem
  int sizeN, // number of solution candidates to be entered in each new generation 
  int bestN, // number of best solutions selected within on generation 
  int randN, // number of random solutions selected within on generation with arbitrary fitness
  int diffN, //  number of solution candidates generated by differential process in  each generation 
  int seed, // initializing the pseudo-random number generator 
  int steps, // number of generations 
  double w, // spread of mutation 
  double Function(List<double>) fitness, // evaluation function for solution candidates
  double lower, // lower bound of the search space
  double upper, // upper bound of the search space
) {
  Random r = Random(seed);

  int z = 0;
  Population p0 = generatePopulation(sizeN, positions, r, fitness);

  while (z < steps) {
    double wz = w / ((z == 0 ? 1 : z)).toDouble();

    // best survivors
    Population best = p0.sorted().select(bestN);

    // mutation
    Population mutatedConfined = p0.mutation(wz / 10.0).confined(lower, upper);

    // differential operation
    Population differential = mutatedConfined.differential(diffN, wz * 10.0);

    // combine subpopulations
    Population all = Population(
        best + differential,
        r,
        fitness);

    // best survivors of combined population
    Population result = all.sorted().select(sizeN);

    p0 = result;
    z++;
  }

  Population res = p0.sorted().select(1);
  return res.first;
}
```
