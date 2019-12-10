extension Times on int {
  /// Apply a function [f] as often as indicated by
  /// the value of the extended integer.
  ///
  void times(void Function(int) f) {
    int z = 0;
    while (z < this) {
      f(z);
      z++;
    }
  }

  /// A version of [Times] extension which hands a context [C] to
  /// the void Function(int, C) function.
  void timesC<C>(void Function(int, C) f, C c) {
    int z = 0;
    while (z < this) {
      f(z, c);
      z++;
    }
  }
}
