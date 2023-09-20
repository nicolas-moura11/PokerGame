import 'Carta.dart';

class Baralho{
  late List<Carta> cartas = [];

  Baralho() {
    cartas = criarBaralho();
  }

  List<Carta> criarBaralho() {
    final naipes = ['Espadas', 'Copas', 'Ouros', 'Paus'];
    final valores = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Valete', 'Dama', 'Rei', 'Ás'];
    List<Carta> baralho = [];

    for (var naipe in naipes) {
      for (var valor in valores) {
        baralho.add(Carta(naipe, valor));
      }
    }

    return baralho;
  }

  void embaralhar() {
    cartas.shuffle();
  }

  Carta distribuirCarta() {
    return cartas.removeAt(0);
  }
}