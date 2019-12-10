import 'package:evolution/evolution.dart';

import "xlist.dart";

/// An Agent is a single candidate solution of double values to be hosted in a [Population].
/// Each Agent inherits its behavior from ListMixin via [XList]. [XList] is subclassable
/// version of [ListMixin].
/// An [Agent] therefore can be treated like a List for the purpose of generating
/// and improving a sinlge candidate solution or testing its fitness.

class Agent extends XList<double> {
  Agent(List<double> l, this.r, this.f) {
    super.base = l;
  }
  double Function(List<double>) f;
  Random r;

  /// Generates a new [Agent] by calulating the arithmetic mean of
  /// each property of [this] and an [other] Agent
  Agent crossover(Agent other) {
    /*
    List<double> lret = <double>[];
    for (int i = 0; i < this.length; i++) {
      lret.add((this[i] + other[i]) / 2.0);
    }
    List<double> base = lret;
    return Agent(base, Random(0));
    */
    return Agent(this.mapz(other, (int i, d1, d2) => (d1 + d2) / 2.0).toList(),
        r, this.f);
  }

  double fitness() => this.f(this);

  @override
  Agent copy() => Agent(this.map((double d) => d).toList(), r, this.f);

  /*{
    List<double> lret = <double>[];

    for (int i = 0; i < this.length; i++) {
      lret.add(this[i]);
    }

    return Agent(lret, r);
  }*/

  /// Implementation of the Differential Evolution process on [Agent].
  /// This adds the weighted difference between each property of two
  /// other [Agent]s to the the respective property of this [Agent].
  /// The default weight is 1.0.
  Agent differential(Agent other1, Agent other2, [double w = 1.0]) {
    if (this.length != other1.length || this.length != other2.length) {
      throw Exception("Agent.differential: Different lengths.");
    }

    /*List<double> lret = <double>[];
    for (int i = 0; i < this.length; i++) {
      lret.add(((other2[i] - other1[i]) * w) + this[i]);
    }
    List<double> base = lret;
    return Agent(base, Random(0));*/

    return Agent(
        this
            .mapi((int i, double d) => ((other2[i] - other1[i]) * w) + d)
            .toList(),
        r,
        this.f);
  }

  /// A functional version of [mutation].
  Agent mutation([double w = 1.0]) => Agent(
      this.map((double d) => d + (r.nextDouble() * w)).toList(), r, this.f);

  /// An imperative version of [mutation].
  Agent mutationI([double w = 1.0]) {
    this.forEach((double d) => d + (r.nextDouble() * w));
    return this;
  }

  /*{
    List<double> lret = <double>[];
    for (int i = 0; i < this.length; i++) {
      lret.add(this[i] + (r.nextDouble() * w));
    }
    return Agent(lret, r); 
  }*/

  /// Returns an Agent with values guaranteed to be between
  /// given lower an upper bound. Funtional version.
  Agent confined(lower, upper) => Agent(
      this.map((d) {
        double k = d > upper ? (d % upper) : d;
        double m = k < lower ? (k % lower) : k;
        return m;
      }).toList(),
      r,
      this.f);

  /// Returns an Agent with values guaranteed to be between
  /// given lower an upper bound. Imperative version.
  Agent confinedI(lower, upper) {
    // replace with forEachi
    this.mapi((int i, double d) {
      double k = d > upper ? (d % upper) : d;
      double m = k < lower ? (k % lower) : k;
      this[i] = m;
      return m;
    });
    return this;
  }

  /// Generates an Agent of size [len] from values returned by a function [f]
  /// applied on the indices of the properties of the Agent.
  static Agent generate(int len, double Function(int) f, Random random,
      double Function(List<double>) fit) {
    return Agent(List.generate(len, f, growable: false), random, fit);
  }

  @override
  String toString() {
    return this
        .base
        .fold("Agent", (String s, double d) => s + ", " + d.toString());
  }
}
