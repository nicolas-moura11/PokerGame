import 'dart:io';
import 'dart:math';

enum Acao { Desistir, Passar, Apostar, Pagar, Aumentar }

class Carta {
  final String naipe;
  final String valor;

  Carta(this.naipe, this.valor);

  @override
  String toString() {
    return '$valor de $naipe';
  }
}
