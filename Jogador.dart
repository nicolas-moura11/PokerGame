import 'Carta.dart';

class Jogador {
  String name;
  int balance;
  List<Carta> holeCards = List<Carta>.filled(2, Carta(0, ""));
  bool isInGame;

  Jogador({
    required this.name,
    required this.balance,
    required this.holeCards,
  }) : isInGame = true;

  String getName() {
    return this.name;
  }

  int getBalance() {
    return this.balance;
  }

  void addToBalance(int additionAmount) {
    this.balance += additionAmount;
  }

  void reduceFromBalance(int reduceAmount) {
    this.balance -= reduceAmount;
  }

  List<Carta> getHoleCards() {
    return this.holeCards;
  }

  void setHoleCards(List<Carta> holeCards) {
    this.holeCards = holeCards;
  }

  bool getIsInGame() {
    return this.isInGame;
  }

  void setIsInGame(bool isInGame) {
    this.isInGame = isInGame;
  }

  @override
  String toString() {
    return "Jogador: ${this.name} tem um saldo de: ${this.balance}.\nCartas: ${this.holeCards}.\nEm Jogo: ${this.isInGame}";
  }

  static void main(List<String> args) {
    List<Carta> holeCards = [Carta(1, "Copas"), Carta(2, "Copas")];
    Jogador p1 = Jogador(name: "Jogador1", balance: 100, holeCards: holeCards);
    print(p1.getName());
    print(p1.getBalance());
    p1.addToBalance(2);
    print(p1.getBalance());
    p1.reduceFromBalance(2);
    print(p1.getBalance());
    print(p1.getHoleCards());
    print(p1.toString());
    List<Carta> holeCards2 = [Carta(10, "Copas"), Carta(14, "Ouros")];
    p1.setHoleCards(holeCards2);
    print(p1.getHoleCards());
  }
}
