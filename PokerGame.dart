import 'Carta.dart';
import 'Baralho.dart';
import 'Jogador.dart';
import 'dart:io';

class PokerGame {
  late List<Jogador> JogadorList;
  late Baralho gameDeck;
  late List<Carta?> communityCards;
  late int winningPot;
  late int smallBlind;
  late int bigBlind;
  late Jogador dealer;
  late Jogador JogadorSmallBlind;
  late Jogador JogadorBigBlind;
  late List<int?> JogadorsTotalBets;
  late bool keepPlaying;
  String next() {
    return stdin.readLineSync() ?? '';
  }

  PokerGame(int smallBlind) {
    JogadorList = [];
    gameDeck = Baralho();
    communityCards = List<Carta>.filled(5, Carta(0, ''));
    winningPot = 0;
    this.smallBlind = smallBlind;
    this.bigBlind = smallBlind * 2;
    keepPlaying = true;
    dealer = Jogador(name: 'Dealer', balance: 0, holeCards: []);
    JogadorBigBlind = Jogador(name: 'JogadorBigBlind', balance: 0, holeCards: []);
    JogadorSmallBlind = Jogador(name: 'JogadorSmallBlind', balance: 0, holeCards: []);

    JogadorSetup();
    while (keepPlaying) {
      bettingRound(true);
      print("1");
      dealNextCommunityCard();
      print("2");
      bettingRound(false);
      print("3");
      dealNextCommunityCard();
      print("4");
      bettingRound(false);
      print("5");
      dealNextCommunityCard();
      print("6");
      findWinner();
      print("7");
      rotateJogadorPositions();
      print("Deseja jogar outra rodada? (Y/N)");
      if (next().toLowerCase().contains("n")) {
        keepPlaying = false;
      }
    }
  }



  void JogadorSetup() {
    bool addAnotherJogador = true;
    while (addAnotherJogador) {
      addAnotherJogador = false;
      addJogador();
      print("Deseja adicionar outro jogador? (Y/N)");
      if (stdin.readLineSync()!.toLowerCase().contains("y")) {
        addAnotherJogador = true;
      }
    }
    this.dealer = JogadorList[0];
    if (JogadorList.length > 2) {
      this.JogadorSmallBlind = JogadorList[1];
      this.JogadorBigBlind = JogadorList[2];
    }
    this.JogadorsTotalBets = List<int>.filled(JogadorList.length, 0);
    payOutBlinds();
  }



  void rotateJogadorPositions() {
    int dealerIndex = this.JogadorList.indexOf(this.dealer);
    int smallBlindIndex = this.JogadorList.indexOf(this.JogadorSmallBlind);
    int bigBlindIndex = this.JogadorList.indexOf(this.JogadorBigBlind);
    if (dealerIndex < (this.JogadorList.length - 1)) {
      this.dealer = this.JogadorList[dealerIndex + 1];
    } else {
      this.dealer = this.JogadorList[0];
    }
    if (smallBlindIndex < (this.JogadorList.length - 1)) {
      this.JogadorSmallBlind = this.JogadorList[smallBlindIndex + 1];
    } else {
      this.JogadorSmallBlind = this.JogadorList[0];
    }
    if (bigBlindIndex < (this.JogadorList.length - 1)) {
      this.JogadorBigBlind = this.JogadorList[bigBlindIndex + 1];
    } else {
      this.JogadorBigBlind = this.JogadorList[0];
    }
  }


  void payOutBlinds()
  {
    if (this.JogadorList.length > 2) {
      this.JogadorSmallBlind.reduceFromBalance(this.smallBlind);
      this.JogadorsTotalBets[this.JogadorList.indexOf(JogadorSmallBlind)] = this.smallBlind;
      this.JogadorBigBlind.reduceFromBalance(this.bigBlind);
      this.JogadorsTotalBets[this.JogadorList.indexOf(this.JogadorBigBlind)] = this.bigBlind;
    }
  }

  void addJogador() {
    stdout.write("Entre com o nome do jogador ");
    String tempName = stdin.readLineSync()!;

    stdout.write("Saldo inicial de $tempName  ");
    int tempBalance = int.parse(stdin.readLineSync()!);

    List<Carta> tempHoleCards = [gameDeck.getNextCard(), gameDeck.getNextCard()];

    JogadorList.add(Jogador(name: tempName, balance: tempBalance, holeCards: tempHoleCards));
    print(JogadorList[JogadorList.length - 1].toString());
  }

  void bettingRound(bool isPreFlop)
  {
    int startingJogadorIndex;
    if (isPreFlop) {
      startingJogadorIndex = (this.JogadorList.indexOf(this.JogadorSmallBlind) + 2);
    } else {
      startingJogadorIndex = this.JogadorList.indexOf(this.JogadorSmallBlind);
    }
    int currentJogadorIndex = startingJogadorIndex;
    for (int i = 0; i < this.JogadorList.length; i++) {
      if (this.JogadorList[currentJogadorIndex].getIsInGame()) {
        currentJogadorIndex = individualBet(currentJogadorIndex);
      }
      currentJogadorIndex = (currentJogadorIndex + 1) % this.JogadorList.length; // Avança para o próximo jogador
    }
    while (!areAllBetsEqual()) {
      currentJogadorIndex = individualBet(currentJogadorIndex);
    }
  }


  int individualBet(int currentJogadorIndex)
  {
    String checkOrCall = (areAllBetsEqual() ? "check" : "call");
    printCommunityCards();
    print("O Pote é: ${this.winningPot}");
    print("${this.JogadorList[currentJogadorIndex].toString()}\nVocê deseja realizar fold, $checkOrCall, ou raise?");
    String answer = stdin.readLineSync()!;
    if (answer.toLowerCase().contains("fold")) {
      fold(this.JogadorList[currentJogadorIndex]);
    } else {
      if (answer.toLowerCase().contains("call")) {
        call(this.JogadorList[currentJogadorIndex]);
      } else {
        if (answer.toLowerCase().contains("raise")) {
          raise(this.JogadorList[currentJogadorIndex]);
        }
      }
    }
    currentJogadorIndex++;
    if (currentJogadorIndex == this.JogadorList.length) {
      currentJogadorIndex = 0;
    }
    return currentJogadorIndex;
  }


  bool areAllBetsEqual()
  {
    int highestBet = getHighestBet();
    for (int j = 0; j < this.JogadorsTotalBets.length; j++) {
      if ((this.JogadorsTotalBets[j] ?? 0) < highestBet && this.JogadorList[j].getIsInGame()) {
        return false;
      }
    }
    return true;
  }



  int getHighestBet()
  {
    int highestBet = 0;
    for (int i = 0; i < this.JogadorsTotalBets.length; i++) {
      int currentBet = this.JogadorsTotalBets[i] ?? 0;
      if ((currentBet > highestBet) && this.JogadorList[i].getIsInGame()) {
        highestBet = currentBet;
      }
    }
    return highestBet;
  }



  void fold(Jogador Jogador)
  {
    Jogador.setIsInGame(false);
  }

  void call(Jogador Jogador)
  {
    int highestBet = getHighestBet();
    int JogadorIndex = this.JogadorList.indexOf(Jogador);

    if (JogadorIndex >= 0) {
      int JogadorsBetDifference = highestBet - (this.JogadorsTotalBets[JogadorIndex] ?? 0);
      Jogador.reduceFromBalance(JogadorsBetDifference);
      this.JogadorsTotalBets[JogadorIndex] = (this.JogadorsTotalBets[JogadorIndex] ?? 0) + JogadorsBetDifference;
      updateWinningPot();
    }
  }


  void raise(Jogador Jogador)
  {
    stdout.write('${Jogador.getName()}: Quanto você quer aumentar');
    int raiseAmount = int.parse(stdin.readLineSync()!);
    call(Jogador);
    Jogador.reduceFromBalance(raiseAmount);
    this.JogadorsTotalBets[this.JogadorList.indexOf(Jogador)] = (this.JogadorsTotalBets[this.JogadorList.indexOf(Jogador)] ?? 0) + raiseAmount;
    updateWinningPot();
  }


  void updateWinningPot()
  {
    this.winningPot = 0;
    for (int i = 0; i < this.JogadorsTotalBets.length; i++) {
      this.winningPot += this.JogadorsTotalBets[i] ?? 0;
    }
  }


  void dealNextCommunityCard()
  {
    if (this.communityCards[0] == null) {
      this.communityCards[0] = this.gameDeck.getNextCard();
      this.communityCards[1] = this.gameDeck.getNextCard();
      this.communityCards[2] = this.gameDeck.getNextCard();
    } else {
      if (this.communityCards[3] == null) {
        this.communityCards[3] = this.gameDeck.getNextCard();
      } else {
        if (this.communityCards[4] == null) {
          this.communityCards[4] = this.gameDeck.getNextCard();
        }
      }
    }
  }

  void printCommunityCards()
  {
    print("-----------------------------------------------------");
    if (((this.communityCards[0] != null) && (this.communityCards[3] == null)) && (this.communityCards[4] == null)) {
      print("Flop:");
    } else {
      if ((this.communityCards[3] != null) && (this.communityCards[4] == null)) {
        print("Turn:");
      } else {
        if (this.communityCards[4] != null) {
          print("River:");
        }
      }
    }
    print(this.communityCards.toString());
    print("-----------------------------------------------------");
  }


  void findWinner()
  {
    List<Jogador> winningJogadors = [];
    winningJogadors = royalFlush();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    winningJogadors = straightFlush();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    winningJogadors = fourOfAKind();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    winningJogadors = fullHouse();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    winningJogadors = flush();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    winningJogadors = straight();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    winningJogadors = threeOfAKind();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    winningJogadors = twoPair();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    winningJogadors = onePair();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    winningJogadors = highCard();
    if (winningJogadors.length > 0) {
      handleWinners(winningJogadors);
      return;
    }
    print("Vencedor(es) é: " + winningJogadors.map((Jogador) => Jogador.toString()).join(", "));

  }



  void handleWinners(List<Jogador> winningJogadors)
  {
    int tempWinnerAward = (this.winningPot ~/ winningJogadors.length);
    for (int i = 0; i < winningJogadors.length; i++) {
      winningJogadors[i].addToBalance(tempWinnerAward);
    }
    this.winningPot = 0;
  }

  List<Carta?> tempJogadorsCardsAll(Jogador Jogador)
  {
    List<Carta?> result = [];

    for (int i = 0; i < this.communityCards.length; i++) {
      result.add(this.communityCards[i]);
    }

    result.add(Jogador.getHoleCards()[0]);
    result.add(Jogador.getHoleCards()[1]);

    return result;
  }

  List<Jogador> royalFlush()
  {
    List<Jogador> winningJogadors = [];
    for (int i = 0; i < this.JogadorList.length; i++) {
      int hearts = 0;
      int diamonds = 0;
      int spades = 0;
      int clubs = 0;
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<int> tempJogadorCards = [];
        List<Carta?> tempCardsAll = tempJogadorsCardsAll(tempJogador);
        for (int l = 0; l < tempCardsAll.length; l++) {
          if (tempCardsAll[l] != null) {
            if (tempCardsAll[l]!.getSuit().contains("Copas")) {
              hearts++;
            }
            if (tempCardsAll[l]!.getSuit().contains("Ouros")) {
              diamonds++;
            }
            if (tempCardsAll[l]!.getSuit().contains("Espadas")) {
              spades++;
            }
            if (tempCardsAll[l]!.getSuit().contains("Paus")) {
              clubs++;
            }
          }
        }
        if (hearts >= 5) {
          tempJogadorCards = getValuesOfSuit(tempCardsAll, "Copas");
        } else if (diamonds >= 5) {
          tempJogadorCards = getValuesOfSuit(tempCardsAll, "Ouros");
        } else if (spades >= 5) {
          tempJogadorCards = getValuesOfSuit(tempCardsAll, "Espadas");
        } else if (clubs >= 5) {
          tempJogadorCards = getValuesOfSuit(tempCardsAll, "Paus");
        }

        if (tempJogadorCards.contains(10) && tempJogadorCards.contains(11) && tempJogadorCards.contains(12) && tempJogadorCards.contains(13) && tempJogadorCards.contains(14)) {
          winningJogadors.add(tempJogador);
        }
      }
    }
    return winningJogadors;
  }




  List<Jogador> straightFlush()
  {
    List<Jogador> winningJogadors = [];
    for (int i = 0; i < this.JogadorList.length; i++) {
      int hearts = 0;
      int diamonds = 0;
      int spades = 0;
      int clubs = 0;
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<int> tempJogadorCards = [];
        List<Carta?> tempCardsAll = tempJogadorsCardsAll(tempJogador);
        for (int l = 0; l < tempCardsAll.length; l++) {
          if (tempCardsAll[l] != null) {
            if (tempCardsAll[l]!.getSuit().contains("Copas")) {
              hearts++;
            }
            if (tempCardsAll[l]!.getSuit().contains("Ouros")) {
              diamonds++;
            }
            if (tempCardsAll[l]!.getSuit().contains("Espadas")) {
              spades++;
            }
            if (tempCardsAll[l]!.getSuit().contains("Paus")) {
              clubs++;
            }
          }
        }
        if (hearts >= 5) {
          tempJogadorCards = getValuesOfSuit(tempJogadorsCardsAll as List<Carta>, "Copas");
        } else if (diamonds >= 5) {
          tempJogadorCards = getValuesOfSuit(tempJogadorsCardsAll as List<Carta>, "Ouros");
        } else if (spades >= 5) {
          tempJogadorCards = getValuesOfSuit(tempJogadorsCardsAll as List<Carta>, "Espadas");
        } else if (clubs >= 5) {
          tempJogadorCards = getValuesOfSuit(tempJogadorsCardsAll as List<Carta>, "Paus");
        }

        tempJogadorCards.sort();
        int lowestValue = 15;
        int secondHighestValue = 15;
        int thirdHighestValue = 15;
        if (tempJogadorCards.length >= 5) {
          lowestValue = tempJogadorCards[0];
          secondHighestValue = tempJogadorCards[1];
          thirdHighestValue = tempJogadorCards[2];
          if (((tempJogadorCards.contains(lowestValue + 1) && tempJogadorCards.contains(lowestValue + 2)) && tempJogadorCards.contains(lowestValue + 3)) && tempJogadorCards.contains(lowestValue + 4)) {
            winningJogadors.add(tempJogador);
          }
        }
        if (tempJogadorCards.length >= 6) {
          if (((tempJogadorCards.contains(secondHighestValue + 1) && tempJogadorCards.contains(secondHighestValue + 2)) && tempJogadorCards.contains(secondHighestValue + 3)) && tempJogadorCards.contains(secondHighestValue + 4)) {
            winningJogadors.add(tempJogador);
          }
        }
        if (tempJogadorCards.length >= 7) {
          if (((tempJogadorCards.contains(thirdHighestValue + 1) && tempJogadorCards.contains(thirdHighestValue + 2)) && tempJogadorCards.contains(thirdHighestValue + 3)) && tempJogadorCards.contains(thirdHighestValue + 4)) {
            winningJogadors.add(tempJogador);
          }
        }
      }
    }
    return winningJogadors;
  }


  List<Jogador> fourOfAKind()
  {
    List<Jogador> winningJogadors = [];
    for (int i = 0; i < this.JogadorList.length; i++) {
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<int> allValues = List<int>.filled(13, 0);
        List<Carta?> tempCardsAll = tempJogadorsCardsAll(tempJogador);
        for (int j = 0; j < tempCardsAll.length; j++) {
          if (tempCardsAll[j] != null) {
            allValues[tempCardsAll[j]!.getValue() - 2]++;
          }
        }
        for (int k = 0; k < allValues.length; k++) {
          if (allValues[k] >= 4) {
            winningJogadors.add(tempJogador);
          }
        }
      }
    }
    return winningJogadors;
  }

  List<Jogador> fullHouse()
  {
    List<Jogador> winningJogadors = [];
    for (int i = 0; i < this.JogadorList.length; i++) {
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<int> allValues = List<int>.filled(13, 0);
        bool threeCard = false;
        bool twoCard = false;
        List<Carta?> tempCardsAll = tempJogadorsCardsAll(tempJogador);
        for (int j = 0; j < tempCardsAll.length; j++) {
          if (tempCardsAll[j] != null) {
            allValues[tempCardsAll[j]!.getValue() - 2]++;
          }
        }
        for (int k = 0; k < allValues.length; k++) {
          if (allValues[k] >= 3) {
            threeCard = true;
          } else {
            if (allValues[k] >= 2) {
              twoCard = true;
            }
          }
        }
        if (threeCard && twoCard) {
          winningJogadors.add(tempJogador);
        }
      }
    }
    return winningJogadors;
  }


  List<Jogador> flush()
  {
    List<Jogador> winningJogadors = [];
    for (int i = 0; i < this.JogadorList.length; i++) {
      int hearts = 0;
      int diamonds = 0;
      int spades = 0;
      int clubs = 0;
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<Carta?> tempCardsAll = tempJogadorsCardsAll(tempJogador);
        for (int l = 0; l < tempCardsAll.length; l++) {
          if (tempCardsAll[l] != null) {
            if (tempCardsAll[l]!.getSuit().contains("Copas")) {
              hearts++;
            }
            if (tempCardsAll[l]!.getSuit().contains("Ouros")) {
              diamonds++;
            }
            if (tempCardsAll[l]!.getSuit().contains("Espadas")) {
              spades++;
            }
            if (tempCardsAll[l]!.getSuit().contains("Paus")) {
              clubs++;
            }
          }
        }
        if (hearts >= 5 || diamonds >= 5 || spades >= 5 || clubs >= 5) {
          winningJogadors.add(tempJogador);
        }
      }
    }
    return winningJogadors;
  }


  List<Jogador> straight()
  {
    List<Jogador> winningJogadors = [];
    for (int i = 0; i < this.JogadorList.length; i++) {
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<Carta?> tempCardsAll = tempJogadorsCardsAll(tempJogador);
        List<int> tempJogadorCards = getValuesOfAllCards(tempJogadorsCardsAll as List<Carta?>);
        tempJogadorCards.sort();
        int lowestValue = 15;
        int secondHighestValue = 15;
        int thirdHighestValue = 15;
        if (tempJogadorCards.length >= 5) {
          lowestValue = tempJogadorCards[0];
          secondHighestValue = tempJogadorCards[1];
          thirdHighestValue = tempJogadorCards[2];
          if (tempJogadorCards.contains(lowestValue + 1) &&
              tempJogadorCards.contains(lowestValue + 2) &&
              tempJogadorCards.contains(lowestValue + 3) &&
              tempJogadorCards.contains(lowestValue + 4)) {
            winningJogadors.add(tempJogador);
          }
        }
        if (tempJogadorCards.length >= 6) {
          if (tempJogadorCards.contains(secondHighestValue + 1) &&
              tempJogadorCards.contains(secondHighestValue + 2) &&
              tempJogadorCards.contains(secondHighestValue + 3) &&
              tempJogadorCards.contains(secondHighestValue + 4)) {
            winningJogadors.add(tempJogador);
          }
        }
        if (tempJogadorCards.length >= 7) {
          if (tempJogadorCards.contains(thirdHighestValue + 1) &&
              tempJogadorCards.contains(thirdHighestValue + 2) &&
              tempJogadorCards.contains(thirdHighestValue + 3) &&
              tempJogadorCards.contains(thirdHighestValue + 4)) {
            winningJogadors.add(tempJogador);
          }
        }
      }
    }
    return winningJogadors;
  }


  List<Jogador> threeOfAKind()
  {
    List<Jogador> winningJogadors = [];
    for (int i = 0; i < this.JogadorList.length; i++) {
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<int> allValues = List<int>.filled(13, 0);
        List<Carta?> tempCardsAll = tempJogadorsCardsAll(tempJogador);
        for (int j = 0; j < tempCardsAll.length; j++) {
          int cardValue = tempCardsAll[j]!.getValue();
          allValues[cardValue - 2]++;
        }
        for (int k = 0; k < allValues.length; k++) {
          if (allValues[k] >= 3) {
            winningJogadors.add(tempJogador);
          }
        }
      }
    }
    return winningJogadors;
  }


  List<Jogador> twoPair()
  {
    List<Jogador> winningJogadors = [];
    for (int i = 0; i < this.JogadorList.length; i++) {
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<int> allValues = List<int>.filled(13, 0);
        int pairCount = 0;
        List<Carta?> tempCardsAll = tempJogadorsCardsAll(tempJogador);
        for (int j = 0; j < tempCardsAll.length; j++) {
          int cardValue = tempCardsAll[j]!.getValue();
          allValues[cardValue - 2]++;
        }
        for (int k = 0; k < allValues.length; k++) {
          if (allValues[k] >= 2) {
            pairCount++;
          }
        }
        if (pairCount >= 2) {
          winningJogadors.add(tempJogador);
        }
      }
    }
    return winningJogadors;
  }


  List<Jogador> onePair()
  {
    List<Jogador> winningJogadors = [];
    for (int i = 0; i < this.JogadorList.length; i++) {
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<int> allValues = List<int>.filled(13, 0);
        List<Carta?> tempCardsAll = tempJogadorsCardsAll(tempJogador);
        for (int j = 0; j < tempCardsAll.length; j++) {
          int cardValue = tempCardsAll[j]!.getValue();
          allValues[cardValue - 2]++;
        }
        for (int k = 0; k < allValues.length; k++) {
          if (allValues[k] >= 2 && !winningJogadors.contains(tempJogador)) {
            winningJogadors.add(tempJogador);
            break; // Sair do loop se encontrar um par
          }
        }
      }
    }
    return winningJogadors;
  }


  List<Jogador> highCard()
  {
    List<Jogador> winningJogadors = [];
    List<List<int>> sortedJogadorsHoleCards = List.generate(this.JogadorList.length, (index) => List<int>.filled(2, 0));
    int highestCardColTwo = 0;
    int highestCardColOne = 0;
    bool tie = false;

    for (int i = 0; i < this.JogadorList.length; i++) {
      Jogador tempJogador = this.JogadorList[i];
      if (tempJogador.getIsInGame()) {
        List<int> tempHoleCards = [
          tempJogador.getHoleCards()[0].getValue(),
          tempJogador.getHoleCards()[1].getValue()
        ];
        tempHoleCards.sort();

        if (tempHoleCards[1] > highestCardColTwo) {
          highestCardColTwo = tempHoleCards[1];
          winningJogadors.clear();
          winningJogadors.add(tempJogador);
          sortedJogadorsHoleCards[i][0] = i;
          sortedJogadorsHoleCards[i][1] = tempHoleCards[0];
        } else if (tempHoleCards[1] == highestCardColTwo) {
          winningJogadors.add(tempJogador);
          tie = true;
          sortedJogadorsHoleCards[i][0] = i;
          sortedJogadorsHoleCards[i][1] = tempHoleCards[0];
        }
      }
    }

    if (tie) {
      winningJogadors.clear();
      for (int k = 0; k < sortedJogadorsHoleCards.length; k++) {
        if (sortedJogadorsHoleCards[k][1] > highestCardColOne) {
          highestCardColOne = sortedJogadorsHoleCards[k][1];
        }
      }

      for (int l = 0; l < sortedJogadorsHoleCards.length; l++) {
        if (sortedJogadorsHoleCards[l][1] == highestCardColOne) {
          winningJogadors.add(this.JogadorList[l]);
        }
      }
    }

    return winningJogadors;
  }



  List<int> getValuesOfSuit(List<Carta?> JogadorsCardsAll, String suit)
  {
    List<int> result = [];
    for (int i = 0; i < JogadorsCardsAll.length; i++) {
      if (JogadorsCardsAll[i] != null && JogadorsCardsAll[i]!.getSuit().contains(suit)) {
        result.add(JogadorsCardsAll[i]!.getValue());
      }
    }
    return result;
  }


  List<int> getValuesOfAllCards(List<Carta?> JogadorsCardsAll) {
    List<int> result = [];
    for (int i = 0; i < JogadorsCardsAll.length; i++) {
      if (JogadorsCardsAll[i] != null) {
        result.add(JogadorsCardsAll[i]!.getValue());
      }
    }
    return result;
  }

}

void main(List<String> args) {
  PokerGame pg = new PokerGame(1);
  //pg.JogadorList.add(Jogador(name: "Scott", balance: 0, holeCards: [Carta(4, "Hearts"), Carta(10, "Diamonds")]));
  //pg.JogadorList.add(Jogador(name: "1Findawg", balance: 0, holeCards: [Carta(10, "Hearts"), Carta(5, "Diamonds")]));
  //pg.JogadorList.add(Jogador(name: "Jack", balance: 0, holeCards: [Carta(2, "Hearts"), Carta(3, "Diamonds")]));
  //pg.communityCards = [Carta(11, "Hearts"), Carta(9, "Hearts"), Carta(2, "Spades"), Carta(8, "Hearts"), Carta(13, "Spades")];


}
