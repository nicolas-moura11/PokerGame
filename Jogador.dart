import 'Carta.dart';
class Jogador {
  String nome;
  int fichas;
  List<Carta> mao = [];
  int apostaAtual = 0;

  Jogador(this.nome, this.fichas);

  void adicionarCarta(Carta carta) {
    mao.add(carta);
  }

  void limparMao() {
    mao.clear();
  }

  void adicionarFichas(int quantidade) {
    fichas += quantidade;
  }

  void mostrarMao() {
    print('$nome, suas cartas são:');
    for (var carta in mao) {
      print(' - $carta');
    }
  }
}