extension Times on int {
  void times(void Function(int) f) {
    int z = 0;
    while (z < this) {
      f(z);
      z++;
    }
  }

  void timesC<C>(void Function(int, C) f, C c) {
    int z = 0;
    while (z < this) {
      f(z, c);
      z++;
    }
  }
}
