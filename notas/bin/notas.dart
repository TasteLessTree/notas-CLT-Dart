import 'dart:io';

class Nota {
  String titulo;
  String contenido;
  DateTime fechaCreacion = DateTime.now();

  Nota(this.titulo, this.contenido) {
    fechaCreacion = DateTime.now();
  }
}

class GestorDeNotas {
  final File _archivoNotas = File('notas.txt');
  List<Nota> _notas = [];

  GestorDeNotas() {
    if (_archivoNotas.existsSync()) {
      _cargarNotasDesdeArchivo();
    }
  }

  // * Cargar notas *
  void _cargarNotasDesdeArchivo() {
    _notas = _archivoNotas.readAsLinesSync().map((line) {
      final partes = line.split('|');
      return Nota(partes[0], partes[1]);
    }).toList();
  }

  // * Guardar notas *
  void _guardarNotasEnArchivo() {
    final lines =
        _notas.map((nota) => '${nota.titulo}|${nota.contenido}').toList();
    _archivoNotas.writeAsStringSync(lines.join('\n'));
  }

  // * Agregar notas *
  void agregarNota(String titulo, String contenido) {
    _notas.add(Nota(titulo, contenido));
    _guardarNotasEnArchivo();
  }

  // * Mostrar notas *
  void listarNotas() {
    if (_notas.isEmpty) {
      print('No hay notas disponibles.');
    } else {
      for (var i = 0; i < _notas.length; i++) {
        print("Nota ${i + 1}:");
        print("Título: ${_notas[i].titulo}");
        print("Contenido: ${_notas[i].contenido}");
        print("Fecha de creación: ${_notas[i].fechaCreacion}");
        print("--------------------");
      }
    }
  }

  // ! Eliminar notas !
  void eliminarNota(String titulo) {
    final notaAEliminar = _notas.firstWhere(
      (nota) => nota.titulo == titulo,
      orElse: () =>
          Nota('', ''), // Devolvemos una nota vacía si no se encuentra
    );

    if (notaAEliminar.titulo.isNotEmpty) {
      _notas.remove(notaAEliminar);
      _guardarNotasEnArchivo();
      print('Nota eliminada correctamente.');
    } else {
      print('No se encontró ninguna nota con el título especificado.');
    }
  }

  // * Buscar notas *
  void buscarNotas(String textoABuscar) {
    final notasEncontradas = _notas.where((nota) =>
        nota.titulo.toLowerCase().contains(textoABuscar.toLowerCase()) ||
        nota.contenido.toLowerCase().contains(textoABuscar.toLowerCase()));

    if (notasEncontradas.isNotEmpty) {
      print('Notas encontradas:');
      for (var i = 0; i < notasEncontradas.length; i++) {
        print("Nota ${i + 1}:");
        print("Título: ${notasEncontradas.elementAt(i).titulo}");
        print("Contenido: ${notasEncontradas.elementAt(i).contenido}");
        print(
            "Fecha de creación: ${notasEncontradas.elementAt(i).fechaCreacion}");
        print("--------------------");
      }
    } else {
      print(
          'No se encontraron notas que coincidan con el texto proporcionado.');
    }
  }
}

void main(List<String> args) {
  final gestorDeNotas = GestorDeNotas();

  // ! Lógica para interpretar los argumentos de la línea de comandos !

  if (args.isNotEmpty) {
    final comando = args[0];
    switch (comando) {
      case 'agregar': // Agragar
        if (args.length >= 3) {
          final titulo = args[1];
          final contenido = args.sublist(2).join(' ');
          gestorDeNotas.agregarNota(titulo, contenido);
          print('Nota agregada con éxito.');
        } else {
          print('Uso: notas agregar <título> <contenido>');
        }
        break;

      case 'listar': // Listar
        gestorDeNotas.listarNotas();
        break;

      case 'eliminar': // Eliminar
        if (args.length == 2) {
          final titulo = args[1];
          gestorDeNotas.eliminarNota(titulo);
        } else {
          print('Uso: notas eliminar <título>');
        }
        break;

      case 'buscar': // Buscar
        if (args.length == 2) {
          final textoABuscar = args[1];
          gestorDeNotas.buscarNotas(textoABuscar);
        } else {
          print('Uso: notas buscar <textoABuscar>');
        }
        break;

      default: // Cualquier otra cosa
        print('Comando no reconocido.');
    }
  } else {
    print('Uso: notas <comando>');
    print('Comandos disponibles: agregar, listar, eliminar, buscar');
  }
}

/*
* Made by TLT (TasteLessTree)
*/
