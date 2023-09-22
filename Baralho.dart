// Classe Baralho.dart
import 'Carta.dart';

class Baralho {
  final List<Carta> cartas = [];

  Baralho() {
    final naipes = ['Copas', 'Ouros', 'Paus', 'Espadas'];
    final valores = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];

    for (final naipe in naipes) {
      for (final valor in valores) {
        cartas.add(Carta(naipe, valor));
      }
    }
  }

  void embaralhar() {
    cartas.shuffle();
  }

  Carta distribuirCarta() {
    return cartas.removeLast();
  }
}
