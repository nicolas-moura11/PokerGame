import 'Aposta.dart';
import 'Baralho.dart';
import 'MaoDoJogador.dart';
import 'Mesa.dart';
import 'dart:io';

class Jogador {
  String nome;
  int fichas;

  Jogador(this.nome, this.fichas);
}

class PokerGame {
  late List<MaoDoJogador> jogadores;
  late Mesa mesa;
  late Baralho baralho;

  PokerGame(this.jogadores, this.mesa, this.baralho);

  void menuPrincipal() {
    bool jogarNovamente = true;

    while (jogarNovamente) {
      print('Bem-vindo ao Jogo de Poker!');
      print('Escolha uma opção:');
      print('1. Iniciar Jogo');
      print('2. Encerrar Jogo');
      print('Digite o número da opção desejada:');

      String entrada = stdin.readLineSync() ?? '';

      switch (entrada) {
        case '1':
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

    print('Obrigado por jogar! Até a próxima.');
  }

  void iniciarJogo() {
    baralho.embaralhar();
    for (var jogador in jogadores) {
      jogador.adicionarCarta(baralho.distribuirCarta());
      jogador.adicionarCarta(baralho.distribuirCarta());
    }
  }

  int objetivoMinimo = 100;

  void rodadaDeApostas() {
    print('Iniciando rodada de apostas...');
    List<Aposta> apostas = [];

    // Implemente a lógica de apostas dos jogadores aqui
    for (var jogador in jogadores) {
      int fichasApostadas = fazerAposta(jogador);
      apostas.add(Aposta(jogador, fichasApostadas));
    }

    // Determine o vencedor da rodada com base nas mãos dos jogadores
    MaoDoJogador vencedor = determinarVencedor();

    print('O vencedor da rodada é: ${vencedor.toString()}');

    // Distribua as fichas para o vencedor
    distribuirFichas(vencedor, apostas);
  }

  void distribuirFichas(MaoDoJogador vencedor, List<Aposta> apostas) {
    print('Distribuindo fichas...');
    for (var aposta in apostas) {
      if (aposta.jogador == vencedor) {
        vencedor.adicionarFichas(aposta.fichasApostadas * (apostas.length - 1));
      } else {
        aposta.jogador.adicionarFichas(-aposta.fichasApostadas);
      }
    }
  }

  void criarJogadores() {
    print('Quantos jogadores deseja adicionar?');
    int quantidadeJogadores = int.parse(stdin.readLineSync() ?? '0');

    for (int i = 1; i <= quantidadeJogadores; i++) {
      print('Nome do Jogador $i:');
      String nome = stdin.readLineSync() ?? '';
      jogadores.add(Jogador(nome, 1000)
          as MaoDoJogador); // Você pode definir uma quantidade inicial de fichas
    }
  }

  int fazerAposta(MaoDoJogador jogador) {
    print('${jogador.toString()}, é a sua vez de apostar.');

    int fichasApostadas = 0;
    bool apostaValida = false;

    while (!apostaValida) {
      print('Quantas fichas você deseja apostar? (0 para passar)');
      String entrada = stdin.readLineSync() ?? '';
      fichasApostadas = int.tryParse(entrada) ?? 0;

      // Implemente validações adicionais, como verificar se o jogador tem fichas suficientes, etc.
      if (fichasApostadas >= 0) {
        apostaValida = true;
      } else {
        print('Aposta inválida. Tente novamente.');
      }
    }

    // Atualize o estado do jogador com a aposta feita, se necessário

    return fichasApostadas;
  }

  void revelarCartasComunitarias(int numCartas) {
    print('Revelando $numCartas cartas comunitárias...');
    mesa.distribuirCartasComunitarias(baralho, numCartas);
  }

  MaoDoJogador determinarVencedor() {
    MaoDoJogador vencedor = jogadores[0]; // Inicialize com o primeiro jogador
    for (var jogador in jogadores) {
      if (jogador.cartas.length > vencedor.cartas.length) {
        vencedor = jogador;
      }
    }
    return vencedor;
  }

  void encerrarMao() {
    print('Encerrando a mão...');

    // Implemente ações para encerrar a mão, como reiniciar as cartas e redistribuir fichas
    baralho.embaralhar();
    mesa.limparCartasComunitarias();

    for (var jogador in jogadores) {
      jogador.limparMao();
    }

    // Verifique se algum jogador alcançou um objetivo específico (por exemplo, um número mínimo de fichas)
    for (var jogador in jogadores) {
      if (jogador.fichas >= objetivoMinimo) {
        print('${jogador.toString()} alcançou o objetivo mínimo de fichas!');
        // Você pode executar ações adicionais aqui, como declarar o vencedor do jogo
      }
    }

    // Você pode adicionar mais ações relevantes ao encerramento da mão, dependendo das regras do seu jogo.
  }

  void encerrarJogo() {
    print('Encerrando o jogo...');

    // Implemente ações para encerrar o jogo
    bool houveEmpate = false;
    MaoDoJogador vencedorGeral =
        jogadores[0]; // Inicialize com o primeiro jogador

    for (var jogador in jogadores) {
      if (jogador.fichas > vencedorGeral.fichas) {
        vencedorGeral = jogador;
        houveEmpate =
            false; // Se encontramos um novo líder, redefina a flag de empate
      } else if (jogador.fichas == vencedorGeral.fichas) {
        houveEmpate = true; // Houve um empate
      }
    }

    if (houveEmpate) {
      print('O jogo terminou em empate.');
    } else {
      print('O vencedor geral do jogo é: ${vencedorGeral.toString()}');
    }

    print('Obrigado por jogar! Até a próxima.');
  }

  MaoDoJogador? determinarVencedorGeral() {
    MaoDoJogador vencedorGeral =
        jogadores[0]; // Inicialize com o primeiro jogador
    for (var jogador in jogadores) {
      if (jogador.fichas > vencedorGeral.fichas) {
        vencedorGeral = jogador;
      }
    }

    return vencedorGeral;
  }

  void main() {
    final pokerGame = PokerGame();

    pokerGame.criarJogadores();
    pokerGame.menuPrincipal();
  }
}
