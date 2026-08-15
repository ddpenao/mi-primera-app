import 'package:mi_papp/features/usuarios/domain/usuario.dart';

abstract interface class UsuariosRepository {
  Future<List<Usuario>> obtenerTodos();

  Future<Usuario?> obtenerPorId(String id);

  Future<List<Usuario>> obtenerPorEstado(String tipo);
}
