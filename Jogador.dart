import 'Carta.dart';
class Jogador {
  String nome;
  List<Carta> holeCards;
  int fichas;

  Jogador(this.nome, this.holeCards, this.fichas);

  void mostrarHoleCards() {
    print('$nome tem as seguintes cartas hole cards:');
    for (var carta in holeCards) {
      print(' - $carta');
    }
  }
}