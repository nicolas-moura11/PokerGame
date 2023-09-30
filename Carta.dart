class Carta {
  int value;
  String suit;
  String color;

  Carta(this.value, this.suit) : color = _calculateColor(suit);

  static String _calculateColor(String suit) {
    if (suit == "Copas" || suit == "Ouros") {
      return "Red";
    } else if (suit == "Paus" || suit == "Espadas") {
      return "Black";
    } else {
      return "Unknown";
    }
  }

  int getValue()
  {
    return this.value;
  }

  String getSuit()
  {
    return this.suit;
  }

  String getColor()
  {
    return this.color;
  }

  String convertValueToName()
  {
    switch (this.value) {
      case 1:
        return "Ás";
      case 2:
        return "Dois";
      case 3:
        return "Três";
      case 4:
        return "Quatro";
      case 5:
        return "Cinco";
      case 6:
        return "Seis";
      case 7:
        return "Sete";
      case 8:
        return "Oito";
      case 9:
        return "Nove";
      case 10:
        return "Dez";
      case 11:
        return "Valete";
      case 12:
        return "Rainha";
      case 13:
        return "Rei";
      case 14:
        return "Ás";
      default:
        return "Valor não válido";
    }
  }

  @override
  String toString() {
    return (convertValueToName() + " de ") + this.suit;
  }

  static void main(List<String> args)
  {
    Carta card = new Carta(1, "Copas");
    print(card.toString());
  }
}
