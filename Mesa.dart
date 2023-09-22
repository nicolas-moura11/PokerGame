import 'Baralho.dart';
import 'Carta.dart';
class Mesa {
  List<Carta> cartasComunitarias = [];

  void distribuirCartasComunitarias(Baralho baralho, int numCartas) {
    for (var i = 0; i < numCartas; i++) {
      cartasComunitarias.add(baralho.distribuirCarta());
    }
  }

  void limparCartasComunitarias() {
    cartasComunitarias.clear();
  }

  void mostrarCartasComunitarias() {
    print('Cartas comunitárias:');
    for (var carta in cartasComunitarias) {
      print(' - $carta');
    }
  }
}
