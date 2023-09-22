import 'dart:io';
import 'dart:math';
import 'Carta.dart';
import 'Baralho.dart';
import 'MaoDoJogador.dart';
import 'Mesa.dart';
import 'Jogador.dart';

enum Acao { Desistir, Passar, Apostar, Pagar, Aumentar }


class PokerGame {
  final List<Jogador> jogadores = [];
  final Mesa mesa = Mesa();
  final Baralho baralho = Baralho();
  int pote = 0;

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

    print('Obrigado por jogar! Até a próxima.');
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
    jogador.mostrarMao();

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

  void rodadaDeApostas() {
    print('Iniciando rodada de apostas...');
    int apostaMinima = 0;

    for (var jogador in jogadores) {
      if (jogador.fichas > 0) {
        Acao acao = tomarAcao(jogador, apostaMinima);

        switch (acao) {
          case Acao.Desistir:
            print('${jogador.nome} desistiu da rodada.');
            break;
          case Acao.Passar:
            print('${jogador.nome} passou.');
            break;
          case Acao.Apostar:
            print('${jogador.nome} está fazendo uma aposta.');
            int fichasApostadas = fazerAposta(jogador);
            apostaMinima = max(apostaMinima, fichasApostadas);
            break;
          case Acao.Pagar:
            print('${jogador.nome} está pagando a aposta anterior.');
            int fichasApostadas = fazerAposta(jogador);
            break;
          case Acao.Aumentar:
            print('${jogador.nome} está aumentando a aposta.');
            int fichasApostadas = fazerAposta(jogador);
            apostaMinima = max(apostaMinima, fichasApostadas);
            break;
        }
      } else {
        print('${jogador.nome} não tem fichas suficientes e está fora da rodada.');
      }
    }

    print('Fim da rodada de apostas. Pote atual: $pote fichas.');
  }

  void iniciarJogo() {
    baralho.embaralhar();
    for (var jogador in jogadores) {
      jogador.adicionarCarta(baralho.distribuirCarta());
      jogador.adicionarCarta(baralho.distribuirCarta());
    }

    while (true) {
      // Fase de Pré-Flop
      rodadaDeApostas();

      // Fase de Flop (Exemplo: revelando 3 cartas comunitárias)
      revelarCartasComunitarias(3);
      rodadaDeApostas();

      // Fase de Turn (Exemplo: revelando 1 carta comunitária)
      revelarCartasComunitarias(1);
      rodadaDeApostas();

      // Fase de River (Exemplo: revelando 1 carta comunitária)
      revelarCartasComunitarias(1);
      rodadaDeApostas();

      // Showdown (Determinar o vencedor da mão)
      // Implemente a lógica para determinar o vencedor da rodada com base nas apostas e mãos dos jogadores.
      encerrarMao();

      // Perguntar se os jogadores desejam continuar jogando
      print('Deseja continuar jogando? (S para Sim, qualquer outra tecla para sair)');
      String continuar = stdin.readLineSync()?.toUpperCase() ?? '';

      if (continuar != 'S') {
        break;
      }
    }

    encerrarJogo();
  }

  void revelarCartasComunitarias(int numCartas) {
    print('Revelando $numCartas cartas comunitárias...');
    mesa.distribuirCartasComunitarias(baralho, numCartas);
    mesa.mostrarCartasComunitarias();
  }

  void encerrarMao() {
    print('Encerrando a mão...');
    // Implemente ações para encerrar a mão, como reiniciar as cartas e redistribuir fichas
    baralho.embaralhar();
    mesa.limparCartasComunitarias();

    for (var jogador in jogadores) {
      jogador.limparMao();
      jogador.apostaAtual = 0;
    }

    pote = 0;
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

  void main() {
    final pokerGame = PokerGame();
    pokerGame.menuPrincipal();
  }
}

void main() {
  final pokerGame = PokerGame();
  pokerGame.menuPrincipal();
}
