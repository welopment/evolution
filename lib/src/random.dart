import "dart:math" as math;

class Random {
  Random(int seed) : r = math.Random(seed);
  math.Random r;

  double nextDouble() => r.nextDouble() * 2.0 - 1.0;
}
