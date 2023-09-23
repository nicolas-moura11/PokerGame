


enum Acao { Desistir, Passar, Apostar, Pagar, Aumentar }

class Carta {
  final String naipe;
  final String valor;

  Carta(this.naipe, this.valor);

  // Método para obter o valor numérico da carta
  int valorCarta() {
    switch (valor) {
      case '2':
        return 2;
      case '3':
        return 3;
      case '4':
        return 4;
      case '5':
        return 5;
      case '6':
        return 6;
      case '7':
        return 7;
      case '8':
        return 8;
      case '9':
        return 9;
      case '10':
        return 10;
      case 'J':
        return 11;
      case 'Q':
        return 12;
      case 'K':
        return 13;
      case 'A':
        return 14;
      default:
        throw Exception('Valor de carta inválido: $valor');
    }
  }

  @override
  String toString() {
    return '$valor de $naipe';
  }
}
