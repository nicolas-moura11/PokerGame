// Classe MaoDoJogador.dart
import 'Carta.dart';

class MaoDoJogador {
  late List<Carta> cartas;

  MaoDoJogador() {
    cartas = [];
  }

  void adicionarCarta(Carta carta) {
    cartas.add(carta);
  }

  @override
  String toString() {
    return cartas.map((carta) => carta.toString()).join(', ');
  }

  int fichas = 0;

  void adicionarFichas(int quantidade) {
    fichas += quantidade;
    if (quantidade > 0) {
      print('Você adicionou $quantidade fichas à sua pilha.');
    } else if (quantidade < 0) {
      print('Você removeu ${-quantidade} fichas da sua pilha.');
    } else {
      print('Suas fichas permaneceram inalteradas.');
    }
  }

  void limparMao() {
    cartas.clear();
  }

// Você pode adicionar métodos adicionais aqui, se necessário.
}
