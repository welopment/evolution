import 'xlist.dart';
import 'package:evolution/evolution.dart';

/// A Population is a collection of candidate solutions, called [Agent]s,
/// which inherits its behavior from ListMixin via [XList]. [XList] is subclassable
/// version of [ListMixin].
/// A [Population] therefore can be treated like a List for the purpose of generating
/// and improving candidate solutions.
///
class Population extends XList<Agent> {
  /// Constructs a [Population] of [Agent]s from a List [l],
  /// a random generator [Random], and a evaluation function [fitness]
  Population(List<Agent> l, this.r, this.fitness) {
    base = l;
  }
  //List<Agent> l;
  Random r;

  /// A function that evaluates the fitness on demand.
  /// The function is assigned by the Constructor and
  /// is a called on each [Agent].
  double Function(Agent) fitness;

  @override
  Population copy() {
    return Population(this.map((Agent a) => a.copy()).toList(), r, fitness);
  }

  /// A functional version of [mutation], calling mutation on each [Agent].
  Population mutation([double w = 1.0]) {
    return Population(
        this.map((Agent a) => a.mutation(w)).toList(), r, fitness);
  }

  /// A imperative version of [mutation], calling mutationI on each [Agent].
  Population mutationI([double w = 1.0]) {
    this.forEach((Agent a) => a.mutationI(w));
    return this;
  }

  Population crossover() {
    List<Agent> lr = List<Agent>();
    for (var a1 in this) {
      for (var a2 in this) {
        lr.add(a1.crossover(a2));
      }
    }
    ;
    return Population(lr, r, fitness);
  }

  /// Generate [Population] by calling the implementation of Differential Evolution
  /// of each indivicual [Agent], i.e. adding the weighted difference
  /// of two randomly [select]ed [Agent]s to another randomly [select]ed [Agent].
  Population differential(int n, [double w = 1.0]) {
    if (this.length < 3) {
      throw Exception("differential needs at least 3 Agents");
    }
    List<Agent> lr = List<Agent>();
    Population tc = this.copy();

    n.times((i) {
      tc.shuffle(r.r);
      Population ts = tc.select(3);
      lr.add(ts[0].differential(ts[1], ts[2], w));
    });
    return Population(lr, r, fitness);
  }

  /// Constructs a new population [Population] by applying a function to the indexes of
  /// the individuals from the resulting population.This constructor is similar to the
  /// respective contructor of List with the same name.
  static Population generate(
    int len, // size of the resulting Population
    Agent Function(int) f, // generator function
    Random r, // random number generator object handed to each Agent
    double Function(List<double>)
        fitness, // evaluation function handed to each Agent
  ) {
    var pr = List.generate(len, f, growable: true);
    return Population(pr, r, fitness);
  }

  /// Returns an Agent with values guaranteed to be between
  /// given lower an upper bound. Functional version.
  Population confined(lower, upper) => Population(
      this.map((d) => d.confined(lower, upper)).toList(), r, this.fitness);

  /// Returns an Agent with values guaranteed to be between
  /// given lower an upper bound. Imperative version.
  Population confinedI(lower, upper) => Population(
      this.map((d) => d.confinedI(lower, upper)).toList(), r, this.fitness);

  /// Creates a new Population by selecting, i.e. copying, the first [i] individuals
  /// from this [Population]. Functional version.

  Population select(int i) {
    int l = this.length;
    int s = i > l ? l : i;
    // better: int s = i > l ? l : i >= 0 ? i : l;
    return Population(this.sublist(0, s), r, fitness);
  }

  /// Selects the first [i] individuals of this [Population] by dropping
  /// all other individuals from this [Population]. Imperative version of [select].
  Population selectI(int i) {
    int l = this.length;
    int s = i > l ? l : i >= 0 ? i : l;
    this.removeRange(s, l);
    return this;
  }

  int _ordering(Agent a1, Agent a2) {
    if (a1.fitness() > a2.fitness()) {
      return 1;
    } else if (a1.fitness() < a2.fitness()) {
      return -1;
    } else {
      return 0;
    }
  }

  /// Constructs a new [Population] by copying the original population and sorting
  /// it by fitness of the individuals using [_ordering].
  Population sorted() {
    List<Agent> ret = base.map((Agent a) => Agent(a.base, r, a.f)).toList();
    ret.sort(_ordering);
    return Population(ret, r, fitness);
  }

  /// Sorts this [Population] by fitness of the individuals using [_ordering].
  /// This is an imperativ version of [sorted].
  Population sortedI() {
    base.sort(_ordering);
    return this;
  }

  @override
  String toString() {
    return base.fold(
        "Population",
        (String s, Agent d) =>
            s + "\n " + d.toString() + " fit: " + d.fitness().toString());
  }
}
/*
// Rastrigin
double rastrigin(List<double> x) {
  int numberOfVariables = x.length;
  double result = 0.0;
  double a = 10.0;
  double w = 2 * math.pi;

  for (int i = 0; i < numberOfVariables; i++) {
    result += x[i] * x[i] - a * math.cos(w * x[i]);
  }
  result += a * numberOfVariables;
  return result;
}

// Ackley
//Ackley's Function
double ackley(List<double> variable) {
  final int dim = variable.length;

  final double a = 20;
  final double b = 0.2;
  final double c = 2 * math.pi;

  double sum1 = 0;
  double sum2 = 0;
  for (int i = 0; i < dim; i++) {
    sum1 += variable[i] * variable[i];
    sum2 += math.cos(c * variable[i]);
  }

  sum1 = -b * math.sqrt((1.0 / dim) * sum1);
  sum2 = (1.0 / dim) * sum2;

  return ((-a * math.exp(sum1)) - math.exp(sum2)) + a + math.exp(1);
}

double rosenbrock(List<double> x) {
  double ex = math.pow(x[0], 2).toDouble();
  double a = math.pow(1 - x[0], 2).toDouble();
  double b = math.pow(x[1] - ex, 2).toDouble();
  return a + (100.0 * b);
}
*/
