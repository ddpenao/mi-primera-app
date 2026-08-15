import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_papp/core/json.dart';
import 'package:mi_papp/features/usuarios/domain/estado_usuario.dart';
import 'package:mi_papp/features/usuarios/domain/preferencia_horaria.dart';
import 'package:mi_papp/features/usuarios/domain/usuario.dart';

Usuario ejemplo({String? correo = 'daniel@gmail.com', EstadoUsuario? estado}) =>
    Usuario(
      id: 'usr-001',
      nombre: 'Daniel',
      correo: correo,
      creadoEn: DateTime.utc(2026, 8, 15, 19, 0),
      preferenciaHoraria: const PreferenciaHoraria(
        horaInicioDia: '06:00',
        horaFinDia: '23:00',
        minutosRecordatorio: 15,
      ),
      estado: estado ?? const Activo(),
    );

void main() {
  group('serialización', () {
    test('un usuario sobrevive la ida y vuelta a JSON sin perder nada', () {
      final original = ejemplo(
        estado: const Configurando('preferencias_horarias'),
      );

      final texto = jsonEncode(original.toJson());

      final vuelta = Usuario.fromJson(
        jsonDecode(texto) as Map<String, dynamic>,
      );

      expect(vuelta, equals(original));
    });

    test('un usuario sin correo se lee correctamente', () {
      final json = ejemplo(correo: null).toJson();

      json.remove('correo');

      final usuario = Usuario.fromJson(json);

      expect(usuario.correo, isNull);
      expect(usuario.tieneCorreo, isFalse);
    });

    test('un usuario sin nombre dice qué campo falló', () {
      final json = ejemplo().toJson();

      json.remove('nombre');

      expect(
        () => Usuario.fromJson(json),
        throwsA(isA<CampoInvalido>().having((e) => e.campo, 'campo', 'nombre')),
      );
    });

    test('una fecha que no es ISO 8601 se rechaza', () {
      final json = ejemplo().toJson();

      json['creadoEn'] = '15 de agosto de 2026';

      expect(() => Usuario.fromJson(json), throwsA(isA<CampoInvalido>()));
    });

    test('la fecha de creación se conserva en UTC', () {
      final json = ejemplo().toJson();

      expect(json['creadoEn'], '2026-08-15T19:00:00.000Z');
    });
  });

  group('igualdad', () {
    test('dos usuarios con los mismos datos son iguales', () {
      expect(ejemplo(), equals(ejemplo()));
    });

    test('dos usuarios con los mismos datos comparten hashCode', () {
      expect(ejemplo().hashCode, equals(ejemplo().hashCode));

      expect({ejemplo(), ejemplo()}.length, 1);
    });

    test('dos usuarios con correos distintos no son iguales', () {
      expect(
        ejemplo(correo: 'daniel@gmail.com'),
        isNot(equals(ejemplo(correo: 'otro@gmail.com'))),
      );
    });

    test('copyWith cambia solo lo que se le pasa', () {
      final original = ejemplo();

      final copia = original.copyWith(nombre: 'Daniel Nuevo');

      expect(copia.nombre, 'Daniel Nuevo');

      expect(copia.id, original.id);

      expect(copia.creadoEn, original.creadoEn);

      expect(copia.correo, original.correo);
      expect(copia.preferenciaHoraria, original.preferenciaHoraria);
      expect(copia.estado, original.estado);
    });
  });

  group('reglas de negocio', () {
    test('un usuario con correo tiene información de contacto', () {
      expect(ejemplo(correo: 'daniel@gmail.com').tieneCorreo, isTrue);
    });

    test('un usuario sin correo no tiene información de contacto', () {
      expect(ejemplo(correo: null).tieneCorreo, isFalse);
    });

    test('un usuario creado hace más de un año está vencido', () {
      final ahora = DateTime.utc(2027, 8, 16);

      expect(ejemplo().estaVencido(ahora), isTrue);
    });
  });
}
