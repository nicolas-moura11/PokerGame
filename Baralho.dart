import 'dart:math';
import 'Carta.dart';

class Baralho {
  List<Carta> deck = [];

  Baralho() {
    reset();
    shuffleDeck();
  }

  void reset() {
    this.deck.clear();
    for (int i = 2; i < 15; i++) {
      deck.add(Carta(i, "Copas"));
    }
    for (int j = 2; j < 15; j++) {
      deck.add(Carta(j, "Ouros"));
    }
    for (int k = 2; k < 15; k++) {
      deck.add(Carta(k, "Espadas"));
    }
    for (int l = 2; l < 15; l++) {
      deck.add(Carta(l, "Paus"));
    }
  }

  void shuffleDeck() {
    List<Carta> tempDeck = [];
    while (this.deck.length > 0) {
      int randomIndex = Random().nextInt(this.deck.length);
      tempDeck.add(this.deck.removeAt(randomIndex));
    }
    this.deck = tempDeck;
  }

  Carta getNextCard() {
    return this.deck.removeLast();
  }

  int getRemainingCardCount() {
    return this.deck.length;
  }

  static void main(List<String> args) {
    Baralho sd = Baralho();
    print(sd.deck.toString());
    print(sd.getNextCard());
    print(sd.getNextCard());
    print(sd.getNextCard());
    print(sd.getNextCard());
    print(sd.getRemainingCardCount());
  }
}
