import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mi_papp/core/json.dart';
import 'package:mi_papp/features/usuarios/domain/usuario.dart';
import 'package:mi_papp/features/usuarios/domain/usuarios_repository.dart';

typedef LectorDeAssets = Future<String> Function(String ruta);

class UsuariosLocales implements UsuariosRepository {
  UsuariosLocales({
    LectorDeAssets? lector,
    this.ruta = 'assets/data/usuarios.json',
  }) : _lector = lector ?? rootBundle.loadString;

  final LectorDeAssets _lector;

  final String ruta;

  List<Usuario>? _cache;

  @override
  Future<List<Usuario>> obtenerTodos() async {
    final guardado = _cache;

    if (guardado != null) {
      return guardado;
    }

    final crudo = await _lector(ruta);

    final decodificado = jsonDecode(crudo);

    if (decodificado is! List) {
      throw const CampoInvalido(
        '(raíz)',
        'el archivo debe contener una lista',
        null,
      );
    }

    final usuarios = decodificado
        .map((e) => Usuario.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    _cache = usuarios;

    return usuarios;
  }

  @override
  Future<Usuario?> obtenerPorId(String id) async {
    final usuarios = await obtenerTodos();

    for (final usuario in usuarios) {
      if (usuario.id == id) {
        return usuario;
      }
    }

    return null;
  }

  @override
  Future<List<Usuario>> obtenerPorEstado(String tipo) async {
    final usuarios = await obtenerTodos();

    return usuarios
        .where((usuario) => usuario.estado.etiqueta == tipo)
        .toList(growable: false);
  }
}
