import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mi_papp/core/json.dart';
import 'package:mi_papp/features/usuarios/domain/preferencia_horaria.dart';
import 'package:mi_papp/features/usuarios/domain/estado_usuario.dart';

part 'usuario.freezed.dart';

@Freezed(fromJson: false, toJson: false)
abstract class Usuario with _$Usuario {
  const factory Usuario({
    required String id,
    required String nombre,
    String? correo,
    required DateTime creadoEn,
    required PreferenciaHoraria preferenciaHoraria,
    required EstadoUsuario estado,
  }) = _Usuario;

  const Usuario._();

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: leerTexto(json, 'id'),
    nombre: leerTexto(json, 'nombre'),
    correo: leerTextoOpcional(json, 'correo'),
    creadoEn: leerFecha(json, 'creadoEn'),
    preferenciaHoraria: PreferenciaHoraria.fromJson(
      leerMapa(json, 'preferenciaHoraria'),
    ),
    estado: EstadoUsuario.fromJson(leerMapa(json, 'estado')),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    if (correo != null) 'correo': correo,
    'creadoEn': creadoEn.toUtc().toIso8601String(),
    'preferenciaHoraria': preferenciaHoraria.toJson(),
    'estado': estado.toJson(),
  };

  bool get tieneCorreo => correo != null && correo!.trim().isNotEmpty;

  bool estaVencido(DateTime ahora) =>
      ahora.difference(creadoEn) > const Duration(days: 365);

  bool get sePuedeEditar => estado.sePuedeEditar;
}
