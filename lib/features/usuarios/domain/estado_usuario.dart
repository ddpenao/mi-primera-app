import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mi_papp/core/json.dart';

part 'estado_usuario.freezed.dart';

@Freezed(unionKey: 'tipo', unionValueCase: FreezedUnionCase.snake)
sealed class EstadoUsuario with _$EstadoUsuario {
  const EstadoUsuario._();

  const factory EstadoUsuario.activo() = Activo;
  const factory EstadoUsuario.configurando(String pasoActual) = Configurando;
  const factory EstadoUsuario.inactivo(String motivo) = Inactivo;

  factory EstadoUsuario.fromJson(Map<String, dynamic> json) {
    final tipo = leerTexto(json, 'tipo');
    return switch (tipo) {
      'activo' => const EstadoUsuario.activo(),
      'configurando' => EstadoUsuario.configurando(
        leerTexto(json, 'pasoActual'),
      ),
      'inactivo' => EstadoUsuario.inactivo(leerTexto(json, 'motivo')),
      _ => throw CampoInvalido('estado.tipo', 'no es un estado conocido', tipo),
    };
  }

  Map<String, dynamic> toJson() => switch (this) {
    Activo() => {'tipo': 'activo'},
    Configurando(:final pasoActual) => {
      'tipo': 'configurando',
      'pasoActual': pasoActual,
    },
    Inactivo(:final motivo) => {'tipo': 'inactivo', 'motivo': motivo},
  };

  bool get sePuedeEditar => switch (this) {
    Activo() || Configurando() => true,
    Inactivo() => false,
  };

  String get etiqueta => switch (this) {
    Activo() => 'Activo',
    Configurando(:final pasoActual) => 'Configurando · $pasoActual',
    Inactivo(:final motivo) => 'Inactivo: $motivo',
  };
}
