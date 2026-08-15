import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mi_papp/core/json.dart';

part 'preferencia_horaria.freezed.dart';

@Freezed(fromJson: false, toJson: false)
abstract class PreferenciaHoraria with _$PreferenciaHoraria {
  const factory PreferenciaHoraria({
    required String horaInicioDia,
    required String horaFinDia,
    required int minutosRecordatorio,
  }) = _PreferenciaHoraria;

  const PreferenciaHoraria._();

  factory PreferenciaHoraria.fromJson(Map<String, dynamic> json) =>
      PreferenciaHoraria(
        horaInicioDia: leerTexto(json, 'horaInicioDia'),
        horaFinDia: leerTexto(json, 'horaFinDia'),
        minutosRecordatorio: leerEntero(json, 'minutosRecordatorio'),
      );

  Map<String, dynamic> toJson() => {
    'horaInicioDia': horaInicioDia,
    'horaFinDia': horaFinDia,
    'minutosRecordatorio': minutosRecordatorio,
  };
}
