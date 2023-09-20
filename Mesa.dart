import 'Baralho.dart';
import 'Carta.dart';

class Mesa {
  late List<Carta> cartasComunitarias;

  MesaPoker() {
    cartasComunitarias = [];
  }

  void distribuirCartasComunitarias(Baralho baralho, int numCartas) {
    for (var i = 0; i < numCartas; i++) {
      cartasComunitarias.add(baralho.distribuirCarta());
    }
  }

   void limparCartasComunitarias() {
    cartasComunitarias.clear();
  }

  @override
  String toString() {
    return cartasComunitarias.map((carta) => carta.toString()).join(', ');
  }
}
