
import 'dart:io';
import 'dart:math';

enum Acao { Desistir, Passar, Apostar, Pagar, Aumentar }

class AvaliadorDeMao {
  // ... (outras funções)

  static bool ehRoyalFlush(List<Carta> mao) {
    final naipeReferencia = mao[0].naipe;

    if (mao.every((carta) =>
    Carta.valorCarta(carta) == 'A' ||
        Carta.valorCarta(carta) == 'K' ||
        Carta.valorCarta(carta) == 'Q' ||
        Carta.valorCarta(carta) == 'J' ||
        Carta.valorCarta(carta) == '10') &&
        mao.every((carta) => carta.naipe == naipeReferencia)) {
      return true;
    }
    return false;
  }

  static bool ehStraightFlush(List<Carta> mao) {
    final naipeReferencia = mao[0].naipe;

    mao.sort((a, b) => Carta.valorCarta(a) - Carta.valorCarta(b));

    if (mao.every((carta) => carta.naipe == naipeReferencia) &&
        Carta.valorCarta(mao[0]) - Carta.valorCarta(mao[4]) == 4) {
      return true;
    }
    return false;
  }

  static bool ehFourOfAKind(List<Carta> mao) {
    for (int i = 0; i < mao.length - 3; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 4) {
        return true;
      }
    }
    return false;
  }

  static bool ehFullHouse(List<Carta> mao) {
    bool possuiTrinca = false;
    bool possuiPar = false;

    for (int i = 0; i < mao.length - 2; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 3) {
        possuiTrinca = true;
      } else if (count == 2) {
        possuiPar = true;
      }
    }

    return possuiTrinca && possuiPar;
  }

  static bool ehFlush(List<Carta> mao) {
    final naipeReferencia = mao[0].naipe;

    if (mao.every((carta) => carta.naipe == naipeReferencia)) {
      return true;
    }
    return false;
  }

  static bool ehStraight(List<Carta> mao) {
    if (mao.length >= 5) {
      mao.sort((a, b) => Carta.valorCarta(a) - Carta.valorCarta(b));

      if (Carta.valorCarta(mao[4]) - Carta.valorCarta(mao[0]) == 4) {
        if (Carta.valorCarta(mao[4]) == 14 || Carta.valorCarta(mao[0]) == 10) {
          return true;
        }
      }
    }
    return false;
  }

  static bool ehThreeOfAKind(List<Carta> mao) {
    for (int i = 0; i < mao.length - 2; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 3) {
        return true;
      }
    }
    return false;
  }

  static bool ehTwoPair(List<Carta> mao) {
    int paresEncontrados = 0;

    for (int i = 0; i < mao.length - 1; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 2) {
        paresEncontrados++;
      }
    }

    return paresEncontrados == 2;
  }

  static bool ehPair(List<Carta> mao) {
    for (int i = 0; i < mao.length - 1; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 2) {
        return true;
      }
    }
    return false;
  }
}

class Carta {
  final String naipe;
  final String valor;

  Carta(this.naipe, this.valor);

  @override
  String toString() {
    return '$valor de $naipe';
  }

  static int valorCarta(Carta carta) {
    final valores = {
      '2': 2,
      '3': 3,
      '4': 4,
      '5': 5,
      '6': 6,
      '7': 7,
      '8': 8,
      '9': 9,
      '10': 10,
      'J': 11,
      'Q': 12,
      'K': 13,
      'A': 14,
    };

    return valores[carta.valor] ?? 0;
  }
}

class Baralho {
  final List<Carta> cartas = [];

  Baralho() {
    final naipes = ['Espadas', 'Copas', 'Ouros', 'Paus'];
    final valores = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'];

    for (var naipe in naipes) {
      for (var valor in valores) {
        cartas.add(Carta(naipe, valor));
      }
    }
  }

  void embaralhar() {
    cartas.shuffle();
  }

  Carta distribuirCarta() {
    if (cartas.isNotEmpty) {
      return cartas.removeLast();
    } else {
      throw Exception('O baralho está vazio.');
    }
  }
}


class Jogador {
  final String nome;
  int fichas;
  List<Carta> holeCards = [];

  Jogador(this.nome, this.fichas);

  void adicionarFichas(int quantidade) {
    fichas += quantidade;
  }

  void adicionarCarta(Carta carta) {
    holeCards.add(carta);
  }

  void mostrarHoleCards() {
    print('$nome tem as seguintes cartas hole cards:');
    for (var carta in holeCards) {
      print(' - $carta');
    }
  }

  void limparHoleCards() {
    holeCards.clear();
  }
}

class Mesa {
  final List<Carta> cartasComunitarias = [];

  void distribuirCartasComunitarias(Baralho baralho, int numCartas) {
    for (int i = 0; i < numCartas; i++) {
      final carta = baralho.distribuirCarta();
      if (carta != null) {
        cartasComunitarias.add(carta);
      }
    }
  }

  void mostrarCartasComunitarias() {
    print('Cartas comunitárias:');
    for (var carta in cartasComunitarias) {
      print(' - $carta');
    }
  }

  void limparCartasComunitarias() {
    cartasComunitarias.clear();
  }
}


class PokerGame {
  List<Jogador> jogadores = [];
  List<Carta> cartasComunitarias = [];
  int pote = 0;
  final Mesa mesa = Mesa();
  final Baralho baralho = Baralho();
  int smallBlind = 10; // Define o valor do small blind
  int bigBlind = 20;   // Define o valor do big blind
  int rodadaAtual = 0;
  late Jogador dealer; // Adicione a variável dealer aqui
  late Jogador bigblind;
  late Jogador jogadorAtual; // Adicione a variável jogadorAtual aqui

  void menuPrincipal() {
    bool jogarNovamente = true;

    while (jogarNovamente) {
      print('-' * 30);
      print('Bem-vindo ao Jogo de Poker!');
      print('-' * 30);
      print('Escolha uma opção:');
      print('1. Iniciar Jogo');
      print('2. Encerrar Jogo');
      print('-' * 30);
      print('Digite o número da opção desejada:');

      String entrada = stdin.readLineSync() ?? '';

      switch (entrada) {
        case '1':
          criarJogadores();
          comprarFichas();
          iniciarJogo();
          break;
        case '2':
          jogarNovamente = false;
          break;
        default:
          print('Opção inválida. Tente novamente.');
          break;
      }
    }

    print('-' * 30); // Linha horizontal para separação
    print('Obrigado por jogar! Até a próxima.');
  }

  // Avalia uma mão de jogador e retorna sua categoria de mão
  String avaliarMao(List<Carta> mao) {
    mao.sort((a, b) => Carta.valorCarta(b).compareTo(Carta.valorCarta(a)));

    // Verifique cada categoria de mão, começando pela mais alta
    if (ehRoyalFlush(mao)) return 'Royal Flush';
    if (ehStraightFlush(mao)) return 'Straight Flush';
    if (ehFourOfAKind(mao)) return 'Four of a Kind';
    if (ehFullHouse(mao)) return 'Full House';
    if (ehFlush(mao)) return 'Flush';
    if (ehStraight(mao)) return 'Straight';
    if (ehThreeOfAKind(mao)) return 'Three of a Kind';
    if (ehTwoPair(mao)) return 'Two Pair';
    if (ehPair(mao)) return 'Pair';

    return 'High Card'; // Se não se encaixar em nenhuma categoria, é uma "High Card"
  }

  // Implemente as funções de verificação para cada categoria de mão
  bool ehRoyalFlush(List<Carta> mao) {
    if (mao.isEmpty) {
      return false; // A lista está vazia, não pode haver Royal Flush.
    }

    final naipeReferencia = mao[0].naipe;

    if (mao.every((carta) =>
    Carta.valorCarta(carta) == 'A' ||
        Carta.valorCarta(carta) == 'K' ||
        Carta.valorCarta(carta) == 'Q' ||
        Carta.valorCarta(carta) == 'J' ||
        Carta.valorCarta(carta) == '10') &&
        mao.every((carta) => carta.naipe == naipeReferencia)) {
      return true;
    }
    return false;
  }

  bool ehStraightFlush(List<Carta> mao) {
    // Verifique se é um Straight Flush
    // Straight Flush: Cinco cartas na sequência, do mesmo naipe
    final naipeReferencia = mao[0].naipe;

    mao.sort((a, b) => Carta.valorCarta(a) - Carta.valorCarta(b));

    if (mao.every((carta) => carta.naipe == naipeReferencia) &&
        Carta.valorCarta(mao[0]) - Carta.valorCarta(mao[4]) == 4) {
      return true;
    }
    return false;
  }



  bool ehFourOfAKind(List<Carta> mao) {
    // Verifique se é um Four of a Kind (Quadra)
    for (int i = 0; i < mao.length - 3; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 4) {
        return true;
      }
    }
    return false;
  }

  bool ehFullHouse(List<Carta> mao) {
    // Verifique se é um Full House
    bool possuiTrinca = false;
    bool possuiPar = false;

    for (int i = 0; i < mao.length - 2; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 3) {
        possuiTrinca = true;
      } else if (count == 2) {
        possuiPar = true;
      }
    }

    return possuiTrinca && possuiPar;
  }

  bool ehFlush(List<Carta> mao) {
    // Verifique se é um Flush
    final naipeReferencia = mao[0].naipe;

    if (mao.every((carta) => carta.naipe == naipeReferencia)) {
      return true;
    }
    return false;
  }

  bool ehStraight(List<Carta> mao) {
    // Verifique se é um Straight (Sequência)
    if (mao.length >= 5) {
      mao.sort((a, b) => Carta.valorCarta(a) - Carta.valorCarta(b));

      if (Carta.valorCarta(mao[4]) - Carta.valorCarta(mao[0]) == 4) {
        // As sequências podem ser A-2-3-4-5 ou 10-J-Q-K-A,
        // portanto, verifique se o valor da carta mais alta é A ou 10
        if (Carta.valorCarta(mao[4]) == 14 || Carta.valorCarta(mao[0]) == 10) {
          return true;
        }
      }
    }
    return false;
  }

  bool ehThreeOfAKind(List<Carta> mao) {
    // Verifique se é um Three of a Kind (Trinca)
    for (int i = 0; i < mao.length - 2; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 3) {
        return true;
      }
    }
    return false;
  }

  bool ehTwoPair(List<Carta> mao) {
    // Verifique se é um Two Pair (Dois Pares)
    int paresEncontrados = 0;

    for (int i = 0; i < mao.length - 1; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 2) {
        paresEncontrados++;
      }
    }

    return paresEncontrados == 2;
  }

  bool ehPair(List<Carta> mao) {
    // Verifique se é um Pair (Par)
    for (int i = 0; i < mao.length - 1; i++) {
      int count = 1;
      for (int j = i + 1; j < mao.length; j++) {
        if (Carta.valorCarta(mao[i]) == Carta.valorCarta(mao[j])) {
          count++;
        }
      }
      if (count == 2) {
        return true;
      }
    }
    return false;
  }



  // Função para determinar o vencedor com base nas categorias das mãos
  Jogador determinarVencedor(List<Jogador> jogadores) {
    Jogador vencedor = jogadores[0];
    String categoriaVencedor = avaliarMao(vencedor.holeCards);

    for (var jogador in jogadores) {
      String categoriaAtual = avaliarMao(jogador.holeCards);

      // Compare as categorias das mãos
      int resultadoComparacao = compararCategorias(categoriaAtual, categoriaVencedor);

      if (resultadoComparacao > 0) {
        // A categoria atual é melhor
        vencedor = jogador;
        categoriaVencedor = categoriaAtual;
      } else if (resultadoComparacao == 0) {
        // Empate na categoria, compare as cartas mais altas
        int resultadoComparacaoCartas = compararMao(jogador.holeCards, vencedor.holeCards);
        if (resultadoComparacaoCartas > 0) {
          vencedor = jogador;
        }
      }
    }

    return vencedor;
  }

// Função para comparar duas categorias de mão
// Retorna um valor positivo se categoriaA for melhor, negativo se categoriaB for melhor, ou zero se forem iguais
  int compararCategorias(String categoriaA, String categoriaB) {
    final ordemCategorias = [
      'Royal Flush',
      'Straight Flush',
      'Four of a Kind',
      'Full House',
      'Flush',
      'Straight',
      'Three of a Kind',
      'Two Pair',
      'Pair',
      'High Card',
    ];

    int indiceA = ordemCategorias.indexOf(categoriaA);
    int indiceB = ordemCategorias.indexOf(categoriaB);

    return indiceA - indiceB;
  }

// Função para comparar duas mãos da mesma categoria
// Retorna um valor positivo se maoA for melhor, negativo se maoB for melhor, ou zero se forem iguais
  int compararMao(List<Carta> maoA, List<Carta> maoB) {
    // Ordene as mãos em ordem decrescente de valor das cartas
    maoA.sort((a, b) => Carta.valorCarta(b).compareTo(Carta.valorCarta(a)));
    maoB.sort((a, b) => Carta.valorCarta(b).compareTo(Carta.valorCarta(a)));

    for (int i = 0; i < maoA.length; i++) {
      int valorCartaA = Carta.valorCarta(maoA[i]);
      int valorCartaB = Carta.valorCarta(maoB[i]);

      if (valorCartaA > valorCartaB) {
        return 1; // maoA é melhor
      } else if (valorCartaA < valorCartaB) {
        return -1; // maoB é melhor
      }
    }

    return 0; // Empate
  }


  // Método para determinar o dealer no início do jogo
  void determinarDealer() {
    // Embaralhe a lista de jogadores
    jogadores.shuffle();
    dealer = jogadores[0]; // O primeiro jogador na lista é o dealer
    jogadorAtual = dealer; // Comece com o dealer como jogador atual
  }

  // Método para avançar para o próximo jogador na rodada
  void proximoJogador() {
    int indiceJogadorAtual = jogadores.indexOf(jogadorAtual);
    if (indiceJogadorAtual == jogadores.length - 1) {
      // Voltou ao dealer, encerrando a rodada
      rodadaAtual++;
      // Reinicie a ação com o dealer
      jogadorAtual = dealer;
    } else {
      // Avance para o próximo jogador na lista
      jogadorAtual = jogadores[indiceJogadorAtual + 1];
    }
  }

  void criarJogadores() {
    print('Quantos jogadores deseja adicionar?');
    int quantidadeJogadores = int.parse(stdin.readLineSync() ?? '0');

    for (int i = 1; i <= quantidadeJogadores; i++) {
      print('Nome do Jogador $i:');
      String nome = stdin.readLineSync() ?? '';
      jogadores.add(Jogador(nome, 0));
    }
  }

  void comprarFichas() {
    print('Quantas fichas cada jogador deseja comprar?');
    int quantidadeFichas = int.parse(stdin.readLineSync() ?? '0');

    for (var jogador in jogadores) {
      jogador.adicionarFichas(quantidadeFichas);
    }
  }

  void distribuirHoleCards() {
    for (var jogador in jogadores) {
      jogador.adicionarCarta(baralho.distribuirCarta());
      jogador.adicionarCarta(baralho.distribuirCarta());
    }
  }

  int fazerAposta(Jogador jogador) {
    print('${jogador.nome}, é a sua vez de apostar.');

    int fichasApostadas = 0;
    bool apostaValida = false;

    while (!apostaValida) {
      print('Quantas fichas você deseja apostar? (0 para passar)');
      String entrada = stdin.readLineSync() ?? '';
      fichasApostadas = int.tryParse(entrada) ?? 0;

      if (fichasApostadas >= 0 && fichasApostadas <= jogador.fichas) {
        apostaValida = true;
      } else {
        print('Aposta inválida. Tente novamente.');
      }
    }

    jogador.fichas -= fichasApostadas;
    pote += fichasApostadas;

    return fichasApostadas;
  }

  Acao tomarAcao(Jogador jogador, int apostaMinima) {
    jogador.mostrarHoleCards();

    print('Ações disponíveis:');
    print('1. Desistir');
    print('2. Passar');
    print('3. Apostar');
    print('4. Pagar');
    print('5. Aumentar');
    print('Digite o número da ação desejada:');

    String entrada = stdin.readLineSync() ?? '';

    switch (entrada) {
      case '1':
        return Acao.Desistir;
      case '2':
        return Acao.Passar;
      case '3':
        if (jogador.fichas == 0) {
          print('Você não tem fichas para apostar.');
          return tomarAcao(jogador, apostaMinima);
        }
        return Acao.Apostar;
      case '4':
        if (jogador.fichas < apostaMinima) {
          print('Você não tem fichas suficientes para pagar a aposta.');
          return tomarAcao(jogador, apostaMinima);
        }
        return Acao.Pagar;
      case '5':
        if (jogador.fichas == 0) {
          print('Você não tem fichas para aumentar a aposta.');
          return tomarAcao(jogador, apostaMinima);
        }
        return Acao.Aumentar;
      default:
        print('Opção inválida. Tente novamente.');
        return tomarAcao(jogador, apostaMinima);
    }
  }

  void distribuirBlinds() {
    print('Distribuindo blinds...');

    // Determine a ordem dos jogadores para distribuir os blinds
    int indexOfSmallBlind = (rodadaAtual % jogadores.length);
    int indexOfBigBlind = (rodadaAtual + 1) % jogadores.length;

    // Defina o small blind e o big blind para os jogadores
    jogadores[indexOfSmallBlind].fichas -= smallBlind;
    jogadores[indexOfBigBlind].fichas -= bigBlind;
    pote += smallBlind + bigBlind;

    // Exiba na tela que o jogador fez as apostas de small blind e big blind
    print('${jogadores[indexOfSmallBlind].nome} fez a aposta do Small Blind de $smallBlind fichas.');
    print('${jogadores[indexOfBigBlind].nome} fez a aposta do Big Blind de $bigBlind fichas.');
  }

  void rodadaDeApostas() {
    print('Iniciando rodada de apostas...');
    int apostaMinima = bigBlind; // A aposta mínima na primeira rodada é o big blind
    int jogadoresAtivos = jogadores.length;

    // Determine o índice do jogador que começa a rodada de apostas
    int indiceJogadorAtual = (rodadaAtual + 2) % jogadores.length;

    // Continue enquanto houver mais de um jogador ativo
    while (jogadoresAtivos > 1) {
      Jogador jogadorAtual = jogadores[indiceJogadorAtual];

      if (jogadorAtual.fichas > 0) {
        Acao acao = tomarAcao(jogadorAtual, apostaMinima);

        switch (acao) {
          case Acao.Desistir:
            print('${jogadorAtual.nome} desistiu da rodada.');
            jogadoresAtivos--;
            break;
          case Acao.Passar:
            print('${jogadorAtual.nome} passou.');
            jogadoresAtivos--;
            break;
          case Acao.Apostar:
            print('${jogadorAtual.nome} está fazendo uma aposta.');
            int fichasApostadas = fazerAposta(jogadorAtual);
            apostaMinima = max(apostaMinima, fichasApostadas);
            break;
          case Acao.Pagar:
            print('${jogadorAtual.nome} está pagando a aposta anterior.');
            int fichasApostadas = fazerAposta(jogadorAtual);
            break;
          case Acao.Aumentar:
            print('${jogadorAtual.nome} está aumentando a aposta.');
            int fichasApostadas = fazerAposta(jogadorAtual);
            apostaMinima = max(apostaMinima, fichasApostadas);
            break;
        }
      } else {
        print('${jogadorAtual.nome} não tem fichas suficientes e está fora da rodada.');
        jogadoresAtivos--;
      }

      // Avance para o próximo jogador na ordem circular
      indiceJogadorAtual = (indiceJogadorAtual + 1) % jogadores.length;
    }

    print('Fim da rodada de apostas. Pote atual: $pote fichas.');
    rodadaAtual++; // Avance para a próxima rodada
  }



  void iniciarJogo() {
    baralho.embaralhar();
    distribuirBlinds();
    distribuirHoleCards();

    // Pré-Flop
    rodadaDeApostas();

    // Flop
    revelarFlop();
    rodadaDeApostas();

    // Turn
    revelarTurn();
    rodadaDeApostas();

    // River
    revelarRiver();
    rodadaDeApostas();

    // Showdown (Determinar o vencedor da mão)
    encerrarMao();

    // Perguntar se os jogadores desejam continuar jogando
    print('Deseja continuar jogando? (S para Sim, qualquer outra tecla para sair)');
    String continuar = stdin.readLineSync()?.toUpperCase() ?? '';

    if (continuar == 'S') {
      iniciarJogo(); // Recomeçar o jogo
    } else {
      encerrarJogo();
    }
  }




  void revelarFlop() {
    print('Revelando o Flop (3 cartas comunitárias)...');
    mesa.distribuirCartasComunitarias(baralho, 3);
    mesa.mostrarCartasComunitarias();
  }

  void revelarTurn() {
    print('Revelando o Turn (1 carta comunitária)...');
    mesa.distribuirCartasComunitarias(baralho, 1);
    mesa.mostrarCartasComunitarias();
  }

  void revelarRiver() {
    print('Revelando o River (1 carta comunitária)...');
    mesa.distribuirCartasComunitarias(baralho, 1);
    mesa.mostrarCartasComunitarias();
  }

  void encerrarMao() {
    print('Encerrando a mão...');

    // Determinar o vencedor da mão
    Jogador vencedorDaMao = determinarVencedor(jogadores);
    print('Vencedor da mão: ${vencedorDaMao.nome}');

    // Distribuir o pote para o vencedor
    vencedorDaMao.adicionarFichas(pote);
    pote = 0;

    // Limpar as cartas dos jogadores e da mesa para a próxima mão
    for (var jogador in jogadores) {
      jogador.limparHoleCards();
    }
    mesa.limparCartasComunitarias();

    // Embaralhar o baralho para a próxima mão
    baralho.embaralhar();
  }


  void encerrarJogo() {
    print('Encerrando o jogo...');

    // Implemente ações para encerrar o jogo
    bool houveEmpate = false;
    Jogador vencedorGeral = jogadores[0]; // Inicialize com o primeiro jogador

    for (var jogador in jogadores) {
      if (jogador.fichas > vencedorGeral.fichas) {
        vencedorGeral = jogador;
        houveEmpate = false; // Se encontramos um novo líder, redefina a flag de empate
      } else if (jogador.fichas == vencedorGeral.fichas) {
        houveEmpate = true; // Houve um empate
      }
    }

    if (houveEmpate) {
      print('O jogo terminou em empate.');
    } else {
      print('O vencedor geral do jogo é: ${vencedorGeral.nome}');
    }

    print('Obrigado por jogar! Até a próxima.');
  }
}

void main() {
  final pokerGame = PokerGame();
  pokerGame.menuPrincipal();
}
