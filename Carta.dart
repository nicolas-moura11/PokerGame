class Carta {
  late String naipe;
  late String value;

  Carta(this.naipe, this.value);

  @override
  String toString() {
    return '$value of $naipe';
  }
}
